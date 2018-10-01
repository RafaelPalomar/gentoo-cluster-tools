# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SRC_URI="https://github.com/NVIDIA/nvidia-docker/archive/v2.0.3.zip -> ${P}.zip"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	app-emulation/docker
"

src_prepare() {
	eapply_user
	true;
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

	pushd ${S} || die
	dobin nvidia-docker
	insinto /etc/docker
	newins daemon.json daemon.json
	popd || die
}
