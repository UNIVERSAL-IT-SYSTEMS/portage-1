# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_authnz_external/mod_authnz_external-3.1.0.ebuild,v 1.4 2009/09/18 12:11:09 hollow Exp $

inherit eutils apache-module

DESCRIPTION="An Apache2 authentication DSO using external programs"
HOMEPAGE="http://www.unixpapa.com/mod_auth_external.html"
SRC_URI="http://www.unixpapa.com/software/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="2"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND=""

DOCFILES="AUTHENTICATORS CHANGES INSTALL INSTALL.HARDCODE README TODO UPGRADE"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTHNZ_EXTERNAL"

need_apache2_2
