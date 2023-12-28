pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/gnu-which-2.21"
}

__pkg_sha256=f4a245b94124b377d8b49646bf421f9155d36aa7614b6ebf83705d3ffc76eaad
__pkg_name=which
__pkg_version=2.21
__pkg_distro_name=gnu-${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.gz

pkg_build() {
    pkg_lib_download https://ftp.gnu.org/gnu/which/${__pkg_tarball_name}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}

    pkg_lib_run ./configure --prefix=/opt/package/${__pkg_distro_name}
    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_link() {
    pkg_lib_symlink /opt/package/${__pkg_distro_name}/bin/which /opt/bin/which
    pkg_lib_symlink /opt/package/${__pkg_distro_name}/share/man/man1/which.1 /opt/share/man/man1/which.1
}
