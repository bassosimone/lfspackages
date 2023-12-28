pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/tree-2.1.1"
}

pkg_build() {
    pkg_lib_download https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.1.1.tar.gz
    pkg_lib_verify 2.1.1.tar.gz 1b70253994dca48a59d6ed99390132f4d55c486bf0658468f8520e7e63666a06
    pkg_lib_extract 2.1.1.tar.gz

    pkg_lib_run cd tree-2.1.1

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make MANDIR=/opt/package/tree-2.1.1/share/man \
        PREFIX=/opt/package/tree-2.1.1 install
}

pkg_link() {
    for dirname in bin share; do
        pkg_lib_symlink_all /opt/package/tree-2.1.1/$dirname /opt/$dirname
    done
}
