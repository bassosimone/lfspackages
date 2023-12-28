pkg_print_deps() {
    echo ""
}

__pkg_sha256=c25a4838fc8e4c1c8aacb8bd620edb3084a3d63bf8987fdad3ca2758c63240f9
__pkg_name=popt
__pkg_version=1.19
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.gz

pkg_print_destdir() {
    echo /opt/package/$__pkg_distro_name
}

pkg_build() {
    pkg_lib_download https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/${__pkg_tarball_name}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}

    pkg_lib_run ./configure --prefix=/opt/package/${__pkg_distro_name}

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    for dirname in bin include lib share; do
        pkg_lib_symlink_all /opt/package/${__pkg_distro_name}/$dirname /opt/$dirname
    done
}
