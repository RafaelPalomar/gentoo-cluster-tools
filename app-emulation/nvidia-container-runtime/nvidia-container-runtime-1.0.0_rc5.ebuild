# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/opencontainers/runc"

if [[ ${PV} == *9999 ]]; then
	inherit golang-build golang-vcs
else
	MY_PV="${PV/_/-}"
	EGIT_COMMIT="v${MY_PV}"
	RUNC_COMMIT="4fc53a81fb7c994640722ac585fa9ca548971871" # Change this when you update the ebuild
	SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc64"
	inherit golang-build golang-vcs-snapshot
fi

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://runc.io"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+ambient +apparmor hardened +seccomp +selinux"

RDEPEND="
	apparmor? ( sys-libs/libapparmor )
	seccomp? ( sys-libs/libseccomp )
	selinux? ( sys-libs/libselinux )
"

PATCHES=(
	"${FILESDIR}"/${PN}-${PV}-Add_prestart_hook_nvidia_container_runtime_hook_to_t.patch
)

src_unpack() {
	golang-vcs-snapshot_src_unpack
	pushd ${WORKDIR}/${PN}-${PV}/src/${EGO_PN} || die
	git init || die
	git add . || die
	git config user.name "Gentoo" || die
	git config user.email "no-email@void.com" || die
	git commit -m "Init" || die
	popd || die
}

src_prepare() {
	eapply_user

	pushd ${WORKDIR}/${PN}-${PV}/src/${EGO_PN} || die
	for patch in ${PATCHES[@]}
	do
		patch -p1 <  $patch || die
	done

	sed -i -e 's:\brunc\b:nvidia-container-runtime:g' ${WORKDIR}/${PN}-${PV}/src/${EGO_PN}/Makefile || die

	popd || die
}


src_compile() {
	# Taken from app-emulation/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ROOT}/usr/include"
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')
		-L${ROOT}/usr/$(get_libdir)"

	# build up optional flags
	local options=(
		$(usex ambient 'ambient')
		$(usex apparmor 'apparmor')
		$(usex seccomp 'seccomp')
		$(usex selinux 'selinux')
	)

	GOPATH="${S}"\
		emake BUILDTAGS="${options[*]}" \
		COMMIT="${RUNC_COMMIT}" -C src/${EGO_PN}
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin nvidia-container-runtime
	dodoc README.md PRINCIPLES.md
	popd || die
}
