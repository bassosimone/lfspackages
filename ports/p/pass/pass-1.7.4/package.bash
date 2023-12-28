__pkg_sha256=cfa9faf659f2ed6b38e7a7c3fb43e177d00edbacc6265e6e32215ff40e3793c0
__pkg_name=pass
__pkg_version=1.7.4
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=password-store-${__pkg_version}
__pkg_tarball_name=password-store-${__pkg_version}.tar.xz
__pkg_tarball_url=https://git.zx2c4.com/password-store/snapshot/${__pkg_tarball_name}
__pkg_deps=(
    ./ports/g/gnupg/gnupg-2.4.3
    ./ports/q/qrencode/qrencode-4.1.1
    ./ports/t/tree/tree-2.1.1
)
__pkg_link_dirs=(bin lib share)
__pkg_maybe_copy_persistent_config=()

pkg_build() {
    pkg_lib_download ${__pkg_tarball_url}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}

    pkg_lib_run sudo make PREFIX=/opt/package/${__pkg_distro_name} WITH_ALLCOMP=yes install
}
