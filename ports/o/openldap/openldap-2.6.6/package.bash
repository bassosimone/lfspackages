__pkg_sha256=082e998cf542984d43634442dbe11da860759e510907152ea579bdc42fe39ea0
__pkg_name=openldap
__pkg_version=2.6.6
__pkg_deps=()
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tgz
__pkg_tarball_url=https://www.gnupg.org/ftp/gcrypt/${__pkg_name}/${__pkg_tarball_name}
__pkg_link_dirs=(include lib) # bare minimum required by gnupg
__pkg_maybe_copy_persistent_config=()

pkg_build() {
    pkg_lib_download https://www.openldap.org/software/download/OpenLDAP/openldap-release/${__pkg_tarball_name}
    pkg_lib_verify ${__pkg_tarball_name} ${__pkg_sha256}
    pkg_lib_extract ${__pkg_tarball_name}

    pkg_lib_run cd ${__pkg_src_name}

    pkg_lib_download https://www.linuxfromscratch.org/patches/blfs/12.0/openldap-${__pkg_version}-consolidated-1.patch
    pkg_lib_verify openldap-${__pkg_version}-consolidated-1.patch bb483c15fe935ae7c89bc1fe85a3f6e1a9df1381103f629d9c9cadaf00d52e34

    pkg_lib_run patch -Np1 -i openldap-${__pkg_version}-consolidated-1.patch

    pkg_lib_run autoconf

    pkg_lib_run ./configure --prefix=${__pkg_install_prefix}/${__pkg_distro_name} \
        --disable-static \
        --enable-versioning=yes \
        --disable-debug \
        --with-tls=openssl \
        --without-cyrus-sasl \
        --without-systemd \
        --enable-dynamic \
        --enable-crypt \
        --disable-spasswd \
        --enable-slapd \
        --enable-modules \
        --enable-rlookups \
        --enable-backends=mod \
        --disable-sql \
        --disable-wt \
        --enable-overlays=mod

    pkg_lib_run make -j$(nproc) depend

    pkg_lib_run make -j$(nproc)

    pkg_lib_run sudo make install
}
