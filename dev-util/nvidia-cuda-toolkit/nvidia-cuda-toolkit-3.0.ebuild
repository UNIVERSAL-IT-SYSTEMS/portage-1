# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-3.0.ebuild,v 1.6 2010/07/05 12:55:49 spock Exp $

EAPI=2

inherit eutils multilib

DESCRIPTION="NVIDIA CUDA Toolkit"
HOMEPAGE="http://developer.nvidia.com/cuda"

CUDA_V=${PV//_/-}
DIR_V=${CUDA_V//./_}
DIR_V=${DIR_V//beta/Beta}

BASE_URI="http://developer.download.nvidia.com/compute/cuda/${DIR_V}/toolkit"
SRC_URI="amd64? ( ${BASE_URI}/cudatoolkit_${CUDA_V}_linux_64_rhel5.3.run )
	x86? ( ${BASE_URI}/cudatoolkit_${CUDA_V}_linux_32_rhel5.3.run )"

LICENSE="NVIDIA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debugger doc profiler opencl"

DEPEND="!dev-util/nvidia-cuda-profiler"
RDEPEND="${DEPEND}
	>=sys-devel/binutils-2.20
	>=sys-devel/gcc-4.0
	profiler? ( x86? (
		x11-libs/qt-gui
		x11-libs/qt-core
		x11-libs/qt-assistant
		x11-libs/qt-sql[sqlite] )
		media-libs/libpng:1.2
	)
	debugger? ( >=sys-libs/libtermcap-compat-2.0.8-r2 )"
RESTRICT="strip binchecks"

S="${WORKDIR}"

src_unpack() {
	for f in ${A} ; do
		if [ "${f//*.run/}" == "" ]; then
			unpack_makeself ${f}
		fi
	done
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-enum_fix.patch
}

src_install() {
	local DEST=/opt/cuda

	into ${DEST}
	dobin bin/*
	dolib $(get_libdir)/*

	if ! use debugger; then
		rm -f "${D}/${DEST}/bin/cuda-gdb"
	fi

	chmod a-x "${D}/${DEST}/bin/nvcc.profile"

	# doman does not respect DESTTREE
	insinto ${DEST}/man/man1
	doins man/man1/*
	insinto ${DEST}/man/man3
	doins man/man3/*
	prepman ${DEST}

	insinto ${DEST}/include
	doins -r include/*

	insinto ${DEST}/src
	doins src/*

	if use doc ; then
		insinto ${DEST}/doc
		doins -r doc/*
	fi

	cat > "${T}/env" << EOF
PATH=${DEST}/bin
ROOTPATH=${DEST}/bin
LDPATH=${DEST}/$(get_libdir)
MANPATH=${DEST}/man
EOF
	newenvd "${T}/env" 99cuda

	if use profiler; then
		local targets="cudaprof"
		if use opencl; then
			targets="${targets} openclprof"
		fi

		for target in ${targets}; do
			into ${DEST}/${target}
			dobin ${target}/bin/${target}

			cat > "${T}/env" << EOF
PATH=${DEST}/${target}/bin
ROOTPATH=${DEST}/${target}/bin
EOF
			if use x86 ; then
				dosym /usr/bin/assistant ${DEST}/${target}/bin
			else
				dobin ${target}/bin/assistant
				insinto ${DEST}/${target}/bin
				doins ${target}/bin/*.so*
				insinto ${DEST}/${target}/bin/sqldrivers
				doins ${target}/bin/sqldrivers/*

				cat >> "${T}/env" << EOF
LDPATH=${DEST}/${target}/bin
EOF
			fi

			newenvd "${T}/env" 99${target}

			if use doc; then
				insinto ${DEST}/${target}
				doins ${target}/*.txt
				insinto ${DEST}/${target}/doc
				doins ${target}/doc/*
				insinto ${DEST}/${target}/projects
				doins ${target}/projects/*
			fi

			if [ "$target" == "cudaprof" ]; then
				make_desktop_entry /opt/cuda/cudaprof/bin/cudaprof "CUDA Visual Profiler"
			else
				make_desktop_entry /opt/cuda/openclprof/bin/openclprof "OpenCL Visual Profiler"
			fi
		done
	fi

	export CONF_LIBDIR_OVERRIDE="lib"
	# HACK: temporary workaround until CONF_LIBDIR_OVERRIDE is respected.
	export LIBDIR_amd64="lib"

	into ${DEST}/open64
	dobin open64/bin/*
	libopts -m0755
	dolib open64/lib/*
}

pkg_postinst() {
	env-update
	elog "If you want to natively run the code generated by this version of the"
	elog "CUDA toolkit, you will need >=x11-drivers/nvidia-drivers-195.36.15."
	elog ""
	elog "Run '. /etc/profile' before using the CUDA toolkit. "
}
