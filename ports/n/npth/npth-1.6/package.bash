pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/npth-1.6"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/npth/npth-1.6.tar.bz2
    pkg_lib_verify npth-1.6.tar.bz2 1393abd9adcf0762d34798dc34fdcf4d0d22a8410721e76f1e3afcd1daa4e2d1
    pkg_lib_extract npth-1.6.tar.bz2

    pkg_lib_run cd npth-1.6

    pkg_lib_run ./configure --prefix=/opt/package/npth-1.6
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/npth-1.6/$dirname /opt/$dirname
    done
}
