__pkg_sha256=ccfeff981b0ca71bbd6fbcb054f407c60ffb644389a5be80d6716d5b550c6ce3
__pkg_name=nettle
__pkg_version=3.9.1
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.gz
__pkg_tarball_url=https://ftp.gnu.org/gnu/nettle/${__pkg_tarball_name}
__pkg_configure_extra_args=(
    --disable-static
)
__pkg_deps=()
__pkg_link_dirs=(bin include lib share)
__pkg_maybe_copy_persistent_config=()

pkg_build() {
    pkg_build_autotools
    pkg_lib_run sudo chmod +x /opt/package/nettle-3.9.1/lib/libhogweed.so.6.8
    pkg_lib_run sudo chmod +x /opt/package/nettle-3.9.1/lib/libnettle.so.8.8
}
