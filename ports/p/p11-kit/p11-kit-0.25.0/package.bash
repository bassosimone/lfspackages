pkg_print_deps() {
    deps=(
        ./ports/l/libtasn1/libtasn1-4.19.0
    )
    echo "${deps[@]}"
}

pkg_print_destdir() {
    echo "/opt/package/p11-kit-0.25.0"
}

pkg_build() {
    pkg_lib_download https://github.com/p11-glue/p11-kit/releases/download/0.25.0/p11-kit-0.25.0.tar.xz
    pkg_lib_verify p11-kit-0.25.0.tar.xz d55583bcdde83d86579cabe3a8f7f2638675fef01d23cace733ff748fc354706
    pkg_lib_extract p11-kit-0.25.0.tar.xz

    pkg_lib_run cd p11-kit-0.25.0

    pkg_lib_run sed 's/if (gi/& \&\& gi != C_GetInterface/' -i p11-kit/modules.c

    pkg_lib_run mkdir p11-build
    pkg_lib_run cd p11-build

    pkg_lib_run meson setup .. \
        --prefix=/opt/package/p11-kit-0.25.0 \
        --buildtype=release \
        -Dtrust_paths=/etc/ssl/cert.pem \
        -Dsystemd=disabled

    pkg_lib_run ninja

    pkg_lib_run sudo ninja install
}

pkg_link() {
    for dirname in bin include lib libexec share; do
        pkg_lib_symlink_all /opt/package/p11-kit-0.25.0/$dirname /opt/$dirname
    done

    pkg_lib_maybe_copy_etc_all /opt/package/p11-kit-0.25.0/etc /opt/etc
}
