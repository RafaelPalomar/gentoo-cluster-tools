# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base

GO_PN=github.com/nvidia/nvidia-container-runtime/hook

SRC_URI="https://github.com/NVIDIA/nvidia-container-runtime/archive/v1.4.0-1.zip -> ${P}.zip"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	dev-lang/go
"

echo -----------------------
echo $PN
echo $PV
echo ${WORKDIR}/${PN}-${PV}-1/hook/nvidia-container-runtime-hook
echo -----------------------

src_prepare() {
	eapply_user
	true;
	}

src_unpack() {
	default
	mkdir -p src/${GO_PN} || die
	mv ${WORKDIR}/nvidia-container-runtime-${PV}-1/hook/nvidia-container-runtime-hook src/${GO_PN} || die
}

src_configure() {
 true;
}

src_compile() {
 true;
}

src_test() {
 true;
}

src_install() {
	return
}
