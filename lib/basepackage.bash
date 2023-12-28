__pkg_install_prefix=/opt/package
__pkg_link_prefix=/opt

pkg_print_deps() {
    echo "${__pkg_deps[@]}"
}

#doc: pkg_print_destdir is the default implementation of the
# function print the package destination directory.
pkg_print_destdir() {
    echo $__pkg_install_prefix/${__pkg_distro_name}
}

pkg_build_autotools() {
    pkg_lib_download ${__pkg_tarball_url}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}

    pkg_lib_run ./configure --prefix=${__pkg_install_prefix}/${__pkg_distro_name} \
        ${__pkg_configure_extra_args[@]}

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}

pkg_build_gotoolchain() {
    pkg_lib_download ${__pkg_tarball_url}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}/src

    pkg_lib_run export GOROOT_BOOTSTRAP=/usr
    pkg_lib_run ./make.bash
    pkg_lib_run unset GOROOT_BOOSTRAP

    pkg_lib_run cd ../..

    pkg_lib_run sudo chown root:root ${__pkg_src_name}
    pkg_lib_run sudo mv ${__pkg_src_name} ${__pkg_distro_name}
    pkg_lib_run sudo rm -rf ${__pkg_install_prefix}/${__pkg_distro_name}
    pkg_lib_run sudo install -d ${__pkg_install_prefix}
    pkg_lib_run sudo mv ${__pkg_distro_name} ${__pkg_install_prefix}
}

pkg_build() {
    pkg_build_${__pkg_build_type}
}

pkg_link() {
    for dirname in ${__pkg_link_dirs[@]}; do
        pkg_lib_symlink_all \
            ${__pkg_install_prefix}/${__pkg_distro_name}/$dirname \
            ${__pkg_link_prefix}/$dirname
    done

    for dirname in ${__pkg_maybe_copy_persistent_config[@]}; do
        pkg_lib_maybe_copy_etc_all \
            ${__pkg_install_prefix}/${__pkg_distro_name}/$dirname \
            ${__pkg_link_prefix}/$dirname
    done
}
