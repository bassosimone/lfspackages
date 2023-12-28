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
    ./ports/n/npth/npth-1.6
)
__pkg_link_dirs=(bin libexec sbin share)
__pkg_maybe_copy_persistent_config=()
