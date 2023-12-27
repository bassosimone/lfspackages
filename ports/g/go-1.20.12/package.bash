pkg_print_deps() {
    echo ""
}

pkg_build() {
    if [[ -d /opt/package/go-1.20.12 ]]; then
        pkg_lib_info "go-1.20.12: already built"
        return
    fi

    pkg_lib_download https://go.dev/dl/go1.20.12.src.tar.gz
    pkg_lib_verify go1.20.12.src.tar.gz c5bf934751d31c315c1d0bb5fb02296545fa6d08923566f7a5afec81f2ed27d6
    pkg_lib_extract go1.20.12.src.tar.gz

    pkg_lib_run cd go/src

    pkg_lib_run export GOROOT_BOOTSTRAP=/usr
    pkg_lib_run ./make.bash
    pkg_lib_run unset GOROOT_BOOSTRAP

    pkg_lib_run cd ../..

    pkg_lib_run sudo chown root:root go
    pkg_lib_run sudo mv go go-1.20.12
    pkg_lib_run sudo rm -rf /opt/package/go-1.20.12
    pkg_lib_run sudo install -d /opt/package
    pkg_lib_run sudo mv go-1.20.12 /opt/package
}

pkg_link() {
    if [[ ! -d /opt/package/go-1.20.12 ]]; then
        pkg_lib_warn "go-1.20.12: not built"
        return
    fi

    pkg_lib_symlink /opt/package/go-1.20.12/bin/go /opt/bin/go
    pkg_lib_symlink /opt/package/go-1.20.12/bin/gofmt /opt/bin/gofmt
}
