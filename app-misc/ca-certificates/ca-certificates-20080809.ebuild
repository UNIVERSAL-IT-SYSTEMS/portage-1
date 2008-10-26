# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ca-certificates/ca-certificates-20080809.ebuild,v 1.2 2008/10/26 03:48:40 vapier Exp $

inherit eutils

DESCRIPTION="Common CA Certificates PEM files"
HOMEPAGE="http://packages.debian.org/sid/ca-certificates"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}_all.deb"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND="|| ( >=sys-apps/coreutils-6.10-r1 sys-apps/mktemp sys-freebsd/freebsd-ubin )"
RDEPEND="${DEPEND}
	dev-libs/openssl
	sys-apps/debianutils"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
	rm -f control.tar.gz data.tar.gz debian-binary
	epatch "${FILESDIR}"/ca-certificates-20080514-warn-on-bad-symlinks.patch
}

pkg_setup() {
	# For the conversion to having it in CONFIG_PROTECT_MASK,
	# we need to tell users about it once manually first.
	[[ -f /etc/env.d/98ca-certificates ]] \
		|| ewarn "You should run update-ca-certificates manually after etc-update"
}

src_install() {
	cp -pPR * "${D}"/ || die "installing data failed"

	(
	echo "# Automatically generated by ${CAT}/${PF}"
	echo "# $(date -u)"
	echo "# Do not edit."
	cd "${D}"/usr/share/ca-certificates
	find . -name '*.crt' | sort | cut -b3-
	) > "${D}"/etc/ca-certificates.conf

	mv "${D}"/usr/share/doc/{ca-certificates,${PF}} || die
	prepalldocs
	dodir /etc/env.d/
	echo 'CONFIG_PROTECT_MASK="/etc/ca-certificates.conf"' \
		>"${D}/etc/env.d/98ca-certificates"
}

pkg_postinst() {
	local badcerts=0
	for c in $(find -L "${ROOT}"etc/ssl/certs/ -type l) ; do
		ewarn "Broken symlink for a certificate at $c"
		badcerts=1
	done
	if [[ $badcerts -eq 1 ]]; then
		ewarn "You MUST remove the above broken symlinks"
		ewarn "Otherwise any SSL validation that use the directory may fail!"
	fi

	[[ ${ROOT} != "/" ]] && return 0
	# However it's too overzealous when the user has custom certs in place.
	# --fresh is to clean up dangling symlinks
	update-ca-certificates
}
