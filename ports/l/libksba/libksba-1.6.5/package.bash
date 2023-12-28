pkg_print_deps() {
    deps=(
        ./ports/l/libgpg-error/libgpg-error-1.47
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/libksba-1.6.5"
}

pkg_build() {
    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/libksba/libksba-1.6.5.tar.bz2
    pkg_lib_verify libksba-1.6.5.tar.bz2 a564628c574c99287998753f98d750babd91a4e9db451f46ad140466ef2a6d16
    pkg_lib_extract libksba-1.6.5.tar.bz2

    pkg_lib_run cd libksba-1.6.5

    pkg_lib_run ./configure --prefix=/opt/package/libksba-1.6.5
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in include lib share; do
        pkg_lib_symlink_all /opt/package/libksba-1.6.5/$dirname /opt/$dirname
    done
}
