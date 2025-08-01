#!/bin/bash
local_config_dir="$(dirname "$(readlink -f "$0")")"
source "${local_config_dir}/docker.config"

# This will prompt the user to install symbolic links pointing at this project
# in their default bin directory (~/bin)

response='No'

function default_prompt_string () {
# Based on previous user response, show that as the default in square brackets.

	previous_response="${1^^}"

	for word in 'Yes' 'No' 'All'
	do
		if [[ "${previous_response:0:1}" == "${word:0:1}" ]]
		then
			echo -n "[${word}]"
		else
			echo -n "${word}"
		fi
		echo -n '/'
	done
	echo -n 'Cancel'
}

function ask_to_make_symlink () {
# Ask the user if they want to install a symlink

	default_response="${response}"

	while true
	do
		read -rp "Install link ($(default_prompt_string "${response}")):" response
		response="${response:-$default_response}"

		case "${response:0:1}" in
			y|Y )
				response='Yes'
				return 0
			;;
			a|A )
				response='All'
				return 0
			;;
			n|N )
				response='No'
				return 1
			;;
			c|C )
				exit 1
			;;
			* )
				response="${default_response}"
			;;
		esac
	done
}

function install_link () {
# Install a symlink in the user's configured bin directory

	sourceFile="$(readlink -f "$1")"
	targetFile="${local_bin_dir}/$(basename "$1")"

	if [[ "$(readlink -f "${sourceFile}")" == "$(readlink -f "${targetFile}")" ]]
	then
		# Nothing to do
		return 0
	fi

	if [[ -L "${targetFile}" && -e "${targetFile}" ]]
	then
		alert="Warning: symbolic link '${targetFile}' exists and is pointing to a file."
	elif [[ -L "${targetFile}" && ! -e "${targetFile}" ]]
	then
		alert="Warning: broken symbolic link '${targetFile}' exists."
	elif [[ -f "${targetFile}" ]]
	then
		alert="Warning: file '${targetFile}' exists."
	else
		alert=""
	fi

	if [ "${response}" != 'All' ] && [ -n "${alert}" ]
	then
		note "${alert}"
		note "This will replace '${targetFile}' with a symbolic link to '${sourceFile}'?"
		if ! ask_to_make_symlink
		then
			return 99
		fi
	fi

	ln -sf "${sourceFile}" "${targetFile}"
}

while read -r sourceFile <&3
do
	install_link "${sourceFile}"
done 3< <(
	find "${local_config_dir}" -maxdepth 1 \
		-type f \
		-executable \
		! -name '*.sh'
	)
