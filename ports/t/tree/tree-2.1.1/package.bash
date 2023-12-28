__pkg_sha256=1b70253994dca48a59d6ed99390132f4d55c486bf0658468f8520e7e63666a06
__pkg_name=tree
__pkg_version=2.1.1
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_version}.tar.gz
__pkg_tarball_url=https://github.com/Old-Man-Programmer/tree/archive/refs/tags/${__pkg_tarball_name}
__pkg_deps=()
__pkg_link_dirs=(bin share)
__pkg_maybe_copy_persistent_config=()

pkg_build() {
    pkg_lib_download ${__pkg_tarball_url}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make \
        MANDIR=/opt/package/${__pkg_distro_name}/share/man \
        PREFIX=/opt/package/${__pkg_distro_name} \
        install
}
