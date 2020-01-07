# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base golang-build

SRC_URI="https://github.com/NVIDIA/${PN}/archive/v${PV}.zip"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	app-emulation/nvidia-container-toolkit
"

src_unpack() {
	default
	mv ${S}/runtime/src/vendor ${S}/runtime/src/src
}

src_compile() {
	pushd ${S}/runtime/src || die
	GOPATH="${S}/runtime/src" go build -o ${PN} .
	popd || die
}

src_install() {
	pushd ${S}/runtime/src || die
	dobin ${PN}
	popd || die
}
