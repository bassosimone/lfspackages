__pkg_sha256=8b0870897ac5ac67ded568dcfadf45969cfa8a6beb0fd60af2a9eadc2a3272aa
__pkg_name=libgcrypt
__pkg_version=1.10.3
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.bz2
__pkg_tarball_url=https://www.gnupg.org/ftp/gcrypt/libgcrypt/${__pkg_tarball_name}
__pkg_configure_extra_args=()
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/l/libgpg-error/libgpg-error-1.47
)
__pkg_link_dirs=(bin include lib share)
__pkg_maybe_copy_persistent_config=()
