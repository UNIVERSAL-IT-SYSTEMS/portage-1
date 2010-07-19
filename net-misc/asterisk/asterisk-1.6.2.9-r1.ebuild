# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/asterisk/asterisk-1.6.2.9-r1.ebuild,v 1.1 2010/07/19 15:48:51 chainsaw Exp $

EAPI=3
inherit autotools base eutils linux-info multilib

MY_P="${PN}-${PV/_/-}"

DESCRIPTION="Asterisk: A Modular Open Source PBX System"
HOMEPAGE="http://www.asterisk.org/"
SRC_URI="http://downloads.asterisk.org/pub/telephony/asterisk/releases/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa +caps curl dahdi debug freetds iconv jabber ldap lua keepsrc misdn newt +samples oss postgres radius snmp span speex ssl sqlite static vorbis"

RDEPEND="sys-libs/ncurses
	dev-libs/popt
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	caps? ( sys-libs/libcap )
	curl? ( net-misc/curl )
	dahdi? ( >=net-libs/libpri-1.4.7
		net-misc/dahdi-tools )
	freetds? ( dev-db/freetds )
	iconv? ( virtual/libiconv )
	jabber? ( dev-libs/iksemel )
	ldap?	( net-nds/openldap )
	lua? ( dev-lang/lua )
	misdn? ( net-dialup/misdnuser )
	newt? ( dev-libs/newt )
	postgres? ( dev-db/postgresql-base )
	radius? ( net-dialup/radiusclient-ng )
	snmp? ( net-analyzer/net-snmp )
	span? ( media-libs/spandsp )
	speex? ( media-libs/speex )
	sqlite? ( dev-db/sqlite )
	ssl? ( dev-libs/openssl )
	vorbis? ( media-libs/libvorbis )"

DEPEND="${RDEPEND}
	!<net-misc/asterisk-addons-1.6
	!net-misc/asterisk-chan_unistim
	!net-misc/zaptel"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/1.6.2/${P}-gsm-pic.patch"
	"${FILESDIR}/1.6.2/${PN}-1.6.2.8-pri-missing-keyword.patch"
	"${FILESDIR}/1.6.2/${PN}-1.6.2.8-inband-indications.patch"
	"${FILESDIR}/1.6.1/${PN}-1.6.1-uclibc.patch"
	"${FILESDIR}/1.6.1/${PN}-1.6.1.6-fxsks-hookstate.patch"
	"${FILESDIR}/1.6.2/${PN}-1.6.2.2-nv-faxdetect.patch"
)

pkg_setup() {
	CONFIG_CHECK="~!NF_CONNTRACK_SIP"
	local WARNING_NF_CONNTRACK_SIP="SIP (NAT) connection tracking is enabled. Some users
	have reported that this module dropped critical SIP packets in their deployments. You
	may want to disable it if you see such problems."
	check_extra_config
}

src_prepare() {
	base_src_prepare
	AT_M4DIR=autoconf eautoreconf
}

src_configure() {
	econf \
		--libdir="/usr/$(get_libdir)" \
		--localstatedir="/var" \
		--with-gsm=internal \
		--with-popt \
		--with-z \
		$(use_with alsa asound) \
		$(use_with caps cap) \
		$(use_with curl) \
		$(use_with dahdi pri) \
		$(use_with dahdi tonezone) \
		$(use_with dahdi) \
		$(use_with freetds tds) \
		$(use_with iconv) \
		$(use_with jabber iksemel) \
		$(use_with lua) \
		$(use_with misdn isdnnet) \
		$(use_with misdn suppserv) \
		$(use_with misdn) \
		$(use_with newt) \
		$(use_with oss) \
		$(use_with postgres) \
		$(use_with radius) \
		$(use_with snmp netsnmp) \
		$(use_with span spandsp) \
		$(use_with speex) \
		$(use_with speex speexdsp) \
		$(use_with sqlite sqlite3) \
		$(use_with ssl crypto) \
		$(use_with ssl) \
		$(use_with vorbis ogg) \
		$(use_with vorbis) || die "econf failed"
}

src_compile() {
	ASTLDFLAGS="${LDFLAGS}" emake || die "emake failed"
}

src_install() {
	# setup directory structure
	#
	mkdir -p "${D}"usr/$(get_libdir)/pkgconfig

	emake DESTDIR="${D}" install || die "emake install failed"

	if use samples; then
		emake DESTDIR="${D}" samples || die "emake samples failed"
		for conffile in "${D}"etc/asterisk/*.*
		do
			chown asterisk:asterisk $conffile
			chmod 0660 $conffile
		done
		einfo "Sample files have been installed"
	else
		einfo "Skipping installation of sample files..."
		rm -f  "${D}"var/lib/asterisk/mohmp3/*
		rm -f  "${D}"var/lib/asterisk/sounds/demo-*
		rm -f  "${D}"var/lib/asterisk/agi-bin/*
		rm -f  "${D}"etc/asterisk/*
	fi
	rm -rf "${D}"var/spool/asterisk/voicemail/default

	# keep directories
	diropts -m 0770 -o asterisk -g asterisk
	keepdir	/etc/asterisk
	keepdir /var/lib/asterisk
	keepdir /var/run/asterisk
	keepdir /var/spool/asterisk
	keepdir /var/spool/asterisk/{system,tmp,meetme,monitor,dictate,voicemail}
	diropts -m 0750 -o asterisk -g asterisk
	keepdir /var/log/asterisk/{cdr-csv,cdr-custom}

	newinitd "${FILESDIR}"/1.6.2/asterisk.initd asterisk
	newconfd "${FILESDIR}"/1.6.0/asterisk.confd asterisk

	# some people like to keep the sources around for custom patching
	# copy the whole source tree to /usr/src/asterisk-${PVF} and run make clean there
	if use keepsrc
	then
		dodir /usr/src

		ebegin "Copying sources into /usr/src"
		cp -dPR "${S}" "${D}"/usr/src/${PF} || die "Unable to copy sources"
		eend $?

		ebegin "Cleaning source tree"
		emake -C "${D}"/usr/src/${PF} clean &>/dev/null || die "Unable to clean sources"
		eend $?

		einfo "Clean sources are available in "${ROOT}"usr/src/${PF}"
	fi

	# install the upgrade documentation
	#
	dodoc README UPGRADE* BUGS CREDITS

	# install snmp mib files
	#
	if use snmp
	then
		insinto /usr/share/snmp/mibs/
		doins doc/digium-mib.txt doc/asterisk-mib.txt
	fi

	# install SIP scripts; bug #300832
	#
	dodoc "${FILESDIR}/1.6.2/sip_calc_auth"
	dodoc "${FILESDIR}/1.6.2/find_call_sip_trace.sh"
	dodoc "${FILESDIR}/1.6.2/find_call_ids.sh"
	dodoc "${FILESDIR}/1.6.2/call_data.txt"
}

pkg_preinst() {
	enewgroup asterisk
	enewuser asterisk -1 -1 /var/lib/asterisk "asterisk,dialout"
}

pkg_postinst() {
	#
	# Announcements, warnings, reminders...
	#
	einfo "Asterisk has been installed"
	echo
	elog "If you want to know more about asterisk, visit these sites:"
	elog "http://www.asteriskdocs.org/"
	elog "http://www.voip-info.org/wiki-Asterisk"
	echo
	elog "http://www.automated.it/guidetoasterisk.htm"
	echo
	elog "Gentoo VoIP IRC Channel:"
	elog "#gentoo-voip @ irc.freenode.net"
	echo
	echo
	elog "1.6.1 -> 1.6.2 changes that you may care about:"
	elog "canreinvite -> directmedia (sip.conf)"
	elog "extensive T.38 (fax) changes"
	elog "http://svn.asterisk.org/svn/${PN}/tags/${PV}/UPGRADE.txt"
	elog "or: bzless ${ROOT}usr/share/doc/${PF}/UPGRADE.txt.bz2"
}

pkg_config() {
	einfo "Do you want to reset file permissions and ownerships (y/N)?"

	read tmp
	tmp="$(echo $tmp | tr '[:upper:]' '[:lower:]')"

	if [[ "$tmp" = "y" ]] ||\
		[[ "$tmp" = "yes" ]]
	then
		einfo "Resetting permissions to defaults..."

		for x in spool run lib log; do
			chown -R asterisk:asterisk "${ROOT}"var/${x}/asterisk
			chmod -R u=rwX,g=rwX,o=    "${ROOT}"var/${x}/asterisk
		done

		chown -R root:asterisk  "${ROOT}"etc/asterisk
		chmod -R u=rwX,g=rwX,o= "${ROOT}"etc/asterisk

		einfo "done"
	else
		einfo "skipping"
	fi
}
