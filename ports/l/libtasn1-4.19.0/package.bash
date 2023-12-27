pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/libtasn1-4.19.0"
}

pkg_build() {
    pkg_lib_download https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.19.0.tar.gz
    pkg_lib_verify libtasn1-4.19.0.tar.gz 1613f0ac1cf484d6ec0ce3b8c06d56263cc7242f1c23b30d82d23de345a63f7a
    pkg_lib_extract libtasn1-4.19.0.tar.gz

    pkg_lib_run cd libtasn1-4.19.0

    pkg_lib_run ./configure --prefix=/opt/package/libtasn1-4.19.0 --disable-static
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/libtasn1-4.19.0/$dirname /opt/$dirname
    done
}
