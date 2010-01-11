# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-fontutils/texlive-fontutils-2009.ebuild,v 1.1 2010/01/11 03:16:31 aballier Exp $

TEXLIVE_MODULE_CONTENTS="accfonts afm2pl epstopdf fontware lcdftypetools ps2pkm pstools psutils dvipsconfig fontinst fontools getafm t1utils collection-fontutils
"
TEXLIVE_MODULE_DOC_CONTENTS="accfonts.doc afm2pl.doc epstopdf.doc fontware.doc lcdftypetools.doc pstools.doc psutils.doc fontinst.doc fontools.doc getafm.doc t1utils.doc "
TEXLIVE_MODULE_SRC_CONTENTS="fontinst.source "
inherit texlive-module
DESCRIPTION="TeXLive TeX and Outline font utilities"

LICENSE="GPL-2 as-is freedist GPL-1 LPPL-1.3 public-domain "
SLOT="0"
KEYWORDS="~amd64 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2009
!dev-texlive/texlive-psutils
!<app-text/texlive-core-2009
"
RDEPEND="${DEPEND} "
TEXLIVE_MODULE_BINSCRIPTS="texmf-dist/scripts/accfonts/mkt1font texmf-dist/scripts/accfonts/vpl2ovp texmf-dist/scripts/accfonts/vpl2vpl texmf-dist/scripts/epstopdf/epstopdf.pl texmf-dist/scripts/fontools/afm2afm texmf-dist/scripts/fontools/autoinst texmf-dist/scripts/fontools/cmap2enc texmf-dist/scripts/fontools/font2afm texmf-dist/scripts/fontools/ot2kpx texmf-dist/scripts/fontools/pfm2kpx texmf-dist/scripts/fontools/showglyphs"
