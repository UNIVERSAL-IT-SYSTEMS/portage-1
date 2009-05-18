# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/truecrypt/truecrypt-6.2.ebuild,v 1.3 2009/05/18 04:39:01 robbat2 Exp $

EAPI="2"

inherit flag-o-matic multilib toolchain-funcs wxwidgets

DESCRIPTION="Free open-source disk encryption software"
HOMEPAGE="http://www.truecrypt.org/"
SRC_URI="${P}.tar.gz"

LICENSE="truecrypt-2.6"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"
RESTRICT="bindist fetch mirror"

RDEPEND="sys-fs/fuse
	x11-libs/wxGTK:2.8"
DEPEND="${RDEPEND}
	|| ( dev-libs/pkcs11-helper dev-libs/opensc )"

S="${WORKDIR}/${P}-source"

pkg_nofetch() {
	einfo "Please download tar.gz source from:"
	einfo "http://www.truecrypt.org/downloads2.php"
	einfo "Then put the file in ${DISTDIR}/${SRC_URI}"
}

pkg_setup() {
	WX_GTK_VER="2.8"
	if use X; then
		need-wxwidgets unicode
	else
		need-wxwidgets base-unicode
	fi
}

src_compile() {
	local EXTRA pkcs11_include_directory

	use X || EXTRA+=" NOGUI=1"

	if has_version dev-libs/pkcs11-helper; then
		pkcs11_include_directory="/usr/include/pkcs11-helper-1.0"
	else
		pkcs11_include_directory="/usr/include/opensc"
	fi
	append-flags -DCKR_NEW_PIN_MODE=0x000001B0 -DCKR_NEXT_OTP=0x000001B1

	emake \
		${EXTRA} \
		NOSTRIP=1 \
		NOTEST=1 \
		VERBOSE=1 \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		TC_EXTRA_CFLAGS="${CFLAGS}" \
		TC_EXTRA_CXXFLAGS="${CXXFLAGS}" \
		TC_EXTRA_LFLAGS="${LDFLAGS}" \
		WX_CONFIG="${WX_CONFIG}" \
		PKCS11_INC="${pkcs11_include_directory}" \
		|| die "emake failed"
}

src_test() {
	"${S}/Main/truecrypt" --text --test || die "tests failed"
}

src_install() {
	dobin Main/truecrypt
	dodoc Readme.txt "Release/Setup Files/TrueCrypt User Guide.pdf"
	insinto "/$(get_libdir)/rcscripts/addons"
	newins "${FILESDIR}/${PN}-stop.sh" "${PN}-stop.sh"
}

pkg_postinst() {
	warn_license
}
pkg_preinst() {
	warn_license
}

warn_license() {
	ewarn "TrueCrypt has very restrictive license."
	ewarn "Please read the ${LICENSE} license in ${PORTDIR}/licenses"
	ewarn "directory before using TrueCrypt. Please be explicitly aware of"
	ewarn "the limitations on redistribution of binaries or modified source."
	ebeep 5
}
