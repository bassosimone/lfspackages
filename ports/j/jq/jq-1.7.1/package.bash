pkg_print_deps() {
    deps=(
        ./ports/o/oniguruma/oniguruma-6.9.9
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/jq-1.7.1"
}

pkg_build() {
    pkg_lib_download https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz
    pkg_lib_verify jq-1.7.1.tar.gz 478c9ca129fd2e3443fe27314b455e211e0d8c60bc8ff7df703873deeee580c2
    pkg_lib_extract jq-1.7.1.tar.gz

    pkg_lib_run cd jq-1.7.1

    pkg_lib_run ./configure --prefix=/opt/package/jq-1.7.1

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/jq-1.7.1/$dirname /opt/$dirname
    done
}
