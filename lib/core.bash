#doc: pkg_lib_run COMMAND ARGS... logs and runs the given command with arguments.
pkg_lib_run() {
    echo "🐚 $@" 1>&2
    "$@"
}

#doc: pkg_lib_info ARGS... logs an informational message to stderr.
pkg_lib_info() {
    echo "🗒️ $@" 1>&2
}

#doc: pkg_lib_warn ARGS... logs a warning message to stderr.
pkg_lib_warn() {
    echo "️🚨 $@" 1>&2
}

#doc: pkg_lib_download URL downloads the package at URL.
pkg_lib_download() {
    local URL=$1
    pkg_lib_run curl -fsSLO $URL
}

#doc: pkg_lib_verify TARBALL SHA256 verifies a downloaded tarball.
pkg_lib_verify() {
    local tarball=$1
    local sha256=$2
    echo "$sha256  $tarball" >SHA256SUM
    pkg_lib_run cat SHA256SUM
    pkg_lib_run shasum -c SHA256SUM
    pkg_lib_run rm SHA256SUM
}

#doc: pkg_lib_extract TARBALL extracts a tarball's content.
pkg_lib_extract() {
    local tarball=$1
    pkg_lib_run tar -xf $tarball
}

#doc: pkg_lib_symlink SOURCE DEST creates a symlink
pkg_lib_symlink() {
    local source=$1
    local dest=$2
    pkg_lib_run sudo install -d $(dirname $dest)
    pkg_lib_run sudo ln -sf $source $dest
}

#doc: pkg_lib_symlink_all SOURCE DEST creates a directory in DEST
#doc: for each directory in SOURCE and then links files.
pkg_lib_symlink_all() {
    local source=$1
    local dest=$2

    pkg_lib_run sudo install -d $dest
    for dir in $(find $source -mindepth 1 -type d); do
        corename=${dir##$source}
        pkg_lib_run sudo install -d $dest/$corename
    done

    for file in $(find $source -type f -o -type l); do
        corename=${file##$source}
        pkg_lib_run sudo ln -sf $file $dest/$corename
    done
}

#doc: pkg_lib_maybe_copy_etc_all SOURCE DEST creates a directory in DEST
#doc: for each directory in SOURCE and then copies files in there if they
#doc: do not exist; otherwise, it creates .new files.
pkg_lib_maybe_copy_etc_all() {
    local source=$1
    local dest=$2

    pkg_lib_run sudo install -d $dest
    for dir in $(find $source -mindepth 1 -type d); do
        corename=${dir##$source}
        pkg_lib_run sudo install -d $dest/$corename
    done

    for file in $(find $source -type f -o -type l); do
        corename=${file##$source}
        destname=$dest/$corename
        if [[ -f $destname ]]; then
            pkg_lib_run sudo cp -p $file $dest/$corename.new
            continue
        fi
        pkg_lib_run sudo cp -p $file $dest/$corename
    done
}

# pkg_cli_build DIR [...] builds the package identified by DIR. Any
# argument passed after DIR is executed after we have built the package.
pkg_cli_build() {
    local dir_name=$1
    shift

    if [[ ! -f $dir_name/package.bash ]]; then
        echo "FATAL: $dir_name/package.bash: no such file or directory" 1>&2
        exit 1
    fi

    (
        . $dir_name/package.bash

        __destdir=$(pkg_print_destdir)
        if [[ -d $__destdir ]]; then
            pkg_lib_info "package $dir_name already installed at $__destdir"
            return
        fi

        (
            # ensure packages find the /opt alternative root
            pkg_lib_run export PKG_CONFIG_PATH="/opt/lib/pkgconfig:/usr/lib/pkgconfig"
            pkg_lib_run export CFLAGS="-I/opt/include ${CFLAGS:-}"
            pkg_lib_run export LDFLAGS="-L/opt/lib ${LDFLAGS:-}"

            WORKDIR=$(pkg_lib_run mktemp -d)

            pkg_lib_run cd $WORKDIR

            pkg_build

            pkg_lib_run rm -rf $WORKDIR
        )

        # execute the remaining arguments
        (
            if [[ $# -gt 0 ]]; then
                "$@"
            fi
        )
    )
}

# pkg_cli_link DIR links the package identified by DIR.
pkg_cli_link() {
    local dir_name=$1

    if [[ ! -f $dir_name/package.bash ]]; then
        echo "FATAL: $dir_name/package.bash: no such file or directory" 1>&2
        exit 1
    fi

    (
        . $dir_name/package.bash

        __destdir=$(pkg_print_destdir)
        if [[ ! -d $__destdir ]]; then
            pkg_lib_warn "package $dir_name not installed at $__destdir"
            return
        fi

        pkg_link
    )
}

# pkg_cli_install DIR combines pkg_cli_build and pkg_cli_link
pkg_cli_install() {
    local dir_name=$1
    pkg_cli_build $dir_name pkg_cli_link $dir_name # pipelining execution
}

# pkg_cli_install_recursive DIR installs the package defined by the
# given DIR and all its dependencies recursively.
pkg_cli_install_recursive() {
    local dir_name=$1

    if [[ ! -f $dir_name/package.bash ]]; then
        echo "FATAL: $dir_name/package.bash: no such file or directory" 1>&2
        exit 1
    fi

    (
        . $dir_name/package.bash

        for dependency in $(pkg_print_deps); do
            (
                pkg_cli_install_recursive $dependency
            )
        done
    )

    pkg_cli_install $dir_name
}

# pkg_cli_printdeps DIR prints all the deps of a package at DIR.
pkg_cli_printdeps() (
    local dir_name=$1

    if [[ ! -f $dir_name/package.bash ]]; then
        echo "FATAL: $dir_name/package.bash: no such file or directory" 1>&2
        exit 1
    fi

    . $dir_name/package.bash

    for dep in $(pkg_print_deps); do
        echo "$dep"
        pkg_cli_printdeps $dep
    done
)
