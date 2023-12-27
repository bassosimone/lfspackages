pkg_print_deps() {
    deps=(
        ./ports/l/libgpg-error-1.47
    )
    echo "${deps[@]}"
}

pkg_build() {
    if [[ -d /opt/package/libassuan-2.5.6 ]]; then
        pkg_lib_info "libassuan-2.5.6: already built"
        return
    fi

    pkg_lib_download https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.6.tar.bz2
    pkg_lib_verify libassuan-2.5.6.tar.bz2 e9fd27218d5394904e4e39788f9b1742711c3e6b41689a31aa3380bd5aa4f426
    pkg_lib_extract libassuan-2.5.6.tar.bz2

    pkg_lib_run cd libassuan-2.5.6

    pkg_lib_run ./configure --prefix=/opt/package/libassuan-2.5.6
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    if [[ ! -d /opt/package/libassuan-2.5.6 ]]; then
        pkg_lib_warn "libassuan-2.5.6: not built"
        return
    fi

    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/libassuan-2.5.6/$dirname /opt/$dirname
    done
}
