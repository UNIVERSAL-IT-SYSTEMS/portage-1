# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgresql-server/postgresql-server-8.3.14-r1.ebuild,v 1.1 2011/03/21 03:50:18 titanofold Exp $

EAPI="3"

WANT_AUTOMAKE="none"
inherit autotools eutils multilib pam prefix versionator

SLOT="$(get_version_component_range 1-2)"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

DESCRIPTION="PostgreSQL server"
HOMEPAGE="http://www.postgresql.org/"
SRC_URI="mirror://postgresql/source/v${PV}/postgresql-${PV}.tar.bz2
		 http://dev.gentoo.org/~titanofold/postgresql-patches-${SLOT}.tbz2
		 http://dev.gentoo.org/~titanofold/postgresql-initscript-1.1.tbz2"
LICENSE="POSTGRESQL"

S=${WORKDIR}/postgresql-${PV}

LINGUAS="af cs de es fa fr hr hu it ko nb pl pt_BR ro ru sk sl sv tr zh_CN zh_TW"
IUSE="doc kernel_linux nls pam perl python selinux tcl uuid xml"

for lingua in ${LINGUAS} ; do
	IUSE+=" linguas_${lingua}"
done

wanted_languages() {
	local enable_langs

	for lingua in ${LINGUAS} ; do
		use linguas_${lingua} && enable_langs+="${lingua} "
	done

	echo -n ${enable_langs}
}

RDEPEND="~dev-db/postgresql-base-${PV}:${SLOT}[pam?,nls=]
	perl? ( >=dev-lang/perl-5.8 )
	python? ( >=dev-lang/python-2.2 dev-python/egenix-mx-base )
	selinux? ( sec-policy/selinux-postgresql )
	tcl? ( >=dev-lang/tcl-8 )
	uuid? ( dev-libs/ossp-uuid )
	xml? ( dev-libs/libxml2 dev-libs/libxslt )"
DEPEND="${RDEPEND}
	sys-devel/flex
	xml? ( dev-util/pkgconfig )"
PDEPEND="doc? ( ~dev-db/postgresql-docs-${PV} )"

pkg_setup() {
	enewgroup postgres 70
	enewuser postgres 70 /bin/bash ${EROOT%/}/var/lib/postgresql postgres
}

src_prepare() {
	epatch "${WORKDIR}/autoconf.patch" \
		"${WORKDIR}/server.patch" \
		"${WORKDIR}/SuperH.patch" \
		"${WORKDIR}/darwin.patch"

	eprefixify src/include/pg_config_manual.h

	if use test ; then
		epatch "${WORKDIR}/regress.patch"
		sed -e "s|@SOCKETDIR@|${S}|g" -i src/test/regress/pg_regress{,_main}.c
		sed -e "s|/no/such/location|${S}/src/test/regress/tmp_check/no/such/location|g" -i src/test/regress/{input,output}/tablespace.source
	else
		echo "all install:" > "${S}/src/test/regress/GNUmakefile"
	fi

	eautoconf
}

src_configure() {
	# eval is needed to get along with pg_config quotation of space-rich entities.
	eval econf "$(${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin/pg_config --configure)" \
		--disable-thread-safety \
		$(use_with perl) \
		$(use_with python) \
		$(use_with tcl) \
		$(use_with xml libxml) \
		$(use_with xml libxslt) \
		$(use_with uuid ossp-uuid) \
		--with-system-tzdata="${EROOT%/}/usr/share/zoneinfo" \
		--with-includes="${EROOT%/}/usr/include/postgresql-${SLOT}/" \
		"$(has_version ~dev-db/postgresql-base-${PV}[nls] && use_enable nls nls "$(wanted_languages)")" \
		|| die "configure failed"
}

src_compile() {
	for bd in . contrib $(use xml && echo contrib/xml2); do
		PATH="${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin:${PATH}" \
			emake -C $bd -j1 \
				PGXS=$(${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin/pg_config --pgxs) \
				PGXS_IN_SERVER=1 PGXS_WITH_SERVER="${S}/src/backend/postgres" \
				NO_PGXS=0 USE_PGXS=1 docdir=${EROOT%/}/usr/share/doc/${PF} || die "emake in $bd failed"
	done
}

src_install() {
	if use perl ; then
		mv -f "${S}/src/pl/plperl/GNUmakefile" "${S}/src/pl/plperl/GNUmakefile_orig"
		sed -e "s:\$(DESTDIR)\$(plperl_installdir):\$(plperl_installdir):" \
			"${S}/src/pl/plperl/GNUmakefile_orig" > "${S}/src/pl/plperl/GNUmakefile"
	fi

	for bd in . contrib $(use xml && echo contrib/xml2) ; do
		PATH="${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin:${PATH}" \
			emake install -C $bd -j1 DESTDIR="${D}" \
				PGXS_IN_SERVER=1 PGXS_WITH_SERVER="${S}/src/backend/postgres" \
				PGXS=$(${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin/pg_config --pgxs) \
				NO_PGXS=0 USE_PGXS=1 docdir=${EROOT%/}/usr/share/doc/${PF} || die "emake install in $bd failed"
	done

	rm -r "${ED}/usr/share/postgresql-${SLOT}/man/man7/" "${ED}/usr/share/doc/${PF}/html" || die
	rm "${ED}"/usr/share/postgresql-${SLOT}/man/man1/{clusterdb,create{db,lang,user},drop{db,lang,user},ecpg,pg_{config,dump,dumpall,restore},psql,reindexdb,vacuumdb}.1 || die

	dodoc README HISTORY doc/{README.*,TODO,bug.template}

	dodir /etc/eselect/postgresql/slots/${SLOT}
	cat >"${ED}/etc/eselect/postgresql/slots/${SLOT}/service" <<-__EOF__
		postgres_ebuilds="\${postgres_ebuilds} ${PF}"
		postgres_service="postgresql-${SLOT}"
	__EOF__

	sed -e "s/@SLOT@/${SLOT}/g" -i "${WORKDIR}"/postgresql.confd
	newconfd "${WORKDIR}/postgresql.confd" postgresql-${SLOT} || die "Inserting conf.d file failed"
	sed -e "s/@SLOT@/${SLOT}/g" -i "${WORKDIR}"/postgresql.init
	newinitd "${WORKDIR}/postgresql.init" postgresql-${SLOT} || die "Inserting init.d file failed"

	use pam && pamd_mimic system-auth postgresql auth account session

	keepdir /var/run/postgresql
	fperms 0770 /var/run/postgresql
	fowners postgres:postgres /var/run/postgresql
}

pkg_postinst() {
	eselect postgresql update
	[[ "$(eselect postgresql show)" = "(none)" ]] && eselect postgresql set ${SLOT}
	[[ "$(eselect postgresql show-service)" = "(none)" ]] && eselect postgresql set-service ${SLOT}

	elog "The Unix-domain socket is located in:"
	elog "    ${EROOT%/}/var/run/postgresql/"
	elog
	elog "If you have users and/or services that you would like to utilize the socket,"
	elog "you must add them to the 'postgres' system group:"
	elog "    usermod -a -G postgres <user>"
	elog
	elog "Before initializing the database, you may want to edit PG_INITDB_OPTS so that"
	elog "it contains your preferred locale in:"
	elog "    ${EROOT%/}/etc/conf.d/postgresql-${SLOT}"
	elog
	elog "Execute the following command to setup the initial database"
	elog "environment:"
	elog "    emerge --config =${CATEGORY}/${PF}"
}

pkg_postrm() {
	eselect postgresql update
}

pkg_config() {
	[[ -f ${EROOT%/}/etc/conf.d/postgresql-${SLOT} ]] && source ${EROOT%/}/etc/conf.d/postgresql-${SLOT}
	[[ -z "${PGDATA}" ]] && PGDATA="${EROOT%/}/etc/postgresql-${SLOT}/"
	[[ -z "${DATA_DIR}" ]] && DATA_DIR="${EROOT%/}/var/lib/postgresql/${SLOT}/data"

	# environment.bz2 may not contain the same locale as the current system
	# locale. Unset and source from the current system locale.
	if [ -f ${EROOT%/}/etc/env.d/02locale ]; then
		unset LANG
		unset LC_CTYPE
		unset LC_NUMERIC
		unset LC_TIME
		unset LC_COLLATE
		unset LC_MONETARY
		unset LC_MESSAGES
		unset LC_ALL
		source ${EROOT%/}/etc/env.d/02locale
		[ -n "${LANG}" ] && export LANG
		[ -n "${LC_CTYPE}" ] && export LC_CTYPE
		[ -n "${LC_NUMERIC}" ] && export LC_NUMERIC
		[ -n "${LC_TIME}" ] && export LC_TIME
		[ -n "${LC_COLLATE}" ] && export LC_COLLATE
		[ -n "${LC_MONETARY}" ] && export LC_MONETARY
		[ -n "${LC_MESSAGES}" ] && export LC_MESSAGES
		[ -n "${LC_ALL}" ] && export LC_ALL
	fi

	einfo "You can modify the paths and options passed to initdb by editing:"
	einfo "    ${EROOT%/}"
	einfo
	einfo "Information on options that can be passed to initdb are found at:"
	einfo "    http://www.postgresql.org/docs/${SLOT}/static/creating-cluster.html"
	einfo "    http://www.postgresql.org/docs/${SLOT}/static/app-initdb.html"
	einfo
	einfo "PG_INITDB_OPTS is currently set to:"
	if [[ -z "${PG_INITDB_OPTS}" ]] ; then
		einfo "    (none)"
	else
		einfo "    ${PG_INITDB_OPTS}"
	fi
	einfo
	einfo "Configuration files will be installed to:"
	einfo "    ${PGDATA}"
	einfo
	einfo "The database cluster will be created in:"
	einfo "    ${DATA_DIR}"
	einfo
	while [ "$correct" != "true" ] ; do
		einfo "Are you ready to continue? (Y/n)"
		read answer
		if [[ $answer =~ ^[Yy](|[Ee][Ss])$ ]] ; then
			correct="true"
		elif [[ $answer =~ ^[Nn](|[Oo])$ ]] ; then
			die "Aborting initialization."
		else
			echo "Answer not recognized."
		fi
	done

	if [ -n "$(ls -A ${DATA_DIR} 2> /dev/null)" ] ; then
		eerror "The given directory, '${DATA_DIR}', is not empty."
		eerror "Modify DATA_DIR to point to an empty directory."
		die "${DATA_DIR} is not empty."
	fi

	[ -z "${PG_MAX_CONNECTIONS}" ] && PG_MAX_CONNECTIONS="128"
	einfo "Checking system parameters..."

	if ! use kernel_linux ; then
		einfo "Skipped."
		einfo "Tests not supported on this OS (yet)."
	else
		if [ -z ${SKIP_SYSTEM_TESTS} ] ; then
			einfo "Checking whether your system supports at least ${PG_MAX_CONNECTIONS} connections..."

			local SEMMSL=$(sysctl -n kernel.sem | cut -f1)
			local SEMMNS=$(sysctl -n kernel.sem | cut -f2)
			local SEMMNI=$(sysctl -n kernel.sem | cut -f4)
			local SHMMAX=$(sysctl -n kernel.shmmax)

			local SEMMSL_MIN=17
			local SEMMNS_MIN=$(( ( ${PG_MAX_CONNECTIONS}/16 ) * 17 ))
			local SEMMNI_MIN=$(( ( ${PG_MAX_CONNECTIONS}+15 ) / 16 ))
			local SHMMAX_MIN=$(( 500000 + ( 30600 * ${PG_MAX_CONNECTIONS} ) ))

			for p in SEMMSL SEMMNS SEMMNI SHMMAX ; do
				if [ $(eval echo \$$p) -lt $(eval echo \$${p}_MIN) ] ; then
					eerror "The value for ${p} $(eval echo \$$p) is below the recommended value $(eval echo \$${p}_MIN)"
					eerror "You have now several options:"
					eerror "  - Change the mentioned system parameter"
					eerror "  - Lower the number of max connections by setting PG_MAX_CONNECTIONS to a"
					eerror "    value lower than ${PG_MAX_CONNECTIONS}"
					eerror "  - Set SKIP_SYSTEM_TESTS in case you want to ignore this test completely"
					eerror "More information can be found here:"
					eerror "    http://www.postgresql.org/docs/${SLOT}/static/kernel-resources.html"
					die "System test failed."
				fi
			done
			einfo "Passed."
		else
			ewarn "SKIP_SYSTEM_TESTS is set, so skipping."
		fi
	fi

	einfo "Creating the data directory ..."
	mkdir -p "${DATA_DIR}"
	chown -Rf postgres:postgres "${DATA_DIR}"
	chmod 0700 "${DATA_DIR}"

	einfo "Initializing the database ..."

	su postgres -c "${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin/initdb --pgdata \"${DATA_DIR}\" ${PG_INITDB_OPTS}"

	mv ${DATA_DIR%/}/*.conf ${PGDATA}

	einfo "The autovacuum function, which was in contrib, has been moved to the main"
	einfo "PostgreSQL functions starting with 8.1. You can enable it in the clusters"
	einfo "postgresql.conf."
	einfo
	einfo "You can use the '${EROOT%/}/etc/init.d/postgresql-${SLOT}' script to run PostgreSQL"
	einfo "instead of 'pg_ctl'."
}

src_test() {
	einfo ">>> Test phase [check]: ${CATEGORY}/${PF}"

	if [ ${UID} -ne 0 ] ; then
		PATH="${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin/:${PATH}" \
			emake -j1 check \
			PGXS=$(${EROOT%/}/usr/$(get_libdir)/postgresql-${SLOT}/bin/pg_config --pgxs) \
			NO_PGXS=0 USE_PGXS=1 SLOT=${SLOT} || die "Make check failed. See above for details."

		einfo "If you think other tests besides the regression tests are necessary, please"
		einfo "submit a bug including a patch for this ebuild to enable them."
	else
		ewarn "Tests cannot be run as root. Skipping."
		ewarn "HINT: FEATURES=\"userpriv\""
	fi
}
