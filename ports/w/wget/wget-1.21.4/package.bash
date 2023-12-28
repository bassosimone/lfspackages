__pkg_sha256=81542f5cefb8faacc39bbbc6c82ded80e3e4a88505ae72ea51df27525bcde04c
__pkg_name=wget
__pkg_version=1.21.4
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.gz
__pkg_tarball_url=https://ftp.gnu.org/gnu/${__pkg_name}/${__pkg_tarball_name}
__pkg_configure_extra_args=()
__pkg_build_type=autotools
__pkg_deps=(
    ./ports/g/gnutls/gnutls-3.8.2
    ./ports/l/libidn2/libidn2-2.3.4
)
__pkg_link_dirs=(bin share)
__pkg_maybe_copy_persistent_config=(etc)

pkg_build() {
    pkg_build_autotools
    pkg_lib_run sudo find ${__pkg_install_prefix}/${__pkg_distro_name}/etc -type f -exec mv {} {}.new \;
}
