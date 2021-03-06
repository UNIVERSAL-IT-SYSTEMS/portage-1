# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-keyring/gnome-keyring-3.2.2.ebuild,v 1.9 2012/05/21 18:53:30 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils gnome2 multilib pam versionator virtualx

DESCRIPTION="Password and keyring managing daemon"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE="+caps debug doc pam test"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"

# USE=valgrind is probably not a good idea for the tree
RDEPEND=">=dev-libs/glib-2.25:2
	>=x11-libs/gtk+-2.90.0:3
	>=app-crypt/p11-kit-0.6
	app-misc/ca-certificates
	>=dev-libs/libgcrypt-1.2.2
	>=dev-libs/libtasn1-1
	>=sys-apps/dbus-1.0
	caps? ( sys-libs/libcap-ng )
	pam? ( virtual/pam )
"
#	valgrind? ( dev-util/valgrind )
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/gtk-doc-am-1.9
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )"
PDEPEND=">=gnome-base/libgnome-keyring-3.1.92"
# eautoreconf needs:
#	>=dev-util/gtk-doc-am-1.9

# FIXME: tests are flaky and write to /tmp (instead of TMPDIR)
RESTRICT="test"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)
		$(use_with caps libcap-ng)
		$(use_enable pam)
		$(use_with pam pam-dir $(getpam_mod_dir))
		--with-root-certs=${EPREFIX}/etc/ssl/certs/
		--enable-ssh-agent
		--enable-gpg-agent
		--disable-update-mime"
#		$(use_enable valgrind)
}

src_prepare() {
	# Disable gcr tests due to weirdness with opensc
	# ** WARNING **: couldn't load PKCS#11 module: /usr/lib64/pkcs11/gnome-keyring-pkcs11.so: Couldn't initialize module: The device was removed or unplugged
	sed -e 's/^\(SUBDIRS = \.\)\(.*\)/\1/' \
		-i gcr/Makefile.* || die "sed failed"

	# gold plus glib-2.32 underlinking fix
	epatch "${FILESDIR}"/${P}-gold-glib-2.32.patch

	gnome2_src_prepare
	AT_NOELIBTOOLIZE=yes eautoreconf
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}

pkg_postinst() {
	use caps && fcaps 0:0 755 cap_ipc_lock "${ROOT}"/usr/bin/gnome-keyring-daemon

	gnome2_pkg_postinst
}

# borrowed from GSoC2010_Gentoo_Capabilities by constanze and Flameeyes
# @FUNCTION: fcaps
# @USAGE: fcaps {uid:gid} {file-mode} {cap1[,cap2,...]} {file}
# @RETURN: 0 if all okay; non-zero if failure and fallback
# @DESCRIPTION:
# fcaps sets the specified capabilities in the effective and permitted set of
# the given file. In case of failure fcaps sets the given file-mode.
# Requires versionator.eclass
fcaps() {
	local uid_gid=$1
	local perms=$2
	local capset=$3
	local path=$4
	local res

	chmod $perms $path && \
	chown $uid_gid $path
	res=$?

	use caps || return $res

	#set the capability
	setcap "$capset=ep" "$path" &> /dev/null
	#check if the capabilitiy got set correctly
	setcap -v "$capset=ep" "$path" &> /dev/null
	res=$?

	if [ $res -ne 0 ]; then
		ewarn "Failed to set capabilities. Probable reason is missing kernel support."
		ewarn "Your kernel must have <FS>_FS_SECURITY enabled (e.g. EXT4_FS_SECURITY)"
		ewarn "where <FS> is the filesystem to store ${path}"
		if ! version_is_at_least 2.6.33 "$(uname -r)"; then
			ewarn "For kernel 2.6.32 or older, you will also need to enable"
			ewarn "SECURITY_FILE_CAPABILITIES."
		fi
		ewarn
		ewarn "Falling back to suid now..."
		chmod u+s ${path}
	fi
	return $res
}
