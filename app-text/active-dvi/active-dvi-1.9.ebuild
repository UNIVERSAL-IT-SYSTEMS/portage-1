# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/active-dvi/active-dvi-1.9.ebuild,v 1.2 2011/03/29 13:03:05 aballier Exp $

EAPI="2"

inherit eutils autotools texlive-common

MY_PN=${PN/ctive-/}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="A DVI previewer and a presenter for slides written in LaTeX"
SRC_URI="http://gallium.inria.fr/advi/${MY_P}.tar.gz"
HOMEPAGE="http://gallium.inria.fr/advi/"
LICENSE="LGPL-2.1"

IUSE="+ocamlopt"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-lang/ocaml-3.11.2[ocamlopt?]
	>=dev-ml/camlimages-3.0.1[truetype,tiff,jpeg,gs]
	virtual/latex-base
	app-text/ghostscript-gpl
	x11-libs/libXinerama"
DEPEND="${RDEPEND}
	|| ( ( dev-texlive/texlive-pstricks dev-texlive/texlive-pictures dev-texlive/texlive-latexextra )
		app-text/ptex )
	x11-proto/xineramaproto
	dev-ml/findlib
	app-text/htmlc
	dev-tex/hevea"

DOCS="README TODO"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.7.3-asneeded.patch"
	epatch "${FILESDIR}/${P}-htmlcflags.patch"
	AT_M4DIR="." eautoreconf
}

src_configure() {
	TEXMFMAIN=/usr/share/texmf-site econf $(use_enable ocamlopt native-program) \
		--docdir="/usr/share/doc/${PF}"
}

src_compile() {
	emake || die "emake failed"
	cd doc
	VARTEXFONTS="${T}/fonts" emake splash.dvi scratch_write_splash.dvi scratch_draw_splash.dvi || die "failed to create documentation"
}

src_install() {
	emake DESTDIR="${D}" PACKAGE="${PF}" install || die

	# now install the documentation
	dodoc ${DOCS}

	export STRIP_MASK="*/bin/advi.byt"
}

pkg_postinst() {
	etexmf-update
}

pkg_postrm() {
	etexmf-update
}
