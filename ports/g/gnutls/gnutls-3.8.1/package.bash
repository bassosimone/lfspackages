pkg_print_deps() {
    deps=(
        ./ports/l/libunistring-1.1
        ./ports/n/nettle-3.9.1
        ./ports/p/p11-kit-0.25.0
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/gnutls-3.8.1"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.1.tar.xz
    pkg_lib_verify gnutls-3.8.1.tar.xz ba8b9e15ae20aba88f44661978f5b5863494316fe7e722ede9d069fe6294829c
    pkg_lib_extract gnutls-3.8.1.tar.xz

    pkg_lib_run cd gnutls-3.8.1

    pkg_lib_run ./configure --prefix=/opt/package/gnutls-3.8.1 \
        --docdir=/opt/package/gnutls-3.8.1/share/doc/gnutls-3.8.1 \
        --disable-static \
        --with-default-trust-store-pkcs11="pkcs11:"

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/gnutls-3.8.1/$dirname /opt/$dirname
    done
}
