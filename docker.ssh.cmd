#!/bin/bash
local_config_dir="$(dirname "$(readlink -f "$0")")"
source "${local_config_dir}/docker.config"

declare -a parameters

while [ "$#" -gt 0 ]
do
	if [ "${1:0:1}" == '-' ]
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

if [[ -v DEBUG ]]
then
	logging=("-v")
else
	logging=("-o" "LogLevel=QUIET")
fi

/usr/bin/ssh ${interactive_tty} -C -e none -Y "${logging[@]}" -l "${remote_docker_user}" "${parameters[@]}" "${remote_docker_host}" "${remote_command}"
