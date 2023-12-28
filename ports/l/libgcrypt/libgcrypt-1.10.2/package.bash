pkg_print_deps() {
    deps=(
        ./ports/l/libgpg-error-1.4.7
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/libgcrypt-1.10.2"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.2.tar.bz2
    pkg_lib_verify libgcrypt-1.10.2.tar.bz2 3b9c02a004b68c256add99701de00b383accccf37177e0d6c58289664cce0c03
    pkg_lib_extract libgcrypt-1.10.2.tar.bz2

    pkg_lib_run cd libgcrypt-1.10.2

    pkg_lib_run ./configure --prefix=/opt/package/libgcrypt-1.10.2
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/libgcrypt-1.10.2/$dirname /opt/$dirname
    done
}
