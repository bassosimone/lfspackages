__pkg_sha256=4e7d9d3f6ed10878c58c5fb724a67dacf4b6aac7340b13e488fb2dc41346f2bb
__pkg_name=rsync
__pkg_version=3.2.7
__pkg_distro_name=${__pkg_name}-${__pkg_version}
__pkg_src_name=${__pkg_name}-${__pkg_version}
__pkg_tarball_name=${__pkg_name}-${__pkg_version}.tar.gz
__pkg_tarball_url=https://rsync.samba.org/ftp/rsync/${__pkg_tarball_name}
__pkg_configure_extra_args=(
    --disable-lz4
    --disable-xxhash
    --without-included-zlib
)
__pkg_build_type=autotools
__pkg_deps=()
__pkg_link_dirs=(bin share)
__pkg_maybe_copy_persistent_config=()
