__pkg_sha256=e9fd27218d5394904e4e39788f9b1742711c3e6b41689a31aa3380bd5aa4f426
__pkg_name=libassuan
__pkg_version=2.5.6
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.bz2
__pkg_tarball_url=https://www.gnupg.org/ftp/gcrypt/${__pkg_name}/${__pkg_tarball_name}
__pkg_configure_extra_args=()
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/l/libgpg-error/libgpg-error-1.47
)
__pkg_link_dirs=(bin include lib share)
__pkg_maybe_copy_persistent_config=()
