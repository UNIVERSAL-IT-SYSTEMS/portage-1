# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/python/python-2.4.6.ebuild,v 1.22 2009/10/17 05:03:53 arfrever Exp $

EAPI="1"

inherit autotools eutils flag-o-matic multilib python toolchain-funcs versionator

# We need this so that we don't depend on python.eclass.
PYVER_MAJOR="$(get_major_version)"
PYVER_MINOR="$(get_version_component_range 2)"
PYVER="${PYVER_MAJOR}.${PYVER_MINOR}"

MY_P="Python-${PV}"
S="${WORKDIR}/${MY_P}"

PATCHSET_REVISION="0"

DESCRIPTION="Python is an interpreted, interactive, object-oriented programming language."
HOMEPAGE="http://www.python.org/"
SRC_URI="http://www.python.org/ftp/python/${PV}/${MY_P}.tar.bz2
	mirror://gentoo/python-gentoo-patches-${PV}$([[ "${PATCHSET_REVISION}" != "0" ]] && echo "-r${PATCHSET_REVISION}").tar.bz2"

LICENSE="PSF-2.2"
SLOT="2.4"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="-berkdb bootstrap build +cxx doc elibc_uclibc examples gdbm ipv6 +ncurses +readline ssl +threads tk ucs2 wininst +xml"

RDEPEND=">=app-admin/eselect-python-20090606
		>=sys-libs/zlib-1.1.3
		virtual/libintl
		!build? (
			berkdb? ( || (
				sys-libs/db:4.4
				sys-libs/db:4.3
				sys-libs/db:4.2
			) )
			doc? ( dev-python/python-docs:${SLOT} )
			gdbm? ( sys-libs/gdbm )
			ncurses? (
				>=sys-libs/ncurses-5.2
				readline? ( >=sys-libs/readline-4.1 )
			)
			ssl? ( dev-libs/openssl )
			tk? ( >=dev-lang/tk-8.0 )
			xml? ( dev-libs/expat )
		)"
DEPEND="${RDEPEND}"
RDEPEND+=" !build? ( app-misc/mime-types )"
PDEPEND="app-admin/python-updater"

PROVIDE="virtual/python"

pkg_setup() {
	if use berkdb; then
		ewarn "\"bsddb\" module is out-of-date and no longer maintained inside dev-lang/python. It has"
		ewarn "been additionally removed in Python 3. You should use external, still maintained \"bsddb3\""
		ewarn "module provided by dev-python/bsddb3 which supports both Python 2 and Python 3."
	fi

	if ! has_version "=dev-lang/python-3*"; then
		elog "It is highly recommended to additionally install Python 3, but without configuring Python wrapper to use Python 3."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	if tc-is-cross-compiler; then
		epatch "${FILESDIR}/python-2.4.4-test-cross.patch"
	else
		rm "${WORKDIR}/${PV}"/*_all_crosscompile.patch
	fi

	EPATCH_SUFFIX="patch" epatch "${WORKDIR}/${PV}"

	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" \
		Lib/distutils/command/install.py \
		Lib/distutils/sysconfig.py \
		Lib/site.py \
		Makefile.pre.in \
		Modules/Setup.dist \
		Modules/getpath.c \
		setup.py || die "sed failed to replace @@GENTOO_LIBDIR@@"

	# Fix os.utime() on hppa. utimes it not supported but unfortunately reported as working - gmsoft (22 May 04)
	# PLEASE LEAVE THIS FIX FOR NEXT VERSIONS AS IT'S A CRITICAL FIX !!!
	[[ "${ARCH}" == "hppa" ]] && sed -e "s/utimes //" -i "${S}/configure"

	if ! use wininst; then
		# Remove Microsoft Windows executables.
		rm Lib/distutils/command/wininst-*.exe
	fi

	eautoreconf
}

src_configure() {
	# Disable extraneous modules with extra dependencies.
	if use build; then
		export PYTHON_DISABLE_MODULES="dbm _bsddb gdbm _curses _curses_panel readline _tkinter pyexpat"
		export PYTHON_DISABLE_SSL="1"
	else
		# dbm module can be linked against berkdb or gdbm.
		# Defaults to gdbm when both are enabled, #204343.
		local disable
		use berkdb   || use gdbm || disable+=" dbm"
		use berkdb   || disable+=" _bsddb"
		use gdbm     || disable+=" gdbm"
		use ncurses  || disable+=" _curses _curses_panel"
		use readline || disable+=" readline"
		use ssl      || export PYTHON_DISABLE_SSL="1"
		use tk       || disable+=" _tkinter"
		use xml      || disable+=" pyexpat"
		export PYTHON_DISABLE_MODULES="${disable}"

		if ! use xml; then
			ewarn "You have configured Python without XML support."
			ewarn "This is NOT a recommended configuration as you"
			ewarn "may face problems parsing any XML documents."
		fi
	fi

	if [[ -n "${PYTHON_DISABLE_MODULES}" ]]; then
		einfo "Disabled modules: ${PYTHON_DISABLE_MODULES}"
	fi

	export OPT="${CFLAGS}"

	local myconf
	# If we are creating a new build image, we remove the dependency on g++.
	if use build && ! use bootstrap || ! use cxx; then
		myconf="--with-cxx=no"
	fi

	# Super-secret switch. Don't use this unless you know what you're
	# doing. Enabling UCS2 support will break your existing python
	# modules
	use ucs2 \
		&& myconf+=" --enable-unicode=ucs2" \
		|| myconf+=" --enable-unicode=ucs4"

	filter-flags -malign-double

	[[ "${ARCH}" == "alpha" ]] && append-flags -fPIC

	# https://bugs.gentoo.org/show_bug.cgi?id=50309
	if is-flag -O3; then
		is-flag -fstack-protector-all && replace-flags -O3 -O2
		use hardened && replace-flags -O3 -O2
	fi

	if tc-is-cross-compiler; then
		OPT="-O1" CFLAGS="" LDFLAGS="" CC="" \
		./configure --with-cxx=no --{build,host}=${CBUILD} || die "cross-configure failed"
		emake python Parser/pgen || die "cross-make failed"
		mv python hostpython
		mv Parser/pgen Parser/hostpgen
		make distclean
		sed -i \
			-e "/^HOSTPYTHON/s:=.*:=./hostpython:" \
			-e "/^HOSTPGEN/s:=.*:=./Parser/hostpgen:" \
			Makefile.pre.in || die "sed failed"
	fi

	# Export CXX so it ends up in /usr/lib/python2.X/config/Makefile.
	tc-export CXX
	# Set LINKCC to prevent Python from being linked to libstdc++.so.
	export LINKCC="\$(PURIFY) \$(CC)"
	econf \
		--with-fpectl \
		--enable-shared \
		$(use_enable ipv6) \
		$(use_with threads) \
		--infodir='${prefix}'/share/info \
		--mandir='${prefix}'/share/man \
		--with-libc='' \
		${myconf}
}

src_compile() {
	src_configure
	emake || die "emake failed"
}

src_test() {
	# Tests won't work when cross compiling.
	if tc-is-cross-compiler; then
		elog "Disabling tests due to crosscompiling."
		return
	fi

	# Byte compiling should be enabled here.
	# Otherwise test_import fails.
	python_enable_pyc

	# Skip all tests that fail during emerge but pass without emerge:
	# (See bug #67970)
	local skip_tests="cookielib distutils global hotshot mimetools minidom mmap posix sax strptime subprocess syntax tcl time urllib urllib2"

	for test in ${skip_tests}; do
		mv "${S}/Lib/test/test_${test}.py" "${T}"
	done

	# Rerun failed tests in verbose mode (regrtest -w).
	EXTRATESTOPTS="-w" make test || die "make test failed"

	for test in ${skip_tests}; do
		mv "${T}/test_${test}.py" "${S}/Lib/test/test_${test}.py"
	done

	elog "The following tests have been skipped:"
	for test in ${skip_tests}; do
		elog "test_${test}.py"
	done

	elog "If you'd like to run them, you may:"
	elog "cd /usr/$(get_libdir)/python${PYVER}/test"
	elog "and run the tests separately."
}

src_install() {
	emake DESTDIR="${D}" altinstall maninstall || die "emake altinstall maninstall failed"

	# Install our own custom python-config
	exeinto /usr/bin
	newexe "${FILESDIR}"/python-config-${PYVER}-r1 python-config-${PYVER}

	# Use correct libdir in python-config
	dosed "s:/usr/lib/:/usr/$(get_libdir)/:" /usr/bin/python-config-${PYVER}

	# Fix collisions between different slots of Python.
	mv "${D}usr/bin/pydoc" "${D}usr/bin/pydoc${PYVER}"
	mv "${D}usr/bin/idle" "${D}usr/bin/idle${PYVER}"
	mv "${D}usr/share/man/man1/python.1" "${D}usr/share/man/man1/python${PYVER}.1"
	rm -f "${D}usr/bin/smtpd.py"

	# Fix the OPT variable so that it doesn't have any flags listed in it.
	# Prevents the problem with compiling things with conflicting flags later.
	sed -e "s:^OPT=.*:OPT=-DNDEBUG:" -i "${D}usr/$(get_libdir)/python${PYVER}/config/Makefile"

	# Python 2.4 partially doesn't respect $(get_libdir).
	if use build; then
		rm -fr "${D}"usr/lib*/python${PYVER}/{bsddb,email,lib-tk,test}
	else
		use elibc_uclibc && rm -fr "${D}"usr/lib*/python${PYVER}/{bsddb/test,test}
		use berkdb || rm -fr "${D}"usr/lib*/python${PYVER}/{bsddb,test/test_bsddb*}
		use tk || rm -fr "${D}"usr/lib*/python${PYVER}/lib-tk
	fi

	prep_ml_includes usr/include/python${PYVER}

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}/Tools" || die "doins failed"
	fi

	newinitd "${FILESDIR}/pydoc.init" pydoc-${SLOT}
	newconfd "${FILESDIR}/pydoc.conf" pydoc-${SLOT}
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-${SLOT}" && ! has_version ">=${CATEGORY}/${PN}-${SLOT}_alpha"; then
		python_updater_warning="1"
	fi
}

eselect_python_update() {
	local ignored_python_slots
	[[ "$(eselect python show)" == "python2."* ]] && ignored_python_slots="--ignore 3.0 --ignore 3.1 --ignore 3.2"

	# Create python2 symlink.
	eselect python update --ignore 3.0 --ignore 3.1 --ignore 3.2 > /dev/null

	eselect python update ${ignored_python_slots}
}

pkg_postinst() {
	eselect_python_update

	python_mod_optimize -x "(site-packages|test)" /usr/lib/python${PYVER}
	[[ "$(get_libdir)" != "lib" ]] && python_mod_optimize -x "(site-packages|test)" /usr/$(get_libdir)/python${PYVER}

	if [[ "${python_updater_warning}" == "1" ]]; then
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
		ewarn "You have just upgraded from an older version of Python."
		ewarn "You should run 'python-updater \${options}' to rebuild Python modules."
		ewarn
		ewarn "\e[1;31m************************************************************************\e[0m"
		ewarn
		ebeep 12
	fi
}

pkg_postrm() {
	eselect_python_update

	python_mod_cleanup /usr/lib/python${PYVER}
	[[ "$(get_libdir)" != "lib" ]] && python_mod_cleanup /usr/$(get_libdir)/python${PYVER}
}
