# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SRC_URI="https://github.com/NVIDIA/libnvidia-container/archive/v1.0.0.zip -> ${P}.zip"

LICENSE="BSD"

SLOT="0"

KEYWORDS="~amd64"

RDEPEND="
	net-libs/libtirpc
	dev-util/nvidia-cuda-toolkit
	sys-apps/lsb-release
	sys-devel/bmake
	net-libs/rpcsvc-proto
	net-nds/rpcbind
	dev-vcs/git
"

PATCHES=(
	${FILESDIR}/${PN}-${PV}-Bug_fix_on_building_with_TIRPC.patch
)

src_compile() {
	pushd ${S} || die
	git init . || die
	CUDA_DIR=/opt/cuda WITH_TIRPC=yes WITH_LIBELF=yes emake
	popd || die
}

src_install() {
	pushd ${S} || die
	WITH_LIBELF=yes emake DESTDIR=${D} install prefix=/usr
	popd || die
}
