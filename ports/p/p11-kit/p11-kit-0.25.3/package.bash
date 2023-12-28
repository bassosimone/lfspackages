pkg_print_deps() {
    deps=(
        ./ports/l/libtasn1/libtasn1-4.19.0
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "${__pkg_install_prefix}/p11-kit-0.25.3"
}

pkg_build() {
    pkg_lib_download https://github.com/p11-glue/p11-kit/releases/download/0.25.3/p11-kit-0.25.3.tar.xz
    pkg_lib_verify p11-kit-0.25.3.tar.xz d8ddce1bb7e898986f9d250ccae7c09ce14d82f1009046d202a0eb1b428b2adc
    pkg_lib_extract p11-kit-0.25.3.tar.xz

    pkg_lib_run cd p11-kit-0.25.3

    pkg_lib_run sed 's/if (gi/& \&\& gi != C_GetInterface/' -i p11-kit/modules.c

    pkg_lib_run mkdir p11-build
    pkg_lib_run cd p11-build

    pkg_lib_run meson setup .. \
        --prefix=${__pkg_install_prefix}/p11-kit-0.25.3 \
        --buildtype=release \
        -Dtrust_paths=/etc/ssl/cert.pem \
        -Dsystemd=disabled

    pkg_lib_run ninja

    pkg_lib_run sudo ninja install
    pkg_lib_run sudo find ${__pkg_install_prefix}/p11-kit-0.25.3/etc -type f -exec mv {} {}.new \;
}

pkg_link() {
    for dirname in bin include lib libexec share; do
        pkg_lib_symlink_all ${__pkg_install_prefix}/p11-kit-0.25.3/$dirname ${__pkg_link_prefix}/$dirname
    done

    pkg_lib_maybe_copy_etc_all ${__pkg_install_prefix}/p11-kit-0.25.3/etc ${__pkg_link_prefix}/etc
}
