# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SRC_URI="https://github.com/NVIDIA/${PN}/archive/v${PV}.zip -> ${P}.zip"

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
	# Thanks to the ArchLinux community
	# https://aur.archlinux.org/cgit/aur.git/tree/fix_rpc_flags.patch?h=libnvidia-container
	${FILESDIR}/fix_rpc_flags.patch
)

src_unpack() {
	default
	mkdir -p ${WORKDIR}/${P}/deps/src || die
	cd ${WORKDIR}/${P}/deps/src || die
	unpack ${FILESDIR}/nvidia-modprobe-396.zip || die
	mv ${WORKDIR}/${P}/deps/src/nvidia-modprobe-396 ${WORKDIR}/${P}/deps/src/nvidia-modprobe-396.51 || die
	touch ${WORKDIR}/${P}/deps/src/nvidia-modprobe-396.51/.download_stamp || die
}

src_compile() {
	pushd ${S} || die
	git init . || die
	#By indicating WITH_TIRPC=no we avoid the use of locally downloaded TIRPC and use gentoo's one.
	CUDA_DIR=/opt/cuda WITH_TIRPC=no WITH_LIBELF=yes emake
	popd || die
}

src_install() {
	pushd ${S} || die
	WITH_LIBELF=yes WITH_TIRPC=no emake DESTDIR=${D} install prefix=/usr libdir=/usr/lib64
	popd || die
}
