#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script is supposed to be invoked by the parent script setup.sh

# FUNCTION cleans the temporary and compilation files
function CLEAN_temp_files ()
{
	local initial_dir="$(pwd)"
	cd "$source_dir_path/latex/AM"

	# files starting with AM and not finishing with dtx, cls or bib are removed
	rm $(ls | grep ^AM | grep -v AMgit | grep -vE 'dtx|cls|bib$') 2> /dev/null
	rm _minted-* -rf 2> /dev/null

	# remove extracted cls and sty from sources (except AMdocumentation.cls)
	rm $(ls | grep .cls | grep -v AMdocumentation) 2> /dev/null
	rm $(ls | grep .sty | grep -v AMgit) 2> /dev/null

	# return to initial directory
	cd "$initial_dir"
}

# FUNCTION clean texstudio settings files for AM
function CLEAN_texstudio_settings()
{
	if ON_LINUX; then
		rm -f $HOME/.config/texstudio/AM*.cwl 2> /dev/null
	fi
}

# FUNCTION clean old installation
# This code is executed by the updater just before install
function CLEAN_old_installation()
{
	rm -rf "$HOME/.local/share/amlatex"
}


#-------------------------------------------------------------------------------
# BEGIN script
#-------------------------------------------------------------------------------

declare unknown_clean_arg=true
declare clean_all=false
if [[ $1 == 'all' ]]; then
	clean_all=true
fi

if $clean_all || [[ $1 == "temp_files" ]]; then
  CLEAN_temp_files
	OK_message "Cleaning temporary files... "
	unknown_clean_arg=false
fi

if $clean_all || [[ $1 == "texstudio" ]]; then
  CLEAN_texstudio_settings
	OK_message "Cleaning texstudio cwl files... "
	unknown_clean_arg=false
fi

if $clean_all || [[ $1 == "old_installation" ]]; then
	CLEAN_old_installation
	unknown_clean_arg=false
	OK_message "Cleaning old installation... "
fi

if $unknown_clean_arg; then
  ERROR_message "unknown argument $1"
  exit 42
fi
