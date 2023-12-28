pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/libpng-1.6.40"
}

pkg_build() {
    pkg_lib_download https://downloads.sourceforge.net/project/libpng/libpng16/1.6.40/libpng-1.6.40.tar.xz
    pkg_lib_verify libpng-1.6.40.tar.xz 535b479b2467ff231a3ec6d92a525906fb8ef27978be4f66dbe05d3f3a01b3a1
    pkg_lib_extract libpng-1.6.40.tar.xz

    pkg_lib_run cd libpng-1.6.40

    pkg_lib_run ./configure --prefix=/opt/package/libpng-1.6.40

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install

    pkg_lib_run sudo rm -f /opt/package/libpng-1.6.40/lib/libpng{16,}.a
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/libpng-1.6.40/$dirname /opt/$dirname
    done
}
