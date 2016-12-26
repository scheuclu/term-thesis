#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script (setup.sh) is basically a wrapper that reads the arguments and
# launch the appropriate modules in apps/setup/
#
# Those modules are:
#   + clean.sh
#   + deploy.sh
#   + extract.sh
#   + install.sh
#   + release.sh
#   + test.sh
#   + utils.sh
#
# Installation script of the update application that checks if a new version of
# AMlatex is available and will install it (linux only)
#
#
# setup version:
declare -r setup_version='4.1'

# where is this file?
declare this_file_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )

#-------------------------------------------------------------------------------
# Definition of global path to the directories:
#-------------------------------------------------------------------------------

# Directories relative to the current AMlatex/ directory
declare -rx AMlatex_dir_path="$this_file_dir"
declare -rx setup_scripts_dir_path="${AMlatex_dir_path}/apps/setup"
declare -rx update_dir_path="${AMlatex_dir_path}/apps/updater"
declare -rx templates_dir_path="${AMlatex_dir_path}/templates"
declare -rx texmf_dir_path="${AMlatex_dir_path}/texmf"

# Directories relatative to the texmf tree
declare -rx source_dir_path="${texmf_dir_path}/source"
declare -rx tex_dir_path="${texmf_dir_path}/tex"
declare -rx latex_dir_path="${texmf_dir_path}/tex/latex"

# System amlatex directories
declare -rx autostart_path="$HOME/.config/autostart"
declare -rx amlatex_root_path="$HOME/.amlatex"
declare -rx data_dir_path="${amlatex_root_path}/data"
declare -rx controller_path="${amlatex_root_path}/controller"
declare -rx tmp_path="${amlatex_root_path}/tmp"


#-------------------------------------------------------------------------------
# Global variables
#-------------------------------------------------------------------------------

declare -x parallel_opts='-j 12'
declare -x parallel_cmd="parallel $parallel_opts"
declare -x interaction=true
if [[ "$USER" == 'gitlab-runner' ]]; then interaction=false; fi

# TeX and pdfLaTeX options
declare -rx pdflatex_opts='-synctex=1 -interaction=nonstopmode -shell-escape -halt-on-error'
declare -rx tex_opts='-interaction=nonstopmode -halt-on-error'

# Context messages
declare -rx doc_extraction_message="Documentation extraction begins (can take a while...)"
declare -rx sty_extraction_message="Package extraction begins"

# Requested of suggested softwares
declare -r required_softwares='git tex pdflatex biber'
declare suggested_softwares='texstudio parallel inkscape pdftk curl convert pygmentize wget'

# URLs
declare -rx url_report_issue="https://gitlab.lrz.de/AM/AMlatex/issues/"

# Script welcome message
declare -r welcome_message="\
================================================================\n\
                                                                \n\
      TUM-AM PACKAGE AND DOCUMENTATION EXTRACTION SCRIPT        \n\
                                                                \n\
                         Version $setup_version                 \n\
                                                                \n\
         Contact: R. Pennec - romain.pennec@tum.de              \n\
                                                                \n\
================================================================\n"

# Script usage example
declare -r AMsetup_usages="
Usages:                                                         \n\
    setup.sh --version                                          \n\
    setup.sh clean                                              \n\
    setup.sh install [status|texhash|texmflocal] [default]      \n\
    setup.sh extract [all|doc|sty] [package_name]               \n\
    setup.sh update                                             \n\
    setup.sh uninstall                                          \n\
    setup.sh release                                            \n"

declare -r visit_message="\
Please visit https://gitlab.lrz.de/AM/AMlatex"

declare -i setup_exit_status=0

# Load bash utilities
source "$setup_scripts_dir_path/utils.sh"

if ON_WINDOWS; then
  suggested_softwares='inkscape pdftk pygmentize'
fi

#===============================================================================
#                                SCRIPT START
#===============================================================================

# option extraction
declare mode='none'

case $1 in
	clean|extract|install|update|release|uninstall|test|deploy|patch)
		mode="$1";;
	'--version')
		echo "$setup_version"; exit 0;;
esac

# mode patch (specific mode for update patch)
if [[ $mode == 'patch' ]]; then
	exit 0
fi

# welcome message
USER_message $welcome_message

# creation of the amlatex directory (for data)
# TODO versbose
mkdir -p "$data_dir_path"
mkdir -p "$tmp_path"


#--------------
# mode none
#--------------
if [[ $mode == 'none' ]]; then
	echo -e $AMsetup_usages
	USER_message "No mode provided. Choice:"
	select mode in 'install' 'update' 'release' 'uninstall' 'extract' 'quit'; do
		case $mode in
		extract|install|update|release|uninstall) break;;
		'quit') exit 0;;
		*) echo "Unkwown mode $mode";;
		esac
	done
fi

#--------------
# mode clean
#--------------
if [[ $mode == 'clean' ]]; then
  "$setup_scripts_dir_path"/clean.sh 'all'
fi

#--------------
# mode update
#--------------
if [[ $mode == 'update' ]]; then
	USER_message 'Installing background updater...'
	"$setup_scripts_dir_path"/install.sh 'update_controller'

	USER_message 'Check for updates...'
	export AMLATEX_UPDATE_NOW='yes'
  export AMLATEX_UPDATE_GUI='false'
	$controller_path/update_controller.sh
  echo $! > $controller_path/update_controller.pid
fi

#--------------
# mode uninstall
#--------------
if [[ $mode == 'uninstall' ]]; then
  "$setup_scripts_dir_path"/uninstall.sh
fi

#--------------
# mode extract
#--------------
if [[ $mode == 'extract' ]]; then
	CHECK_is_installed $required_softwares $suggested_softwares
  ENSURE_is_installed $required_softwares || { USER_message "$visit_message" ; exit 42 ; }
  "$setup_scripts_dir_path"/install.sh 'check'
  shift
	"$setup_scripts_dir_path"/extract.sh $*
	setup_exit_status=$?
fi

#--------------
# mode release
#--------------
if [[ $mode == 'release' ]]; then
	"$setup_scripts_dir_path"/release.sh
fi

#--------------
# mode install
#--------------
if [[ $mode == 'install' ]]; then
  CHECK_is_installed $required_softwares $suggested_softwares
  if [[ "$2" == 'status' ]]; then
		INFO_message 'Status:'
    cat $data_dir_path/installation-history 2> /dev/null || echo 'not installed'
  else
    "$setup_scripts_dir_path"/clean.sh 'old_installation'
    ENSURE_is_installed $required_softwares || exit 42
    shift
    "$setup_scripts_dir_path"/install.sh 'amlatex_bin'
    "$setup_scripts_dir_path"/install.sh $*
    setup_exit_status=$?
    [[ $setup_exit_status -eq 0 ]] || exit 28
    echo ''
    USER_message 'Finial latex environment checking...'
    "$setup_scripts_dir_path"/install.sh 'check'
  fi
fi

#-------------
# mode test
#-------------
if [[ $mode == 'test' ]]; then
  "$setup_scripts_dir_path"/test.sh
  setup_exit_status=$?
fi

#--------------
# mode deploy
#--------------
if [[ $mode == 'deploy' ]]; then
	"$setup_scripts_dir_path"/deploy.sh
	setup_exit_status=$?
fi


SUGGEST_softwares $suggested_softwares

exit $setup_exit_status

# end of script
