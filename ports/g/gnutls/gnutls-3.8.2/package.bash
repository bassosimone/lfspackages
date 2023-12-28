pkg_print_deps() {
    deps=(
        ./ports/l/libunistring/libunistring-1.1
        ./ports/n/nettle/nettle-3.9.1
        ./ports/p/p11-kit/p11-kit-0.25.3
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/gnutls-3.8.2"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/gnutls/v3.8/gnutls-3.8.2.tar.xz
    pkg_lib_verify gnutls-3.8.2.tar.xz e765e5016ffa9b9dd243e363a0460d577074444ee2491267db2e96c9c2adef77
    pkg_lib_extract gnutls-3.8.2.tar.xz

    pkg_lib_run cd gnutls-3.8.2

    pkg_lib_run ./configure --prefix=/opt/package/gnutls-3.8.2 \
        --docdir=/opt/package/gnutls-3.8.2/share/doc/gnutls-3.8.2 \
        --disable-static \
        --with-default-trust-store-pkcs11="pkcs11:"

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/gnutls-3.8.2/$dirname /opt/$dirname
    done
}
