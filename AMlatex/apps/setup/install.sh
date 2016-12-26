#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script is supposed to be invoked by the parent script setup.sh
#
# Installation script of the AM latex packages and classes. This is done either
# by copying the texmf tree in a standard place, followed by a texhash run, or
# by setting some environment variables, like TEXMFLOCAL
#
# Installation script of the update application that checks if a new version of
# AMlatex is available and will install it.
#
# This script takes optional arguments.
# The first argument corresponds to the installation mode. Possible values are:
#     - 'update_controller'
#     - 'check'
#     - 'texhash'
#     - 'texmflocal'
#     - 'setup'
#
declare install_mode=$1
#
# A second argument can be given for texhash mode
declare install_dir="$2"

#-------------------------------------------------------------------------------
# BEGIN function declarations
#-------------------------------------------------------------------------------

# FUNCTION copy texmf tree.
# ARG1 = source
# ARG2 = destination
# Behavior is different for Linux and Mac OS. File permissions are anoying
function COPY_texmf()
{
	local texmf_source="$1"
	local texmf_destination="$2"

	if ON_LINUX; then
		$user_sudo cp -R --no-preserve=mode,ownership --target-directory="$texmf_destination" "$texmf_source"/* 2> /dev/null
	else
		cp -R "$texmf_source"/* "$texmf_destination" #2> /dev/null
	fi
	return $?
}

# FUNCTION standard destinations list for texmf, depending on the OS
function GET_texmf_destination_list()
{
	if ON_LINUX; then
		echo "$HOME/texmf /usr/local/share/texmf"
	else
		echo "$HOME/Library/texmf"
	fi
}

# FUNCTION default destination for texmf
function GET_texmf_default_destination()
{
	if ON_LINUX; then
		echo "$HOME/texmf"
	else
		echo "$HOME/Library/texmf"
	fi
}

# FUNCTION update history file after installation
function UPDATE_installation_history()
{
	local current_dir_path="$(pwd)"
	local installed_version
	local installation_mode=$1
	local installation_location="$2"
	local installation_date="$(date +'%Y-%m-%d')"
	local history_file_name='installation-history'

  # Read the version being installed
	cd "$AMlatex_dir_path"
	if [[ -s 'version.txt' ]]; then
		installed_version=$(cat 'version.txt')
	else
		installed_version=$(git describe master)
	fi

  # Append history file
	cd "$data_dir_path"
	if ! [[ -s $history_file_name ]]; then
		echo "# date ; version ; mode ; location" > $history_file_name
	fi
	echo "$installation_date ; $installed_version ; $installation_mode ; $installation_location" >> $history_file_name
	echo "$installed_version;$installation_date" > 'version.txt'

	cd "$current_dir_path"
}

# FUNCTION
function CHECK_latex_environment()
{
	local -i check_code=0

	if ! IS_installed 'tex'; then
		ERROR_message 'Cannot find TeX!'
		USER_message "$visit_message"
		return 43
	fi

	local tex_pi='3.14'
	if ON_WINDOWS; then
		local miktex_version=$( tex --version | head -1 | cut -d' ' -f2 )
		local tex_pi=$(tex --version | head -1 | cut -d'(' -f2 | cut -d')' -f1)
		INFO_message "Found miktex $miktex_version"
		INFO_message "TeX version is $tex_pi"
	elif ON_LINUX; then
		local texlive_version=$( tex --version | head -1 )
		local tex_pi=$( echo $texlive_version | cut -d' ' -f2 )
		INFO_message "Found texlive $texlive_version"
		INFO_message "TeX version is $tex_pi"
	else
		#TODO MacTex?
		local mactex_version=
		INFO_message "Found mactex $mactex_version"
	fi

	if [[ $( echo $tex_pi | wc -c ) -lt 11 ]]; then
		WARNING_message 'Old latex version detected. You should update.'
		check_code=3
	fi

	if ! IS_installed 'biber'; then
		ERROR_message 'Program biber not installed'
		if ON_LINUX ; then
			USER_message 'Try to run "sudo apt-get install biber" to install it.'
			return 21
		fi
	else
		local biber_version=$( biber --version | cut -d' ' -f3 )
		INFO_message "Found biber $biber_version"
	fi

	return $check_code
}

function UPDATE_latex_environment()
{
	WARNING_message "This feature is experimental. Please report bugs at $url_report_issue"

	if ON_WINDOWS; then
		if IS_installed 'mpm'; then
			echo 'Check mpm is installed... ok'
			USER_message 'Running: mpm --admin --update-db'
			mpm --admin --update-db --verbose
			USER_message 'Running: mpm --admin --update'
			mpm --admin --update --verbose
			return 0
		else
			echo 'Check mpm is installed... not found'
			ERROR_message "Cannot update MiKTeX. How did you install latex?"
			return 8
		fi
	elif ON_LINUX; then
		USER_message 'Updating system'
		sudo apt-get update
		sudo apt-get install xzdec
		sudo apt-get upgrade
		USER_message 'Running tlmgr'
		sudo tlmgr update --all
	else
		echo '?'
	fi
}

# FUNCTION installation of the update controller
# Linux only!
function INSTALL_update_controller()
{
	# Script that goes in .config/autostart
	local autostart_desktop_script="\
[Desktop Entry]\n\
Type=Application\n\
Exec=$HOME/.amlatex/controller/update_controller.sh\n\
Hidden=false\n\
NoDisplay=false\n\
X-GNOME-Autostart-enabled=true\n\
Name=AMlatex update controller\n"

	# Controller is started at login
	INFO_message "Add AMlatexUpdater in autostart directory $autostart_path"
	mkdir -p "$autostart_path"
	echo -e $autostart_desktop_script > "$autostart_path/AMlatexUpdater.desktop"
	chmod +x "$autostart_path/AMlatexUpdater.desktop"

	# Controller checks update every day
	INFO_message "Add update scripts in $controller_path"
	mkdir -p $controller_path
	cp "$setup_scripts_dir_path/utils.sh" "$update_dir_path/update_controller.sh" "$update_dir_path/update.sh" "$controller_path"
	chmod +x "$controller_path"/*.sh
}

function INSTALL_amlatex_setup()
{
	mkdir -p $amlatex_root_path/apps/setup
	cp "$AMlatex_dir_path/setup.sh" $amlatex_root_path 2> /dev/null
	cp -R "$AMlatex_dir_path/apps/setup/"* $amlatex_root_path/apps/setup/ 2> /dev/null
	mkdir -p $amlatex_root_path/bin
	cp -R "$AMlatex_dir_path/apps/bin/"* $amlatex_root_path/bin/ 2> /dev/null
	chmod +x $amlatex_root_path/bin/*
	REMOVE_bashrc_path 'AMlatexBIN'
	APPEND_bashrc_path 'AMlatexBIN' "$amlatex_root_path/bin"
}

# register TEXMFLOCAL in file .profile
function INSTALL_texmflocal()
{
	install_location="$texmf_dir_path"
	#TODO make robust (file does not exist, variable already defined, interaction with bashrc)
	echo -e '\n# AMlatex $TEXMFLOCAL' >> $HOME/.profile
	echo 'export TEXMFLOCAL="'$(kpsewhich -var-value TEXMFLOCAL)':'$texmf_dir_path'"' >> $HOME/.profile
	OK_or_FAIL_message $? 'Export $TEXMFLOCAL (inside $HOME/.profile)'

	source $HOME/.profile
	ALERT_message 'you need to log-in again for this to take effect'
}

function INSTALL_texhash()
{
	# set variable install_dir and user_sudo
	local user_sudo
	if [[ "$install_dir" == 'default' ]]; then
		install_dir=$(GET_texmf_default_destination)
		user_sudo=''
	else
		#> requires user interaction
		install_dir_list="$(GET_texmf_destination_list)"
		USER_message 'Please select the installation directory:'
		select install_dir in $install_dir_list; do
			echo ''
			case $install_dir in
				"$HOME/texmf")
					break;;
				"$HOME/Library/texmf")
					break;;
				'/usr/local/share/texmf')
					#> try to obtain root rights
					USER_message 'root privilege are required:'
					user_sudo='sudo'
					sudo -k printf ''
					if [[ $? -ne 0 ]]; then
						exit 42
					fi
					#< continue only as sudo
					break;;
				*)
					ERROR_message 'unknown directory. aborting.'
					exit 21;;
			esac
		done
		#< end of user interaction for install_dir
	fi

	#"$setup_scripts_dir_path"/clean.sh 'temp_files'
	#cp "$source_dir_path/latex/AM/"*.cls "$latex_dir_path/AM"

	# installation in selected directory
	$user_sudo mkdir -p "$install_dir"
	OK_or_FAIL_message $? "ensure directory $install_dir exists"

	COPY_texmf "$texmf_dir_path" "$install_dir"
	OK_or_FAIL_message $? "texmf tree copied in $install_dir"

	# run texhash (linux only)
	if ON_LINUX; then
		USER_message "Run texhash..."
		if [[ $user_sudo ]]; then
			sudo texhash 2> /dev/null
		else
			texhash "$install_dir" > /dev/null
		fi
	fi

	declare install_location="$install_dir"
	OK_message 'Installation completed'
}

function INSTALL_miktex()
{
	INFO_message "$install_mode detected."
	install_location="$texmf_dir_path"
	install_location_win="$(echo $install_location | sed 's/^\///' | sed 's/\//\\/g' | sed 's/^./\0:/')"
	if IS_administrator; then
		declare miktex_user='--admin'
		INFO_message 'Using admin mode'
	else
		declare miktex_user=''
		ERROR_message 'Cannot gain admin rights. Are you an administrator?'
		DEBUG_message 'Aborting installation.'
		ERROR_message 'Please run setup.sh with an administrator account'
		exit 42
	fi
	INFO_message "Register directory $install_location"
	initexmf $miktex_user --register-root="$install_location_win" --verbose
	INFO_message 'Update MiKTeX file name database'
	initexmf $miktex_user --update-fndb --verbose
}

#-------------------------------------------------------------------------------
# BEGIN script
#-------------------------------------------------------------------------------

if [[ "$AMLATEX_AUTO_INSTALL" ]]; then
	DEBUG_message "Auto-installing version $AMLATEX_AUTO_INSTALL"
	install_mode='texhash'
	install_dir='default'
fi

if [[ "$install_mode" == 'update_controller' ]]; then
  INSTALL_update_controller
elif [[ "$install_mode" == 'amlatex_bin' ]]; then
	INSTALL_amlatex_setup
elif [[ "$install_mode" == 'check' ]]; then
  CHECK_latex_environment

	if [[ $? -gt 1 ]] && [[ $interaction ]]; then
		read -p 'Should I try to update your latex distribution? [y/n] ' answer
		if [[ "$answer" != 'n' ]]; then
			UPDATE_latex_environment
		fi
	fi

else
  USER_message "\nINSTALLATION"

  # set variable install_mode
	if ON_WINDOWS; then
		install_mode='miktex'
		INFO_message "Windows (Git Bash) detected."
	else
		# requires user interaction if mode is not given
		if [[ $install_mode != 'texhash' ]] && [[ $install_mode != 'texmflocal' ]]; then
			install_mode_list=( 'copy this texmf tree in a standard location an run texhash [recommanded]' 'make reference to this texmf tree using $TEXMFLOCAL' )
			USER_message 'Please select installation mode:'
			select install_mode_text in "${install_mode_list[@]}"; do
				case "$REPLY" in
					1) install_mode='texhash';;
					2) install_mode='texmflocal';;
					3) ERROR_message 'Aborting installation'; exit 0;;
					*) continue;;
				esac
				break
			done
		fi
		# end of user interaction for install_mode
	fi

	# installatation starts...
	#
	if [[ $install_mode == 'texhash' ]]; then
		INSTALL_texhash
	elif [[ $install_mode = 'texmflocal' ]]; then
		INSTALL_texmflocal
	elif [[ $install_mode = 'miktex' ]]; then
		INSTALL_miktex
	fi
	#
	# installatation finished.

	# Update history file to keep track of the installed version
	INFO_message 'Update installation history file'
	UPDATE_installation_history $install_mode "$install_location"

	# installation of the update program
	if ON_LINUX; then
		if [[ $install_mode != 'texmflocal' ]]; then
			INFO_message 'Install background updater'
			INSTALL_update_controller
		fi
	else
		WARNING_message 'Update program only available on linux. You will have to update AMlatex manually.'
	fi

	USER_message "INSTALLATION FINISHED"

	# cleaning texstudio settings
	"$setup_scripts_dir_path"/clean.sh 'texstudio'
fi

exit 0
