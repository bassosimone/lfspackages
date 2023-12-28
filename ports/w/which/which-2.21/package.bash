pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/which-2.21"
}

pkg_build() {
    pkg_lib_download https://ftp.gnu.org/gnu/which/which-2.21.tar.gz
    pkg_lib_verify which-2.21.tar.gz f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad
    pkg_lib_extract which-2.21.tar.gz

    pkg_lib_run cd which-2.21

    pkg_lib_run ./configure --prefix=/opt/package/which-2.21
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    pkg_lib_symlink /opt/package/which-2.21/bin/which /opt/bin/which
    pkg_lib_symlink /opt/package/which-2.21/share/man/man1/which.1 /opt/share/man/man1/which.1
}