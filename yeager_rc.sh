#!/bin/sh

# PROVIDE: yeager
# REQUIRE: networking
# KEYWORD: shutdown

. /etc/rc.subr

name="yeager"
rcvar=${name}_enable
pidfile="/var/run/${name}.pid"
cmd="/usr/local/bin/yeager -config /usr/local/etc/yeager/config.json"
output="/var/log/${name}.log"

command="/usr/sbin/daemon"
command_args="-P ${pidfile} -r -o ${output} ${cmd}"

load_rc_config $name
: ${yeager_enable:=no}

start() {
  echo "Starting ${name}"
  daemon $command_args
}

stop() {
  echo "Stopping ${name}"
  kill `cat ${pidfile}`
}

status() {
  if [ -f "${pidfile}" ]; then
    echo "${name} is running"
  else
    echo "${name} is not running"
  fi
}

run_rc_command "$1"
