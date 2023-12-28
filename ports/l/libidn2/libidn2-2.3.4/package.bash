__pkg_sha256=93caba72b4e051d1f8d4f5a076ab63c99b77faee019b72b9783b267986dbb45f
__pkg_name=libidn2
__pkg_version=2.3.4
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.gz
__pkg_tarball_url=https://ftp.gnu.org/gnu/libidn/${__pkg_tarball_name}
__pkg_configure_extra_args=(
    --disable-static
)
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/l/libunistring/libunistring-1.1
)
__pkg_link_dirs=(bin include lib share)
__pkg_maybe_copy_persistent_config=()
