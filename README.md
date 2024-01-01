# Linux From Scratch packages

Scripts to install extra packages in a Linux From Scratch environment.

We use [BLFS v12.0-systemd](https://www.linuxfromscratch.org/blfs/view/12.0-systemd/).

## Installing dependencies

If you created the base system using [bassosimone/lfsbootstrap](
https://github.com/bassosimone/lfsbootstrap), you already have
all the required dependencies.

## Installing packages

To install GNU which 2.21, you would use the following command:

```sh
./bin/pkg_install ./ports/g/gnu-which/gnu-which-2.21
```

It will download the package sources and its dependencies, compile, install
at `/opt/packages/gnu-which-2.21` and symlink binaries, headers, dynamic
libraries and documentation at `/opt/{bin,include,lib,share}`.

Use a similar pattern to install other packages.

## Updating packages

Run

```sh
./homebrew/libexec/sync
```

to synchronize our local cache of packages that would be installed by
the [homebrew](https://brew.sh) package manager.

(We name packages using the same names utilized by [homebrew](https://brew.sh),
which simplifies checking for updates.)

Then run

```sh
./homebrew/libexec/check.py
```

to check which packages need updating.

Update the corresponding files in the [ports](ports) directory to download and
install the new versions, cross checking build instructions and package
dependencies with the [BLFS book](https://www.linuxfromscratch.org/blfs/view/12.0-systemd/).

Then, it's time to recompile and reinstall, for which we use the `pkg_upgrade` tool.

Assuming `gnu-which` needs to be updated to `v2.22`, you would run:

```sh
./bin/pkg_upgrade ./ports/g/gnu-which/gnu-which-2.22
```

This command would compile and reinstall the package and all its
reverse dependencies in the correct order.

Use the `-n` flag to see what commands would be run:

```sh
./bin/pkg_upgrade -n ./ports/g/gnu-which/gnu-which-2.22
```

## Low-level commands

To see package dependencies, use the `pkg_deps` tool, e.g.:

```sh
./bin/pkg_deps ./ports/g/gnupg/gnupg-2.4.3
```

To recompile and install a single package, e.g, `gnu-which-2.21`, use:

```sh
./bin/pkg_build ./ports/g/gnu-which/gnu-which-2.21
```

This command would recompile and install under `/opt/packages` but
would not symlink into the `/opt` directory.

To symlink the package to `/opt`, use:

```sh
./bin/pkg_link ./ports/g/gnu-which/gnu-which-2.21
```

Beware that over time some broken symlinks may accumulate under `/opt`
as packages are updated. You should use:

```sh
find /opt -xtype l
```

To see all the broken symlinks.

To remove a package just `rm -rf /opt/package/DIR` where DIR is the
directory where we installed it and then check for broken links
using the above `find` command and remove them all.

## Run unit tests

Run:

```sh
./bin/pkg_test_all
```

and then verify that there are no unexpected changes in [testdata](testdata).

## Architecture

* [bin](bin) contains user commands to manage packages and run tests;
* [homebrew](homebrew) leverages [homebrew](https://brew.sh) to know when
we need to update a package;
* [lib](lib) contains shared code;
* [libexec](libexec) contains scripts that users should not run directly;
* [ports](ports) contains a definition of each package build rule;
* [testdata](testdata) contains test data.

## Implementation details

The [lib/core.bash](lib/core.bash) contains library functions for
building packages. Before building a specific package, library code
imports default build functions and variables from the
[lib/basepackage.bash](lib/basepackage.bash) file. These build
functions expect the rule to build each package to define
specific variables and possibly ocverride the default functions,
as described below.

The rule to build each package lives in the package directory, e.g.,
`./ports/g/gnu-which/gnu-which-2.21`, as a bash script named `package.bash`. In
most cases the `package.bash` file only needs to define specific variables
without overriding any function, but obviously there are exceptions.

Here's an example based on code to build gnupg that was current on 2024-01-1:

```bash
__pkg_sha256=a271ae6d732f6f4d80c258ad9ee88dd9c94c8fdc33c3e45328c4d7c126bd219d
__pkg_name=gnupg
__pkg_version=2.4.3
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.bz2
__pkg_tarball_url=https://www.gnupg.org/ftp/gcrypt/${__pkg_name}/${__pkg_tarball_name}
__pkg_configure_extra_args=(
    --docdir=${__pkg_install_prefix}/${__pkg_distro_name}/share/doc/${__pkg_distro_name}
)
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/l/libassuan/libassuan-2.5.6
    ./ports/l/libgcrypt/libgcrypt-1.10.3
    ./ports/l/libksba/libksba-1.6.5
    ./ports/p/pinentry/pinentry-1.2.1
    ./ports/n/npth/npth-1.6
)
__pkg_link_dirs=(bin libexec sbin share)
__pkg_maybe_copy_persistent_config=()
```

Here we don't need to override any specific build function and we just need
to initialize `__pkg_` prefixed variables used by the default `pkg_build` function
defined by [basepackage.bash](lib/basepackage.bash).

The `__pkg_build_type` value, i.e., `autotools`, is such that the `pkg_build`
function uses the default rules for building using GNU autotools (which boils down
to something like `./configure && make && sudo make install`).

Here's another example where we need to override the `pkg_build` function:

```bash
__pkg_sha256=cfa9faf659f2ed6b38e7a7c3fb43e177d00edbacc6265e6e32215ff40e3793c0
__pkg_name=pass
__pkg_version=1.7.4
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=password-store-${__pkg_version}
__pkg_tarball_name=password-store-${__pkg_version}.tar.xz
__pkg_tarball_url=https://git.zx2c4.com/password-store/snapshot/${__pkg_tarball_name}
__pkg_deps=(
    ./ports/g/gnupg/gnupg-2.4.3
    ./ports/q/qrencode/qrencode-4.1.1
    ./ports/t/tree/tree-2.1.1
)
__pkg_link_dirs=(bin lib share)
__pkg_maybe_copy_persistent_config=()

pkg_build() {
    pkg_lib_download ${__pkg_tarball_url}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}

    pkg_lib_run sudo make PREFIX=${__pkg_install_prefix}/${__pkg_distro_name} WITH_ALLCOMP=yes install
}
```

Note how the `__pkg_deps` bash array lists the dependencies and how
the `__pkg_link_dirs` tells [bin/pkg_link](bin/pkg_link) which directories
of the installed package contains files to symlink into `/opt`. We are
instructing core libraries to recursively symlink any file inside the
`bin`, `opt`, and `share` directories of the package installation
directory, i.e., `/opt/package/pass-1.7.4`.
