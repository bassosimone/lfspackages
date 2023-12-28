pkg_print_deps() {
    deps=(
        ./ports/l/libassuan/libassuan-2.5.6
        ./ports/l/libgcrypt/libgcrypt-1.10.3
        ./ports/l/libksba/libksba-1.6.5
        ./ports/n/npth/npth-1.6
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/gnupg-2.4.3"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.4.3.tar.bz2
    pkg_lib_verify gnupg-2.4.3.tar.bz2 a271ae6d732f6f4d80c258ad9ee88dd9c94c8fdc33c3e45328c4d7c126bd219d
    pkg_lib_extract gnupg-2.4.3.tar.bz2

    pkg_lib_run cd gnupg-2.4.3

    pkg_lib_run ./configure --prefix=/opt/package/gnupg-2.4.3 \
        --docdir=/opt/package/gnupg-2.4.3/share/doc/gnupg-2.4.3

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin libexec sbin share; do
        pkg_lib_symlink_all /opt/package/gnupg-2.4.3/$dirname /opt/$dirname
    done
}
