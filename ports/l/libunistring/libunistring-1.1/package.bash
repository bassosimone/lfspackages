pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/libunistring-1.1"
}

pkg_build() {
    pkg_lib_download https://ftp.gnu.org/gnu/libunistring/libunistring-1.1.tar.xz
    pkg_lib_verify libunistring-1.1.tar.xz 827c1eb9cb6e7c738b171745dac0888aa58c5924df2e59239318383de0729b98
    pkg_lib_extract libunistring-1.1.tar.xz

    pkg_lib_run cd libunistring-1.1

    pkg_lib_run ./configure --prefix=/opt/package/libunistring-1.1 --disable-static \
        --docdir=/opt/package/libunistring-1.1/share/doc/libunistring-1.1
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in include lib share; do
        pkg_lib_symlink_all /opt/package/libunistring-1.1/$dirname /opt/$dirname
    done
}
