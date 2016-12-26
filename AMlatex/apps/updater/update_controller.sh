#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script will be installed inside $HOME/.amlatex/controller
#
# This script is supposed to be launched at startup. Once a day it will download
# a file that contains the last AMlatex release, which will be compared with the
# current installed version. If a new version is available the script
#     update.sh
# is started.
#
declare -x AMlatex_installed_version='v0.0'
declare -x AMlatex_installation_date=''
declare -x amlatex_controller_path="$HOME/.amlatex/controller"
declare -x amlatex_data_path="$HOME/.amlatex/data"
declare version_file_path="$amlatex_data_path/version.txt"
declare sleep_time='24h'
declare AM_last_release_url="https://syncandshare.lrz.de/dl/fi5hCQDxRwfCkGJuFsSvUvJ1/AMlatex-version.txt"

declare this_file_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )
source "$this_file_dir/utils.sh"

function GET_installed_version()
{
	if [[ -s $version_file_path ]]; then
		local version_info="$(cat $version_file_path)"
		AMlatex_installed_version="$(EXTRACT_version $version_info)"
		AMlatex_installation_date="$(EXTRACT_date $version_info)"
	fi
}

function EXTRACT_version()
{
	echo "$1" | cut -d';' -f1
}

function EXTRACT_date()
{
	echo "$1" | cut -d';' -f2
}

function EXTRACT_version_number()
{
	echo "$1" | tail -c +2 | cut -d '-' -f1
}

function IS_newer_THAN()
{
	local arg1="$1"
	local arg2="$2"
	local v1="$(EXTRACT_version_number $arg1)"
	local v2="$(EXTRACT_version_number $arg2)"
	local newer=$(echo "$v1>$v2" | bc)
	[[ $newer -eq 1 ]]
}

# FUNCTION check if a new version is available.
# /!\ internet connection is required
function NEW_version_available()
{
	local current_dir_path=$(pwd)
	local answer='no'

	cd $amlatex_data_path

	# Download version
	echo "Download file $AM_last_release_url"
	rm AMlatex-version.txt 2> /dev/null
	wget $AM_last_release_url 2> /dev/null

	# If download succeed
	if [[ -s AMlatex-version.txt ]]; then
		last_version=$(EXTRACT_version $(cat AMlatex-version.txt))
		echo 'Last release version is' $last_version
		GET_installed_version
		echo 'Installed version is' $AMlatex_installed_version

		if IS_newer_THAN "$last_version" "$AMlatex_installed_version"; then
			answer='yes'
		fi
	else
		ERROR_message 'Download failed.'
	fi

	cd $current_dir_path
	[[ $answer == 'yes' ]]
}

#===============================================================================
# Script starts
#===============================================================================

if [[ $AMLATEX_UPDATE_NOW != 'yes' ]]; then
	sleep 30m
fi

while true
do
	if NEW_version_available; then
		INFO_message 'New version available'
		"$amlatex_controller_path"/update.sh
	else
		INFO_message 'Already up-to-date.'
		DEBUG_message "Next check in: $sleep_time"
	fi
	if [[ $AMLATEX_UPDATE_NOW != 'yes' ]]; then
		sleep $sleep_time
	else
		exit 0
	fi

done

exit 0
