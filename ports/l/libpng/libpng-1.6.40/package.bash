__pkg_sha256=535b479b2467ff231a3ec6d92a525906fb8ef27978be4f66dbe05d3f3a01b3a1
__pkg_name=libpng
__pkg_version=1.6.40
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.xz
__pkg_tarball_url=https://downloads.sourceforge.net/project/libpng/libpng16/${__pkg_version}/${__pkg_tarball_name}
__pkg_configure_extra_args=()
__pkg_deps=()
__pkg_link_dirs=(bin include lib share)
__pkg_maybe_copy_persistent_config=()

pkg_build() {
    pkg_build_autotools
    pkg_lib_run sudo rm -f /opt/package/libpng-1.6.40/lib/libpng{16,}.a
}
