#!/bin/bash
local_config_dir="$(dirname "$(readlink -f "$0")")"
source "${local_config_dir}/docker.config"

# This will uninstall this project from the user default bin directory.

function remove_link () {
# Remove a symlink (or file if it's the same as the source)

	sourceFile="$(readlink -f "$1")"
	targetFile="${local_bin_dir}/$(basename "$1")"

	if [ "${targetFile}" == "${sourceFile}" ]
	then
		note "Warning: '${targetFile}' and '${sourceFile}' are the same file, '${targetFile}' was not removed."
		return 1
	fi

	if diff -q "${sourceFile}" "${targetFile}"
	then
		rm "${targetFile}"
		return 0
	fi
	note "Warning: '${targetFile}' and '${sourceFile}' differ, '${targetFile}' was not removed."
}

while read -r sourceFile <&3
do
	remove_link "${sourceFile}"
done 3< <(
	find "${local_config_dir}" \
		-maxdepth 1 \
		-type f \
		-executable \
		! -name '*.sh'
	)
