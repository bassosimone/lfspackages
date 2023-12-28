pkg_print_deps() {
    deps=(
        ./ports/g/gnupg-2.4.3
        ./ports/q/qrencode-4.1.1
        ./ports/t/tree-2.1.1
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/pass-1.7.4"
}

pkg_build() {
    pkg_lib_download https://git.zx2c4.com/password-store/snapshot/password-store-1.7.4.tar.xz
    pkg_lib_verify password-store-1.7.4.tar.xz cfa9faf659f2ed6b38e7a7c3fb43e177d00edbacc6265e6e32215ff40e3793c0
    pkg_lib_extract password-store-1.7.4.tar.xz

    pkg_lib_run cd password-store-1.7.4

    pkg_lib_run sudo make PREFIX=/opt/package/pass-1.7.4 WITH_ALLCOMP=yes install
}

pkg_link() {
    for dirname in bin lib share; do
        pkg_lib_symlink_all /opt/package/pass-1.7.4/$dirname /opt/$dirname
    done
}
