pkg_print_deps() {
    echo ""
}

pkg_build() {
    if [[ -d /opt/package/nettle-3.9.1 ]]; then
        pkg_lib_info "nettle-3.9.1: already built"
        return
    fi

    pkg_lib_download https://ftp.gnu.org/gnu/nettle/nettle-3.9.1.tar.gz
    pkg_lib_verify nettle-3.9.1.tar.gz ccfeff981b0ca71bbd6fbcb054f407c60ffb644389a5be80d6716d5b550c6ce3
    pkg_lib_extract nettle-3.9.1.tar.gz

    pkg_lib_run cd nettle-3.9.1

    pkg_lib_run ./configure --prefix=/opt/package/nettle-3.9.1 --disable-static
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
    pkg_lib_run sudo chmod +x /opt/package/nettle-3.9.1/lib/libhogweed.so.6.8
    pkg_lib_run sudo chmod +x /opt/package/nettle-3.9.1/lib/libnettle.so.8.8
}

pkg_link() {
    if [[ ! -d /opt/package/nettle-3.9.1 ]]; then
        pkg_lib_warn "nettle-3.9.1: not built"
        return
    fi

    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/nettle-3.9.1/$dirname /opt/$dirname
    done
}
