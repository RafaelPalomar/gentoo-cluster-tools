# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base golang-build

GO_PN=github.com/nvidia/nvidia-container-runtime/hook

SRC_URI="https://github.com/NVIDIA/nvidia-container-runtime/archive/v1.4.0-1.zip -> ${P}.zip"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	dev-lang/go
"

src_unpack() {
	default
	mv ${WORKDIR}/nvidia-container-runtime-${PV}-1/hook/nvidia-container-runtime-hook ${S}
}

src_prepare() {
	eapply_user
	mv ${WORKDIR}/${P}/vendor ${WORKDIR}/${P}/src
	return
}

src_compile() {
	pushd ${S} || die
	GOPATH="${WORKDIR}/${P}:$(get_golibdir_gopath)" go build -o ${PN} . || die
	popd || die
}

src_install() {
	pushd ${S} || die
	dobin ${PN}
	popd || die
}
