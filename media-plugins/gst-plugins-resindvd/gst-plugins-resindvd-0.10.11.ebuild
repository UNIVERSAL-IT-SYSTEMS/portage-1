# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-resindvd/gst-plugins-resindvd-0.10.11.ebuild,v 1.1 2009/03/30 05:53:58 tester Exp $

inherit gst-plugins-bad

KEYWORDS="~x86"
IUSE=""

RDEPEND=">=media-libs/libdvdnav-0.1.10
	>=media-libs/gstreamer-0.10.22
	>=media-libs/gst-plugins-base-0.10.22"
DEPEND="${RDEPEND}"

# The configure option is dvdnav
GST_PLUGINS_BUILD="dvdnav"
