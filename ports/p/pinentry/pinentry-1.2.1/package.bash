__pkg_sha256=457a185e5a85238fb945a955dc6352ab962dc8b48720b62fc9fa48c7540a4067
__pkg_name=pinentry
__pkg_version=1.2.1
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.bz2
__pkg_tarball_url=https://www.gnupg.org/ftp/gcrypt/${__pkg_name}/${__pkg_tarball_name}
__pkg_configure_extra_args=(
    --enable-pinentry-tty
)
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/l/libassuan/libassuan-2.5.6
)
__pkg_link_dirs=(bin share)
__pkg_maybe_copy_persistent_config=()
