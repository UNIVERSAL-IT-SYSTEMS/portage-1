# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/hourglass/hourglass-0.7.2.ebuild,v 1.4 2012/04/13 17:52:05 ulm Exp $

EAPI="1"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="A PSP (personal software process) time tracking utility written in Java"
HOMEPAGE="http://hourglass.wiki.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="dev-java/log4j
		dev-java/jcommon:1.0
		dev-java/jdom:1.0"

DEPEND=">=virtual/jdk-1.5
	dev-java/ant-core
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

S="${WORKDIR}/${P}-src"

src_unpack() {
	unpack ${A}
	cd "${S}"

	echo "jar.log4j=$(java-pkg_getjar log4j log4j.jar)" > conf/local.properties
	echo "jar.jcommon=$(java-pkg_getjar jcommon:1.0 jcommon.jar)" >> conf/local.properties
	echo "jar.jdom=$(java-pkg_getjar jdom:1.0 jdom.jar)" >> conf/local.properties
	echo "jar.ant=$(java-pkg_getjar --build-only ant-core ant.jar)" >> conf/local.properties
}

EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="javadoc"

src_install() {
	java-pkg_dojar "dist/${P}/lib/${PN}.jar"

	use doc && java-pkg_dojavadoc build/doc/api
	use source && java-pkg_dosrc src/*

	java-pkg_dolauncher "${PN}" \
		--main "net.sourceforge.hourglass.swingui.Main"

	make_desktop_entry "${PN}" "Hourglass" "appointment-new" "Office"

	dodoc README ChangeLog AUTHORS
}
