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

/usr/bin/ssh -C -e none -Y -o LogLevel=QUIET -l "${remote_docker_user}" "${parameters[@]}" "${remote_docker_host}" "${remote_command}"
