pkg_print_deps() {
    deps=(
        ./ports/g/gnupg-2.4.3
        ./ports/l/libidn2-2.3.4
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/wget-1.21.4"
}

pkg_build() {
    pkg_lib_download https://ftp.gnu.org/gnu/wget/wget-1.21.4.tar.gz
    pkg_lib_verify wget-1.21.4.tar.gz 81542f5cefb8faacc39bbbc6c82ded80e3e4a88505ae72ea51df27525bcde04c
    pkg_lib_extract wget-1.21.4.tar.gz

    pkg_lib_run cd wget-1.21.4

    pkg_lib_run ./configure --prefix=/opt/package/wget-1.21.4

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin share; do
        pkg_lib_symlink_all /opt/package/wget-1.21.4/$dirname /opt/$dirname
    done
    pkg_lib_maybe_copy_etc_all /opt/package/wget-1.21.4/etc /opt/etc
}
