# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/celestia/celestia-1.5.1.ebuild,v 1.13 2009/11/12 19:37:27 bicatali Exp $

EAPI=2
inherit eutils flag-o-matic gnome2 autotools

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="http://www.shatters.net/celestia/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
		mirror://gentoo/${P}-acinclude.patch.bz2
		mirror://gentoo/${P}-gcc43.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="cairo gnome gtk lua nls pch theora threads unicode"

RDEPEND="virtual/glu
	media-libs/jpeg
	media-libs/libpng
	gtk? ( !gnome? ( >=x11-libs/gtk+-2.6 >=x11-libs/gtkglext-1.0 ) )
	gnome? (
		>=x11-libs/gtk+-2.6
		>=x11-libs/gtkglext-1.0
		>=gnome-base/libgnomeui-2.0
	)
	!gtk? ( !gnome? ( virtual/glut ) )
	lua? ( >=dev-lang/lua-5.0 )
	cairo? ( x11-libs/cairo )
	theora? ( media-libs/libtheora )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	# Check for one for the following use flags to be set.
	if use gnome; then
		einfo "USE=\"gnome\" detected."
		USE_DESTDIR="1"
		CELESTIA_GUI="gnome"
	elif use gtk; then
		einfo "USE=\"gtk\" detected."
		CELESTIA_GUI="gtk"
	else
		ewarn "If you want to use the full gui, set USE=\"{gnome/gtk}\""
		ewarn "Defaulting to glut support (no GUI)."
		CELESTIA_GUI="glut"
	fi
}

src_prepare() {
	# make better desktop files
	epatch "${FILESDIR}"/${PN}-1.5.0-desktop.patch

	# add a ~/.celestia for extra directories
	epatch "${FILESDIR}"/${PN}-1.4.1-cfg.patch

	# fix for as-needed (bug #130091)
	epatch "${FILESDIR}"/${PN}-1.4.1-as-needed.patch

	# fix for as-needed (bug #217758)
	epatch "${DISTDIR}"/${P}-gcc43.patch.bz2

	# fix for libtool-2.2 (bug #228865 and #218982)
	epatch "${DISTDIR}"/${P}-acinclude.patch.bz2

	# needed for kde GUI
	epatch "${FILESDIR}"/${P}-arts.patch

	# needed for proper detection of kde-3.5 in the presence
	# of kde4
	epatch "${FILESDIR}"/${P}-kde-3.5.patch

	# missing includes with gcc 4.4
	epatch "${FILESDIR}"/${P}-gcc44.patch

	# remove flags to let the user decide
	for cf in -O2 -ffast-math \
		-fexpensive-optimizations \
		-fomit-frame-pointer; do
		sed -i \
			-e "s/${cf}//g" \
			configure.in || die "sed failed"
	done

	# remove an unused gconf macro killing autoconf when no gnome
	# (not needed without eautoreconf)
	if ! use gnome; then
		sed -i \
			-e '/AM_GCONF_SOURCE_2/d' \
			configure.in || die "sed failed"
	fi
	if use unicode; then
		pushd locale > /dev/null
		for i in guide_{de,es,fr,it,nl,sv}.cel start_de.cel demo_nl.cel; do
			iconv -f iso-8859-1 ${i} -t utf8 > ${i}.utf8
			mv ${i}.utf8 ${i}
		done
		iconv -f iso-8859-1 -t utf8 start_de.cel > start_de.cel.utf8
		iconv -f cp1251 -t utf8 guide_ru.cel > guide_ru.cel.utf8
		iconv -f SHIFT-JIS -t utf8 guide_ja.cel > guide_ja.cel.utf8
		mv start_de.cel.utf8 start_de.cel
		mv guide_ru.cel.utf8 guide_ru.cel
		mv guide_ja.cel.utf8 guide_ja.cel
		popd > /dev/null
	fi
	eautoreconf
	filter-flags "-funroll-loops -frerun-loop-opt"
}

src_configure() {
	econf \
		--with-${CELESTIA_GUI} \
		$(use_with lua) \
		$(use_enable cairo) \
		$(use_enable threads threading) \
		$(use_enable nls) \
		$(use_enable pch) \
		$(use_enable theora)
}

src_install() {
	if [[ ${CELESTIA_GUI} == gnome ]]; then
		gnome2_src_install
	else
		emake DESTDIR="${D}" install || die "emake install failed"
		for size in 16 22 32 48 ; do
			insinto /usr/share/icons/hicolor/${size}x${size}/apps
			newins "${S}"/src/celestia/kde/data/hi${size}-app-${PN}.png ${PN}.png
		done
	fi
	[[ ${CELESTIA_GUI} == glut ]] && domenu celestia.desktop
	dodoc AUTHORS README TODO TRANSLATORS *.txt || die
}
