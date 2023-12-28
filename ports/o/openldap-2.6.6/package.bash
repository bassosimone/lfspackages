pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/openldap-2.6.6"
}

pkg_build() {
    pkg_lib_download https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.6.tgz
    pkg_lib_verify openldap-2.6.6.tgz 082e998cf542984d43634442dbe11da860759e510907152ea579bdc42fe39ea0
    pkg_lib_extract openldap-2.6.6.tgz

    pkg_lib_run cd openldap-2.6.6

    pkg_lib_download https://www.linuxfromscratch.org/patches/blfs/12.0/openldap-2.6.6-consolidated-1.patch
    pkg_lib_verify openldap-2.6.6-consolidated-1.patch bb483c15fe935ae7c89bc1fe85a3f6e1a9df1381103f629d9c9cadaf00d52e34

    pkg_lib_run patch -Np1 -i openldap-2.6.6-consolidated-1.patch

    pkg_lib_run autoconf

    pkg_lib_run ./configure --prefix=/opt/package/openldap-2.6.6 \
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

pkg_link() {
    # Note: installing the minimum required by gnupg
    for dirname in include lib; do
        pkg_lib_symlink_all /opt/package/openldap-2.6.6/$dirname /opt/$dirname
    done
}
