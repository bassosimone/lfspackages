__pkg_sha256=478c9ca129fd2e3443fe27314b455e211e0d8c60bc8ff7df703873deeee580c2
__pkg_name=jq
__pkg_version=1.7.1
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.gz
__pkg_tarball_url=https://github.com/jqlang/jq/releases/download/${__pkg_src_name}/${__pkg_tarball_name}
__pkg_configure_extra_args=()
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/o/oniguruma/oniguruma-6.9.9
)
__pkg_link_dirs=(bin include lib share)
__pkg_maybe_copy_persistent_config=()
