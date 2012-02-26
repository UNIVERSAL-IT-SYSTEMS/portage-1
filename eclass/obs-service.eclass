# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/obs-service.eclass,v 1.2 2012/02/25 22:56:56 miska Exp $

# @ECLASS: obs-service.eclass
# @MAINTAINER:
# miska@gentoo.org
# @BLURB: Reduces code duplication in the Open Build Service services.
# @DESCRIPTION:
# This eclass makes it easier to package Open Build Service services. Based on
# provided information it will set all needed variables and takes care of
# installation.
#
# @EXAMPLE:
# Typical ebuild using obs-service.eclass:
#
# @CODE
# EAPI=4
#
# inherit obs-service
#
# KEYWORDS=""
#
# DEPEND=""
# RDEPEND="${DEPEND}"
#
# @CODE

# @ECLASS-VARIABLE: OBS_SERVICE_NAME
# @DESCRIPTION:
# Name of the service. If not set, it is taken from ${PN}.

# @ECLASS-VARIABLE: OPENSUSE_RELEASE
# @DESCRIPTION:
# From which stable openSUSE realease to take a package.

# @ECLASS-VARIABLE: ADDITIONAL_FILES
# @DEFAULT_UNSET
# @DESCRIPTION:
# If any additional files are needed.

case "${EAPI:-0}" in
	4) : ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

HOMEPAGE="http://en.opensuse.org/openSUSE:OSC"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
RDEPEND="dev-util/osc"

[[ -n ${OBS_SERVICE_NAME} ]] || OBS_SERVICE_NAME=${PN/obs-service-/}
[[ -n ${OPENSUSE_RELEASE} ]] || OBS_PROJECT="openSUSE:Tools"

DESCRIPTION="Open Build Service client module - ${OBS_SERVICE_NAME} service"
OBS_PACKAGE="obs-service-${OBS_SERVICE_NAME}"

inherit obs-download

SRC_URI="${OBS_URI}/${OBS_SERVICE_NAME}"
SRC_URI+=" ${OBS_URI}/${OBS_SERVICE_NAME}.service"

for i in ${ADDITIONAL_FILES}; do
	SRC_URI+=" ${OBS_URI}/${i}"
done

# @FUNCTION: obs-service_src_unpack
# @DESCRIPTION:
# Just copy files. Files are not compressed.
obs-service_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"
	cd "${DISTDIR}"
	mkdir -p "${S}"
	cp ${A} "${S}"
}

# @FUNCTION: obs-service_src_prepare
# @DESCRIPTION:
# Replaces all /usr/lib/build directories with /usr/share/suse-build to reflect
# where suse-build is installed in Gentoo.
obs-service_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"
	debug-print "Replacing all paths to find suse-build in Gentoo"
	find "${S}" -type f -exec \
		sed -i 's|/usr/lib/build|/usr/share/suse-build|g' {} +
}

# @FUNCTION: obs-service_src_install
# @DESCRIPTION:
# Does the installation of the downloaded files.
obs-service_src_install() {
	debug-print-function ${FUNCNAME} "$@"
	debug-print "Installing service \"${OBS_SERVICE_NAME}\""
	exeinto /usr/lib/obs/service
	doexe "${S}"/${OBS_SERVICE_NAME}
	insinto /usr/lib/obs/service
	doins "${S}"/${OBS_SERVICE_NAME}.service
	if [[ -n ${ADDITIONAL_FILES} ]]; then
		debug-print "Installing following additional files:"
		debug-print "	${ADDITIONAL_FILES}"
		exeinto /usr/lib/obs/service/${OBS_SERVICE_NAME}.files
		for i in ${ADDITIONAL_FILES}; do
			doexe "${S}"/${i}
		done
	fi
}

EXPORT_FUNCTIONS src_install src_prepare src_unpack
