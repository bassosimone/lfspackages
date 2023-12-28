pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/oniguruma-6.9.9"
}

pkg_build() {
    pkg_lib_download https://github.com/kkos/oniguruma/releases/download/v6.9.9/onig-6.9.9.tar.gz
    pkg_lib_verify onig-6.9.9.tar.gz 60162bd3b9fc6f4886d4c7a07925ffd374167732f55dce8c491bfd9cd818a6cf
    pkg_lib_extract onig-6.9.9.tar.gz

    pkg_lib_run cd onig-6.9.9

    pkg_lib_run ./configure --prefix=/opt/package/oniguruma-6.9.9

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib; do
        pkg_lib_symlink_all /opt/package/oniguruma-6.9.9/$dirname /opt/$dirname
    done
}
