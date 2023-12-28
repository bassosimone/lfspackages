pkg_print_deps() {
    deps=(
        ./ports/l/libgpg-error/libgpg-error-1.47
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/libgcrypt-1.10.3"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.10.3.tar.bz2
    pkg_lib_verify libgcrypt-1.10.3.tar.bz2 8b0870897ac5ac67ded568dcfadf45969cfa8a6beb0fd60af2a9eadc2a3272aa
    pkg_lib_extract libgcrypt-1.10.3.tar.bz2

    pkg_lib_run cd libgcrypt-1.10.3

    pkg_lib_run ./configure --prefix=/opt/package/libgcrypt-1.10.3
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/libgcrypt-1.10.3/$dirname /opt/$dirname
    done
}
