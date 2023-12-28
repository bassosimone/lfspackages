__pkg_sha256=a564628c574c99287998753f98d750babd91a4e9db451f46ad140466ef2a6d16
__pkg_name=libksba
__pkg_version=1.6.5
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.bz2
__pkg_tarball_url=https://www.gnupg.org/ftp/gcrypt/libksba/${__pkg_tarball_name}
__pkg_configure_extra_args=()
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/l/libgpg-error/libgpg-error-1.47
)
__pkg_link_dirs=(include lib share)
__pkg_maybe_copy_persistent_config=()
