pkg_print_deps() {
    deps=(
        ./ports/l/libunistring/libunistring-1.1
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/libidn2-2.3.4"
}

pkg_build() {
    pkg_lib_download https://ftp.gnu.org/gnu/libidn/libidn2-2.3.4.tar.gz
    pkg_lib_verify libidn2-2.3.4.tar.gz 93caba72b4e051d1f8d4f5a076ab63c99b77faee019b72b9783b267986dbb45f
    pkg_lib_extract libidn2-2.3.4.tar.gz

    pkg_lib_run cd libidn2-2.3.4

    pkg_lib_run ./configure --prefix=/opt/package/libidn2-2.3.4 --disable-static

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/libidn2-2.3.4/$dirname /opt/$dirname
    done
}
