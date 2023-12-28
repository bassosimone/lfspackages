__pkg_sha256=d8ddce1bb7e898986f9d250ccae7c09ce14d82f1009046d202a0eb1b428b2adc
__pkg_name=p11-kit
__pkg_version=0.25.3
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.xz
__pkg_tarball_url=https://www.gnupg.org/ftp/gcrypt/${__pkg_name}/${__pkg_tarball_name}
__pkg_deps=(
    ./ports/l/libtasn1/libtasn1-4.19.0
)
__pkg_link_dirs=(bin include lib libexec share)
__pkg_maybe_copy_persistent_config=(etc)

pkg_build() {
    pkg_lib_download https://github.com/p11-glue/${__pkg_name}/releases/download/${__pkg_version}/${__pkg_tarball_name}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd p11-kit-0.25.3

    pkg_lib_run sed 's/if (gi/& \&\& gi != C_GetInterface/' -i p11-kit/modules.c

    pkg_lib_run mkdir p11-build
    pkg_lib_run cd p11-build

    pkg_lib_run meson setup .. \
        --prefix=${__pkg_install_prefix}/${__pkg_distro_name} \
        --buildtype=release \
        -Dtrust_paths=/etc/ssl/cert.pem \
        -Dsystemd=disabled

    pkg_lib_run ninja

    pkg_lib_run sudo ninja install
    pkg_lib_run sudo find ${__pkg_install_prefix}/${__pkg_distro_name}/etc -type f -exec mv {} {}.new \;
}
