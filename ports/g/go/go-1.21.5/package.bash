pkg_print_deps() {
    echo ""
}

pkg_print_destdir() {
    echo "/opt/package/go-1.21.5"
}

pkg_build() {
    pkg_lib_download https://go.dev/dl/go1.21.5.src.tar.gz
    pkg_lib_verify go1.21.5.src.tar.gz 285cbbdf4b6e6e62ed58f370f3f6d8c30825d6e56c5853c66d3c23bcdb09db19
    pkg_lib_extract go1.21.5.src.tar.gz

    pkg_lib_run cd go/src

    pkg_lib_run export GOROOT_BOOTSTRAP=/usr
    pkg_lib_run ./make.bash
    pkg_lib_run unset GOROOT_BOOSTRAP

    pkg_lib_run cd ../..

    pkg_lib_run sudo chown root:root go
    pkg_lib_run sudo mv go go-1.21.5
    pkg_lib_run sudo rm -rf /opt/package/go-1.21.5
    pkg_lib_run sudo install -d /opt/package
    pkg_lib_run sudo mv go-1.21.5 /opt/package
}

pkg_link() {
    pkg_lib_symlink /opt/package/go-1.21.5/bin/go /opt/bin/go
    pkg_lib_symlink /opt/package/go-1.21.5/bin/gofmt /opt/bin/gofmt
}
