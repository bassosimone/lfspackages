pkg_print_deps() {
    deps=(
        ./ports/l/libassuan/libassuan-2.5.6
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/pinentry-1.2.1"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.2.1.tar.bz2
    pkg_lib_verify pinentry-1.2.1.tar.bz2 457a185e5a85238fb945a955dc6352ab962dc8b48720b62fc9fa48c7540a4067
    pkg_lib_extract pinentry-1.2.1.tar.bz2

    pkg_lib_run cd pinentry-1.2.1

    pkg_lib_run ./configure --prefix=/opt/package/pinentry-1.2.1 --enable-pinentry-tty
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin share; do
        pkg_lib_symlink_all /opt/package/pinentry-1.2.1/$dirname /opt/$dirname
    done
}
