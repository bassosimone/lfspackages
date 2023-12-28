__pkg_sha256=827c1eb9cb6e7c738b171745dac0888aa58c5924df2e59239318383de0729b98
__pkg_name=libunistring
__pkg_version=1.1
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.xz
__pkg_tarball_url=https://ftp.gnu.org/gnu/libunistring/${__pkg_tarball_name}
__pkg_configure_extra_args=(
    --disable-static
    --docdir=/opt/package/${__pkg_distro_name}/share/doc/${__pkg_distro_name}
)
__pkg_build_type=autotools
__pkg_deps=()
__pkg_link_dirs=(include lib share)
__pkg_maybe_copy_persistent_config=()
