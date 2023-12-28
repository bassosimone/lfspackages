pkg_print_deps() {
    deps=(
        ./ports/l/libgpg-error-1.4.7
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/libksba-1.6.4"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.6.4.tar.bz2
    pkg_lib_verify libksba-1.6.4.tar.bz2 bbb43f032b9164d86c781ffe42213a83bf4f2fee91455edfa4654521b8b03b6b
    pkg_lib_extract libksba-1.6.4.tar.bz2

    pkg_lib_run cd libksba-1.6.4

    pkg_lib_run ./configure --prefix=/opt/package/libksba-1.6.4
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in include lib share; do
        pkg_lib_symlink_all /opt/package/libksba-1.6.4/$dirname /opt/$dirname
    done
}
