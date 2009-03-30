# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/rainbowcrack/rainbowcrack-1.2-r1.ebuild,v 1.8 2009/03/29 13:46:35 patrick Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Hash cracker that precomputes plaintext - ciphertext pairs in advance"
HOMEPAGE="http://project-rainbowcrack.com/"

SRC_URI="http://project-rainbowcrack.com/${P}-src.zip
	http://http://project-rainbowcrack.com/${P}-src-algorithmpatch.zip"

LICENSE="as-is"
SLOT="0"
# contains ix86 ASM
KEYWORDS="-* amd64 x86"
IUSE=""

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND} app-arch/unzip"

MY_P=${P}-src
S=${WORKDIR}/${MY_P}/src

src_unpack() {
	unpack ${A} || die "unpack failed"
	cd "${S}"
	mv "${WORKDIR}/${P}"-src-algorithmpatch/Hash* "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch" \
		"${FILESDIR}/${P}-share.patch" \
		"${FILESDIR}/${P}-types.patch" \
		"${FILESDIR}/${P}+gcc-4.3.patch" \
		"${FILESDIR}/${P}-asneeded.patch"
	sed -i "s#@@SHARE@@#/usr/share/${P}#g" ChainWalkContext.cpp || die
}

src_compile() {
	emake -f makefile.linux CXX=$(tc-getCXX) || die "make failed"
}

src_test() {
	einfo "generating rainbow tables (password maps)"
	./rtgen sha1 loweralpha 7 7  0 1000 160 test
	einfo "sorting tables"
	./rtsort *.rt
	einfo "attempting crack of 7 character random sha1 lowercase passwords"
	./rcrack ./*.rt -l 'random_sha1_loweralpha#1-7.hash'
	einfo "I haven't rigged this so it finds anything yet. Submissions welcome bugs.gentoo.org"
}

src_install() {
	dobin rtgen rtdump rtsort rcrack || die "dobin failed"
	insinto "/usr/share/${P}"
	doins charset.txt

	dodoc *.plain *.hash

	newdoc "${WORKDIR}/${P}-src-algorithmpatch/readme.txt" algorithm_readme.txt

	cd "${WORKDIR}/${MY_P}"
	dodoc readme.txt readme_src.txt disclaimer.txt
	dohtml -r doc/
}
