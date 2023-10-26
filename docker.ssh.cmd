#!/bin/bash
debug () [[ -v DEBUG ]]

debug && set -x
debug && set -o xtrace
debug && set -v

userName="docker"
hostName="docker.local"

declare -a parameters

while [ "$#" -gt 0 ]
do
	if [ ${1:0:1} == '-' ]
	then
		parameters+=("$1")
		shift
	else
		break
	fi
done

printf -v remote_command '%q ' "$@"

# Source: https://scripter.co/nim-check-if-stdin-stdout-are-associated-with-terminal-or-pipe/
if [[ -t 0 ]]
then
	# terminal
	interactive_tty=""
else
	# pipe
	interactive_tty="-n"
fi

/usr/bin/ssh ${interactive_tty} -C -e none -Y -o LogLevel=QUIET -l "${userName}" "${parameters[@]}" "${hostName}" "${remote_command}"
