# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/strigi/strigi-0.6.4.ebuild,v 1.6 2009/03/13 02:19:30 jer Exp $

EAPI="2"

inherit cmake-utils eutils

DESCRIPTION="Fast crawling desktop search engine with Qt4 GUI"
HOMEPAGE="http://www.vandenoever.info/software/strigi"
SRC_URI="http://www.vandenoever.info/software/strigi/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="+clucene +dbus debug exif fam hyperestraier inotify log +qt4 test"

COMMONDEPEND="
	dev-libs/libxml2
	virtual/libiconv
	clucene? ( >=dev-cpp/clucene-0.9.19[-debug] )
	dbus? ( sys-apps/dbus
		|| ( ( x11-libs/qt-dbus:4
			x11-libs/qt-gui:4 )
			=x11-libs/qt-4.3*:4[dbus] )
		)
	exif? ( >=media-gfx/exiv2-0.17 )
	fam? ( virtual/fam )
	hyperestraier? ( app-text/hyperestraier )
	log? ( >=dev-libs/log4cxx-0.10.0 )
	qt4? (
		|| ( ( x11-libs/qt-core:4
			x11-libs/qt-gui:4
			x11-libs/qt-dbus:4 )
			=x11-libs/qt-4.3*:4[dbus] )
		)
	!clucene? (
		!hyperestraier? (
			>=dev-cpp/clucene-0.9.19[-debug]
		)
	)
"
DEPEND="${COMMONDEPEND}
	test? ( dev-util/cppunit )"
RDEPEND="${COMMONDEPEND}"

src_configure() {
	# Strigi needs either expat or libxml2.
	# However libxml2 seems to be required in both cases, linking to 2 xml parsers
	# is just silly, so we forcefully disable linking to expat.
	# Enabled: POLLING (only reliable way to check for files changed.)

	mycmakeargs="${mycmakeargs}
		-DENABLE_EXPAT=OFF -DENABLE_POLLING=ON
		-DFORCE_DEPS=ON -DENABLE_CPPUNIT=OFF
		-DENABLE_REGENERATEXSD=OFF
		$(cmake-utils_use_enable clucene CLUCENE)
		$(cmake-utils_use_enable dbus DBUS)
		$(cmake-utils_use_enable exif EXIV2)
		$(cmake-utils_use_enable fam FAM)
		$(cmake-utils_use_enable hyperestraier HYPERESTRAIER)
		$(cmake-utils_use_enable inotify INOTIFY)
		$(cmake-utils_use_enable log LOG4CXX)
		$(cmake-utils_use_enable qt4 DBUS)
		$(cmake-utils_use_enable qt4 QT4)"

	if ! use clucene && ! use hyperestraier; then
		mycmakeargs="${mycmakeargs} -DENABLE_CLUCENE=ON"
	fi

	cmake-utils_src_configure
}

src_test() {
	mycmakeargs="${mycmakeargs} -DENABLE_CPPUNIT=ON"
	cmake-utils_src_compile

	pushd "${WORKDIR}/${PN}_build"
	ctest --extra-verbose || die "Tests failed."
	popd
}

pkg_postinst() {
	if ! use clucene && ! use hyperestraier; then
		elog "Because you didn't enable any of the supported backends:"
		elog "clucene, hyperestraier and sqlite"
		elog "clucene support was silently installed."
		elog "If you prefer another backend, be sure to reinstall strigi"
		elog "and to enable that backend use flag"
	fi
}
