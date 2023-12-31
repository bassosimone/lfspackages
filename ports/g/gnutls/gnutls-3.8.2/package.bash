__pkg_sha256=e765e5016ffa9b9dd243e363a0460d577074444ee2491267db2e96c9c2adef77
__pkg_name=gnutls
__pkg_version=3.8.2
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.xz
__pkg_tarball_url=https://www.gnupg.org/ftp/gcrypt/${__pkg_name}/v3.8/${__pkg_tarball_name}
__pkg_configure_extra_args=(
    --docdir=${__pkg_install_prefix}/${__pkg_distro_name}/share/doc/${__pkg_distro_name}
    --disable-static
    --with-default-trust-store-pkcs11="pkcs11:"
)
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/l/libunistring/libunistring-1.1
    ./ports/n/nettle/nettle-3.9.1
    ./ports/p/p11-kit/p11-kit-0.25.3
)
__pkg_link_dirs=(bin include lib share)
__pkg_maybe_copy_persistent_config=()
