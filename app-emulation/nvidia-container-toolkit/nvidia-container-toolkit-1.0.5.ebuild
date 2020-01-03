# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-base golang-build

GO_PN=github.com/nvidia/nvidia-container-runtime/hook
RT_VER=3.1.4
SRC=${WORKSPACE}/nvidia-container-runtime-${RT_VER}

SRC_URI="https://github.com/NVIDIA/nvidia-container-runtime/archive/v${RT_VER}.zip -> ${PN}-${RT_VER}.zip"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	dev-lang/go
	app-emulation/libnvidia-container
"

S=${WORKDIR}/nvidia-container-runtime-hook-${RT_VER}

src_unpack() {
	default
	mv ${WORKDIR}/nvidia-container-runtime-${RT_VER}/toolkit/nvidia-container-toolkit ${S}
}

src_prepare() {
	eapply_user
	mv ${S}/vendor ${S}/src
	return
}

src_compile() {
	pushd ${S} || die
	GOPATH="${S}" go build -o ${PN} .
	popd || die
}

src_install() {
	pushd ${S} || die
	dobin ${PN}
	popd || die

	pushd ${WORKDIR}/nvidia-container-runtime-${RT_VER}/toolkit || die
	insinto /etc/nvidia-container-runtime
	newins config.toml.centos config.toml
	popd || die

	dosym /usr/bin/nvidia-container-toolkit /usr/bin/nvidia-container-runtime-hook
}
