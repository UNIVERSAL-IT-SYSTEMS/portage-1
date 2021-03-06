# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/opendylan/opendylan-2011.1-r1.ebuild,v 1.4 2012/08/22 16:00:56 mr_bones_ Exp $
EAPI=4

inherit autotools

RESTRICT="test"

DESCRIPTION="OpenDylan language runtime environment"

HOMEPAGE="http://opendylan.org"
SRC_URI="https://github.com/dylan-lang/opendylan/zipball/v2011.1 -> opendylan-2011.1.zip"
MY_P="dylan-lang-opendylan-23f8ab5" # WTF github, that's NOT funny

S=${WORKDIR}/${MY_P}

LICENSE="Opendylan"
SLOT="0"

# not tested on x86
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="app-arch/unzip
	dev-libs/boehm-gc
	dev-lang/perl
	dev-perl/XML-Parser
	|| ( dev-lang/opendylan-bin dev-lang/opendylan )
	x86? ( dev-libs/mps )"
RDEPEND="${DEPEND}"

# on x86 there's a dependency on mps, but the build system is a bit ... hmm ...
# let's give it more of a chance to survive then
NAUGHTY_FILES=(
	sources/lib/run-time/collector.c.malloc
	sources/lib/run-time/collector.c
	sources/lib/run-time/pentium-win32/buffalo-collector.c
	sources/lib/run-time/pentium-win32/heap-stats.c
	sources/lib/run-time/heap-utils.h
	)

NAUGHTY_HEADERS=(
	mps.h
	mpscmv.h
	mpscamc.h
	mpsavm.h
	)

src_prepare() {
	mkdir -p build-aux
	elibtoolize && eaclocal || die "Fail"
	automake --foreign --add-missing # this one dies wrongfully
	eautoconf || die "Fail"
	# mps headers, included wrong
	if use x86; then
	for i in ${NAUGHTY_FILES[@]}; do
		for header in ${NAUGHTY_HEADERS[@]}; do
			sed -i -e "s:\"${header}\":<${header}>:" $i
		done
	done
	fi
}

src_configure() {
	if has_version =dev-lang/opendylan-bin-2011.1; then
		PATH=/opt/opendylan-2011.1/bin/:$PATH
	else
		PATH=/opt/opendylan/bin:$PATH
	fi
	if use amd64; then
		econf --prefix=/opt/opendylan || die
	else
		econf --prefix=/opt/opendylan --with-mps=/usr/include/mps/ || die
	fi
	if use x86; then
        # Includedir, pointing at something wrong
        sed -i -e 's:-I$(MPS)/code:-I$(MPS):'  sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps path"
	sed -i -e 's~(cd $(MPS)/code; make -f lii4gc.gmk mmdw.a)~:;~' sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps building"
	sed -i -e 's~(cd $(MPS)/code; make -f lii4gc.gmk mpsplan.a)~:;~' sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps building"
	sed -i -e 's~$(MPS_LIB)/mpsplan.a~/usr/lib/mpsplan.a~' sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps clone"
	sed -i -e 's~$(MPS_LIB)/mmdw.a~/usr/lib/mmdw.a~' sources/lib/run-time/pentium-linux/Makefile || die "Couldn't fix mps clone"
	fi
}

src_compile() {
	ulimit -s 32000 # this is naughty build system
	emake || die
}

src_install() {
	ulimit -s 32000 # this is naughty build system
	# because of Makefile weirdness it rebuilds quite a bit here
	# upstream has been notified
	emake -j1 DESTDIR=${D} install
	mkdir -p "${D}/etc/env.d/opendylan/"
	echo "export PATH=/opt/opendylan/bin:\$PATH" > "${D}/etc/env.d/opendylan/99-opendylan" || die "Failed to add env settings"
}
