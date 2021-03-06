# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/icedtea/icedtea-6.1.11.2.ebuild,v 1.1 2012/05/14 16:27:04 sera Exp $
# Build written by Andrew John Hughes (gnu_andrew@member.fsf.org)

# *********************************************************
# * IF YOU CHANGE THIS EBUILD, CHANGE ICEDTEA-7.* AS WELL *
# *********************************************************

EAPI="4"

inherit autotools java-pkg-2 java-vm-2 pax-utils prefix versionator virtualx

ICEDTEA_PKG=${PN}$(replace_version_separator 1 -)
OPENJDK_BUILD="24"
OPENJDK_DATE="14_nov_2011"
OPENJDK_TARBALL="openjdk-6-src-b${OPENJDK_BUILD}-${OPENJDK_DATE}.tar.gz"
JAXP_TARBALL="jaxp144_03.zip"
JAXWS_TARBALL="jdk6-jaxws2_1_6-2011_06_13.zip"
JAF_TARBALL="jdk6-jaf-b20.zip"
CACAO_TARBALL="cff92704c4e0.tar.gz"

DESCRIPTION="A harness to build OpenJDK using Free Software build tools and dependencies"
HOMEPAGE="http://icedtea.classpath.org"
SRC_URI="
	http://icedtea.classpath.org/download/source/${ICEDTEA_PKG}.tar.gz
	http://download.java.net/openjdk/jdk6/promoted/b${OPENJDK_BUILD}/${OPENJDK_TARBALL}
	http://icedtea.classpath.org/download/drops/${JAXWS_TARBALL}
	http://icedtea.classpath.org/download/drops/${JAF_TARBALL}
	http://icedtea.classpath.org/download/drops/${JAXP_TARBALL}
	!amd64? ( !sparc? ( !x86? (
		http://icedtea.classpath.org/download/drops/cacao/${CACAO_TARBALL}
	) ) )"

LICENSE="Apache-1.1 Apache-2.0 GPL-1 GPL-2 GPL-2-with-linking-exception LGPL-2 MPL-1.0 MPL-1.1 public-domain W3C"
SLOT="6"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~x86"

IUSE="+X +alsa cjk +cups debug doc examples javascript +jbootstrap +nsplugin
	+nss pax_kernel pulseaudio +source systemtap test +webstart"

# Ideally the following were optional at build time.
ALSA_COMMON_DEP="
	>=media-libs/alsa-lib-1.0"
CUPS_COMMON_DEP="
	>=net-print/cups-1.2.12"
X_COMMON_DEP="
	dev-libs/glib
	>=media-libs/freetype-2.3.5
	>=x11-libs/gtk+-2.8:2
	>=x11-libs/libX11-1.1.3
	>=x11-libs/libXext-1.1.1
	>=x11-libs/libXi-1.1.3
	>=x11-libs/libXrender-0.9.4
	>=x11-libs/libXtst-1.0.3"
X_DEPEND="
	>=x11-libs/libXau-1.0.3
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXinerama-1.0.2
	>=x11-libs/libXp-1.0.0
	x11-proto/inputproto
	>=x11-proto/xextproto-7.1.1
	x11-proto/xineramaproto
	x11-proto/xproto"

COMMON_DEP="
	>=media-libs/giflib-4.1.6
	>=media-libs/libpng-1.2
	>=sys-libs/zlib-1.2.3
	virtual/jpeg
	javascript? ( dev-java/rhino:1.6 )
	nss? ( >=dev-libs/nss-3.12.5-r1 )
	pulseaudio?  ( >=media-sound/pulseaudio-0.9.11 )
	systemtap? ( >=dev-util/systemtap-1 )"

# media-fonts/lklug needs ppc ppc64 keywords
RDEPEND="${COMMON_DEP}
	!dev-java/icedtea6
	X? (
		${X_COMMON_DEP}
		media-fonts/dejavu
		cjk? (
			media-fonts/arphicfonts
			media-fonts/baekmuk-fonts
			!ppc? ( !ppc64? ( media-fonts/lklug ) )
			media-fonts/lohit-fonts
			media-fonts/sazanami
		)
	)
	alsa? ( ${ALSA_COMMON_DEP} )
	cups? ( ${CUPS_COMMON_DEP} )"

# Only ant-core-1.8.1 has fixed ant -diagnostics when xerces+xalan are not present.
# ca-certificates, perl and openssl are used for the cacerts keystore generation
# xext headers have two variants depending on version - bug #288855
# !eclipse-ecj-3.7 - bug #392587
# autoconf - as long as we use eautoreconf, version restrictions for bug #294918
DEPEND="${COMMON_DEP} ${ALSA_COMMON_DEP} ${CUPS_COMMON_DEP} ${X_COMMON_DEP}
	|| (
		>=dev-java/gcj-jdk-4.3
		dev-java/icedtea-bin:6
		dev-java/icedtea:6
	)
	app-arch/cpio
	app-arch/unzip
	app-arch/zip
	app-misc/ca-certificates
	>=dev-java/ant-core-1.8.1
	dev-java/ant-nodeps
	dev-lang/perl
	>=dev-libs/libxslt-1.1.26
	dev-libs/openssl
	virtual/pkgconfig
	sys-apps/lsb-release
	${X_DEPEND}
	jbootstrap? (
		|| ( <dev-java/eclipse-ecj-3.7 dev-java/ecj-gcj )
	)
	pax_kernel? ( sys-apps/paxctl )"

PDEPEND="webstart? ( dev-java/icedtea-web:6 )
	nsplugin? ( dev-java/icedtea-web:6[nsplugin] )"

S="${WORKDIR}"/${ICEDTEA_PKG}

pkg_setup() {
	JAVA_PKG_WANT_BUILD_VM="
		icedtea-6 icedtea-bin-6 icedtea6 icedtea6-bin
		gcj-jdk"
	JAVA_PKG_WANT_SOURCE="1.5"
	JAVA_PKG_WANT_TARGET="1.5"

	java-vm-2_pkg_setup
	java-pkg-2_pkg_setup
}

src_unpack() {
	unpack ${ICEDTEA_PKG}.tar.gz
}

java_prepare() {
	# icedtea doesn't like some locales. #330433 #389717
	export LANG="C" LC_ALL="C"

	epatch "${FILESDIR}"/${PN}-${SLOT}_pax_kernel_support.patch #389751
	eautoreconf
}

src_configure() {
	local config bootstrap
	local vm=$(java-pkg_get-current-vm)

	# IcedTea6 can't be built using IcedTea7; its class files are too new
	if has "${vm}" icedtea6 icedtea-6 icedtea6-bin icedtea-bin-6; then
		use jbootstrap && bootstrap=yes
	elif has "${vm}" gcj-jdk; then
		# gcj-jdk ensures ecj is present.
		use jbootstrap || einfo "bootstrap forced on for ${vm}, ignoring use jbootstrap"
		bootstrap=yes
	else
		eerror "IcedTea${SLOT} must be built with either a JDK based on GNU Classpath or an existing build of IcedTea${SLOT}."
		die "Install a GNU Classpath JDK (gcj-jdk)"
	fi

	if [[ ${bootstrap} ]]; then
		config="${config} --enable-bootstrap"

		# icedtea-6 javac wrapper requires to always have ecj if bootstrapping #392337
		local ecj_jar="$(readlink "${EPREFIX}"/usr/share/eclipse-ecj/ecj.jar)"
		# Don't use eclipse-ecj-3.7 #392587
		local ecj_all=( "${EPREFIX}"/usr/share/{eclipse-ecj,ecj-gcj}-* )
		ecj_all=( "${ecj_all[@]/*eclipse-ecj-3.7*/}" )
		if ! has "${ecj_jar%/lib/ecj.jar}" "${ecj_all[@]}"; then
			ecj_jar="${ecj_jar%/lib/ecj.jar}"
			ewarn "${ecj_jar##*/} set as system ecj, can't use for bootstrap"
			ewarn "Found usable: ${ecj_all[@]##*/}"
			ewarn "using ${ecj_all##*/} instead"
			ecj_jar="${ecj_all}"/lib/ecj.jar
		fi
		config="${config} --with-ecj-jar=${ecj_jar}"
	else
		config="${config} --disable-bootstrap"
	fi

	# Always use HotSpot as the primary VM if available. #389521 #368669 #357633 ...
	# Otherwise use CACAO
	if ! has "${ARCH}" amd64 sparc x86; then
		config="${config} --enable-cacao --with-cacao-src-zip=${DISTDIR}/${CACAO_TARBALL}"
	fi

	# OpenJDK-specific parallelism support. Bug #389791, #337827
	# Implementation modified from waf-utils.eclass
	# Note that "-j" is converted to "-j1" as the system doesn't support --load-average
	local procs=$(echo -j1 ${MAKEOPTS} | sed -r "s/.*(-j\s*|--jobs=)([0-9]+).*/\2/" )
	config="${config} --with-parallel-jobs=${procs}";
	einfo "Configuring using --with-parallel-jobs=${procs}"

	if use javascript ; then
		config="${config} --with-rhino=$(java-pkg_getjar rhino:1.6 js.jar)"
	else
		config="${config} --without-rhino"
	fi

	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	econf ${config} \
		--with-openjdk-src-zip="${DISTDIR}/${OPENJDK_TARBALL}" \
		--with-jaxp-drop-zip="${DISTDIR}/${JAXP_TARBALL}" \
		--with-jaxws-drop-zip="${DISTDIR}/${JAXWS_TARBALL}" \
		--with-jaf-drop-zip="${DISTDIR}/${JAF_TARBALL}" \
		--with-jdk-home="$(java-config -O)" \
		--with-abs-install-dir=/usr/$(get_libdir)/icedtea${SLOT} \
		$(use_enable !debug optimizations) \
		$(use_enable doc docs) \
		$(use_enable nss) \
		$(use_enable pulseaudio pulse-java) \
		$(use_enable systemtap) \
		$(use_with pax_kernel pax paxctl)
}

src_compile() {
	# Would use GENTOO_VM otherwise.
	export ANT_RESPECT_JAVA_HOME=TRUE

	# Load the least that's needed to avoid possible classpath collisions.
	export ANT_TASKS="ant-nodeps"

	emake
}

src_test() {
	# Use Xvfb for tests
	unset DISPLAY

	Xemake -j1 check
}

src_install() {
	local dest="/usr/$(get_libdir)/icedtea${SLOT}"
	local ddest="${ED}/${dest}"
	dodir "${dest}"

	dodoc README NEWS AUTHORS THANKYOU
	dosym /usr/share/doc/${PF} /usr/share/doc/${PN}${SLOT}

	cd openjdk.build/j2sdk-image || die

	# Ensures HeadlessGraphicsEnvironment is used.
	if ! use X; then
		rm -r jre/lib/$(get_system_arch)/xawt || die
	fi

	#402507
	mkdir jre/.systemPrefs || die
	touch jre/.systemPrefs/.system.lock || die
	touch jre/.systemPrefs/.systemRootModFile || die

	# doins can't handle symlinks.
	cp -vRP bin include jre lib man "${ddest}" || die

	dodoc ASSEMBLY_EXCEPTION THIRD_PARTY_README

	if use doc; then
		# java-pkg_dohtml needed for package-list #302654
		java-pkg_dohtml -r ../docs/* || die
	fi

	if use examples; then
		dodir "${dest}/share";
		cp -vRP demo sample "${ddest}/share/" || die
	fi

	if use source; then
		cp src.zip "${ddest}" || die
	fi

	# Fix the permissions.
	find "${ddest}" \! -type l \( -perm /111 -exec chmod 755 {} \; -o -exec chmod 644 {} \; \) || die

	# Needs to be done before generating cacerts
	java-vm_set-pax-markings "${ddest}"

	# We need to generate keystore - bug #273306
	einfo "Generating cacerts file from certificates in ${EPREFIX}/usr/share/ca-certificates/"
	mkdir "${T}/certgen" && cd "${T}/certgen" || die
	cp "${FILESDIR}/generate-cacerts.pl" . && chmod +x generate-cacerts.pl || die
	for c in "${EPREFIX}"/usr/share/ca-certificates/*/*.crt; do
		openssl x509 -text -in "${c}" >> all.crt || die
	done
	./generate-cacerts.pl "${ddest}/bin/keytool" all.crt || die
	cp -vRP cacerts "${ddest}/jre/lib/security/" || die
	chmod 644 "${ddest}/jre/lib/security/cacerts" || die

	# Bug 390663
	cp "${FILESDIR}"/fontconfig.Gentoo.properties.src "${T}"/fontconfig.Gentoo.properties || die
	eprefixify "${T}"/fontconfig.Gentoo.properties
	insinto "${dest}"/jre/lib
	doins "${T}"/fontconfig.Gentoo.properties

	set_java_env "${FILESDIR}/icedtea.env"
	if ! use X || ! use alsa || ! use cups; then
		java-vm_revdep-mask "${dest}"
	fi
}

pkg_preinst() {
	if has_version "<=dev-java/icedtea-6.1.10.4:${SLOT}"; then
		# portage would preserve the symlink otherwise, related to bug #384397
		rm -f "${EROOT}/usr/lib/jvm/icedtea6"
		elog "To unify the layout and simplify scripts, the identifier of Icedtea-6*"
		elog "has changed from 'icedtea6' to 'icedtea-6' starting from version 6.1.10.4-r1"
		elog "If you had icedtea6 as system VM, the change should be automatic, however"
		elog "build VM settings in /etc/java-config-2/build/jdk.conf are not changed"
		elog "and the same holds for any user VM settings. Sorry for the inconvenience."
	fi
}
