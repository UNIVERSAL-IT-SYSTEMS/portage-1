#!/sbin/runscript

extra_commands="${extra_commands} reload checkconfig"

depend() {
	need net
	use dns logger firewall
	after mysql postgresql ido2db
}

checkconfig() {
	# Silent Check
	/usr/sbin/icinga -v /etc/icinga/icinga.cfg &>/dev/null && return 0
	# Now we know there's problem - run again and display errors
	/usr/sbin/icinga -v /etc/icinga/icinga.cfg
	eend $? "Configuration Error. Please fix your configfile"
}

reload()
{
	checkconfig || return 1
	ebegin "Reloading configuration"
	kill -HUP `cat /var/run/icinga/icinga.lock` &>/dev/null
	eend $?
}

start() {
	ebegin "Starting icinga"
	checkpath -d -o icinga:icinga /tmp/icinga /var/run/icinga /var/log/icinga /var/lib/icinga
	checkpath -f -o icinga:icinga /var/log/icinga/icinga.log
	rm -f /var/lib/icinga/rw/icinga.cmd
	start-stop-daemon --start --exec /usr/sbin/icinga -e HOME="/var/lib/icinga/home" --pidfile /var/run/icinga/icinga.lock -- -d /etc/icinga/icinga.cfg
	eend $?
}

stop() {
	ebegin "Stopping icinga"
	start-stop-daemon --stop --pidfile /var/run/icinga/icinga.lock
	rm -f /var/lib/icinga/status.log /var/run/icinga/icinga.lock /var/lib/icinga/rw/icinga.cmd
	rm -r /tmp/icinga
	eend $?
}

svc_restart() {
	checkconfig || return 1
	ebegin "Restarting icinga"
	svc_stop
	svc_start
	eend $?
}
