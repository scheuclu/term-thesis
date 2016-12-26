#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script is supposed to be invoked by the parent script setup.sh
#
# It will uninstall amlatex and all its components


function REMOVE_am()
{
	local dirp="$1"
	local amdir="$dirp/AM"
	if [[ -d "$amdir" ]]; then
	  INFO_message "Remove dir $amdir"
	  rm -rf "$amdir"
	elif [[ -d "$dirp" ]]; then
	  INFO_message "Remove dir $dirp"
		rm -rf "$dirp"
	else
		WARNING_message "Cannot remove $dirp: no such directory"
		return 1
	fi
	rmdir --ignore-fail-on-non-empty -p "$dirp" 2> /dev/null
}

function GET_history_mode()
{
	local infos="$*"
	local mode
	mode=$(echo "$infos" | cut -d';' -f3)
	mode=${mode:1:-1}
	echo "$mode"
}

function GET_history_location()
{
	local infos="$*"
	local location
	location=$(echo "$infos" | cut -d';' -f4)
	location=${location:1}
	echo "$location"
}

function REMOVE_texhash_installation()
{
	local location="$1"
	INFO_message "Cleaning directory $location"
	REMOVE_am "$location/source/latex"
	rm -f "$location/source/generic.dtx"
	REMOVE_am "$location/doc/latex"
	REMOVE_am "$location/tex/latex"
}

function REMOVE_texmflocal_installation()
{
	INFO_message 'Cleaning .profile'
	local n=$(grep '# AMlatex' $HOME/.profile -n | head -1 | cut -d: -f1)
	if [[ "$n" ]]; then
		sed -i -e "${n}d;$((n+1))d" $HOME/.profile
	fi
}

function REMOVE_miktex_installation()
{
	local location="$1"
	initexmf --verbose --unregister-root="$location"
	initexmf --admin --verbose --unregister-root="$location"
}

function UNINSTALL_history()
{
	local history_file="$1"
	while read -r fileline
 	do
 		history_info_line="$fileline"
		history_mode="$(GET_history_mode $history_info_line)"
		history_location="$(GET_history_location $history_info_line)"

		if [[ "$history_mode == mode" ]]; then
			INFO_message "Found history file $history_file_path"
		elif [[ "$history_mode" == 'texhash' ]]; then
			INFO_message "Found installation $history_info_line"
			REMOVE_texhash_installation "$(GET_history_location $history_info_line)"
		elif [[ "$history_mode" == 'texmflocal' ]]; then
			INFO_message "Found installation $history_info_line"
			REMOVE_texmflocal_installation
		elif [[ "$history_mode" == 'miktex' ]]; then
			INFO_message "Miktex installation detected"
			REMOVE_miktex_installation "$(GET_history_location $history_info_line)"
		else
			ERROR_message "unknown mode $history_mode"
		fi
 	done < $history_file
}

#-------------------------------------------------------------------------------
# SCRIPT BEGIN
#-------------------------------------------------------------------------------

declare history_info_line
declare history_mode
declare history_file_path="$data_dir_path/installation-history"
declare old_data_dir_path="$HOME/.local/share/amlatex"
declare old_history_file_path="$old_data_dir_path/installation-history"
declare history_found=false

# Create and go in tmp directory
mkdir -p "$tmp_path"
cd "$tmp_path"

if [[ -s "$history_file_path" ]]; then
 	cat "$history_file_path" | uniq > uhistory.txt
	UNINSTALL_history 'uhistory.txt'
	rm "$history_file_path"
	history_found=true
fi

if [[ -s "$old_history_file_path" ]]; then
 	cat "$old_history_file_path" | uniq > uhistory.txt
	UNINSTALL_history 'uhistory.txt'
	rm "$old_history_file_path"
	history_found=true
fi


if ! $history_found ; then
	WARNING_message "No installation history data found."
fi

# Remove all amlatex directories
INFO_message "Cleaning $autostart_path"
rm -rf "$autostart_path/"*latex* > /dev/null
rm -rf "$autostart_path/AMlatexUpdater.desktop" > /dev/null

"$setup_scripts_dir_path"/clean.sh 'texstudio'
REMOVE_am "$controller_path"
REMOVE_am "$data_dir_path"
REMOVE_am "$old_data_dir_path"

rm -rf $amlatex_root_path > /dev/null
OK_message "Removed $amlatex_root_path"

REMOVE_bashrc_path 'AMlatexBIN'
REMOVE_texmflocal_installation

USER_message "UNINSTALL FINISHED"

exit 0
