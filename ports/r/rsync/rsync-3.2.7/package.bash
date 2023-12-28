pkg_print_deps() {
    echo ""
}

__pkg_sha256=4e7d9d3f6ed10878c58c5fb724a67dacf4b6aac7340b13e488fb2dc41346f2bb
__pkg_name=rsync
__pkg_version=3.2.7
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.gz

pkg_print_destdir() {
    echo /opt/package/$__pkg_distro_name
}

pkg_build() {
    pkg_lib_download https://rsync.samba.org/ftp/rsync/${__pkg_tarball_name}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}

    pkg_lib_run ./configure \
        --prefix=/opt/package/${__pkg_distro_name} \
        --disable-lz4 \
        --disable-xxhash \
        --without-included-zlib

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin share; do
        pkg_lib_symlink_all /opt/package/${__pkg_distro_name}/$dirname /opt/$dirname
    done
}
