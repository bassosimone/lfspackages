pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/libgpg-error-1.47"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.47.tar.bz2
    pkg_lib_verify libgpg-error-1.47.tar.bz2 9e3c670966b96ecc746c28c2c419541e3bcb787d1a73930f5e5f5e1bcbbb9bdb
    pkg_lib_extract libgpg-error-1.47.tar.bz2

    pkg_lib_run cd libgpg-error-1.47

    pkg_lib_run ./configure --prefix=/opt/package/libgpg-error-1.47
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/libgpg-error-1.47/$dirname /opt/$dirname
    done
}
