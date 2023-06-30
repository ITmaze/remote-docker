#!/bin/bash
debug () [[ -v DEBUG ]]

debug && set -x
debug && set -o xtrace
debug && set -v

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

/usr/bin/ssh -C -e none -Y -o LogLevel=QUIET -l docker "${parameters[@]}" docker.local "${remote_command}"
