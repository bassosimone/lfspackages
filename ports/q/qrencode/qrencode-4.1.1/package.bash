pkg_print_deps() {
    deps=(
        ./ports/l/libpng-1.6.40
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/qrencode-4.1.1"
}

pkg_build() {
    pkg_lib_download https://fukuchi.org/works/qrencode/qrencode-4.1.1.tar.gz
    pkg_lib_verify qrencode-4.1.1.tar.gz da448ed4f52aba6bcb0cd48cac0dd51b8692bccc4cd127431402fca6f8171e8e
    pkg_lib_extract qrencode-4.1.1.tar.gz

    pkg_lib_run cd qrencode-4.1.1

    pkg_lib_run ./configure --prefix=/opt/package/qrencode-4.1.1

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/qrencode-4.1.1/$dirname /opt/$dirname
    done
}
