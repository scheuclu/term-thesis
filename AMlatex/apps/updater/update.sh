#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# The file will be copied inside $HOME/.amlatex/controller;
# the file AMlatex-version.txt is supposed to be found in ~/.amlatex/data,
# it is formatted like this: <version>;<date>
#
# this script is called by the parent script update_controller.sh, where
#   AMlatex_installed_version
#   AMlatex_installation_date
# are exported.
#
declare this_file_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )
declare AMlatex_version_file='AMlatex-version.txt'
declare AMlatex_zip_name='AMlatex-latest.zip'
declare AMlatex_zip_release_url="https://syncandshare.lrz.de/dl/fiKj91Y15LH18chW7mYSTT26/$AMlatex_zip_name"
declare downloader=''
declare update_mode=''

#-------------------------------------------------------------------------------
# Pre-checking
#-------------------------------------------------------------------------------

# Check ~/.amlatex/data/AMlatex-version.txt exist
cd $amlatex_data_path
echo "Checking version file..."
if ! [[ -s $AMlatex_version_file ]]; then
	echo "Missing $AMlatex_version_file! Update aborted."
	exit 67
fi
echo "Found $AMlatex_version_file"

# Check that curl or wget is installed
echo "Looking for a download program... "
if command -v curl > /dev/null ; then
	downloader='curl'
elif command -v wget > /dev/null ; then
	downloader='wget'
else
	echo "Neither curl or wget is installed. Update aborted."
	exit 68
fi
echo "Found $downloader."

# Check unzip is installed
echo "Looking for unzip..."
if ! command -v unzip > /dev/null ; then
	echo "Cannot find unzip! Update aborted"
	exit 69
fi
echo "Found $(which unzip)"

# Check zenity is installed (GUI mode only)
if [[ "$AMLATEX_UPDATE_GUI" != 'false' ]]; then
	echo "Looking for zenity..."
	if ! command -v zenity > /dev/null ; then
		echo "Zenity is not installed! Update aborted."
		exit 70
	fi
	echo "Found $(which zenity)"
	update_mode='zenity'
else
	update_mode='console'
fi

#-------------------------------------------------------------------------------
# FUNCTION declaration
#-------------------------------------------------------------------------------

function EXTRACT_version()
{
	echo "$1" | cut -d';' -f1
}

function EXTRACT_date()
{
	echo "$1" | cut -d';' -f2
}

function DOWNLOAD_new_release()
{
	if [[ $downloader == 'curl' ]]; then
		curl -f -L "$AMlatex_zip_release_url" -o $AMlatex_zip_name
	elif [[ $downloader == 'wget' ]] ; then
		wget "$AMlatex_zip_release_url"
	fi
	if ! [[ -s $AMlatex_zip_name ]]; then
		echo "Download of $AMlatex_zip_release_url failed!"
		return 12
	fi
}

function INSTALL_new_release()
{
	export AMLATEX_AUTO_INSTALL="new_version"

	echo "# Extraction of the archive..."
	unzip -q $AMlatex_zip_name
	[[ $update_mode == 'zenity' ]] && echo "50" && sleep 1

	echo "# Run setup.sh..."
	AMlatex/setup.sh 'patch'
	AMlatex/setup.sh 'install'
	[[ $update_mode == 'zenity' ]] && echo "90" && sleep 1

	echo "# Remove temporary files..."
	#rm -rf AMlatex/ > /dev/null
	#$rm -rf $AMlatex_zip_name > /dev/null
	[[ $update_mode == 'zenity' ]] && echo "95" && sleep 1
}

function USER_confirms_update()
{
	local response
	local info_text="A new version of AMlatex is available \n\
		 current: $AMlatex_installed_version (installed on $AMlatex_installation_date)\n\
		 new: $new_version (released on $new_version_date)"
	local question_text="Do you want to install it?"

	if [[ $update_mode == 'zenity' ]]; then
		zenity --question --text="$info_text\n\n$question_text" --title="AMlatex Update"
	else
		echo -e "$info_text"
		read -r -p "$question_text [y/N] " response
		case $response in
    [yY][eE][sS]|[yY])
        return 0
        ;;
    *)
        echo 'Update aborted!' && return 1
        ;;
		esac
	fi
}

#-------------------------------------------------------------------------------
# SCRIPT
#-------------------------------------------------------------------------------

declare new_version=$(EXTRACT_version $(cat $AMlatex_version_file))
declare new_version_date=$(EXTRACT_date $(cat $AMlatex_version_file))

USER_confirms_update || exit 0

cd "$HOME/.amlatex"
echo "Cleaning $(pwd)/tmp..."
rm -rf tmp/ 2> /dev/null
rm -rf /tmp/AMlatex* 2> /dev/null
rm -rf /tmp/amlatex* 2> /dev/null

#-------------------------------------------------------------------------------
if [[ $update_mode == 'zenity' ]]; then
#-------------------------------------------------------------------------------

	(
		echo "25" ; sleep 1
		cd /tmp
		DOWNLOAD_new_release && INSTALL_new_release
		if [[ $? -eq 0 ]]; then
			echo "# Finished"
			echo "100"
		else
			echo "# Download or installation failed!"
			exit 23
		fi
	) |
	zenity --progress \
	  --title="AMlatex update" \
	  --text="Downloading last release..." \
	  --percentage=0

	if [ "$?" = -1 ] ; then
		zenity --error --text="Update canceled."
	fi

#-------------------------------------------------------------------------------
elif [[ $update_mode == 'console' ]]; then
#-------------------------------------------------------------------------------

	mkdir -p tmp && cd tmp || exit 89
	DOWNLOAD_new_release && INSTALL_new_release

fi


exit 0
