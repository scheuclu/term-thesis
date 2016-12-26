#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#

# Standards messages
declare -rx ok_message="[\x1B[32m OK \x1B[0m]"
declare -rx done_message="[\x1B[32mDONE\x1B[0m]"
declare -rx fail_message="[\x1B[31mFAIL\x1B[0m]"

# Color codes
declare -irx code_red=31
declare -irx code_blue=34
declare -irx code_magenta=35
declare -irx code_normal=0

# Terminal geometry
declare -rx terminal_width=$(tput cols)

# FUNCTION
function CHECK_is_installed ()
{
	local verbose=true
	local program_names=$*
	local -i check_result=0
	local -i total_result=0
	local str_result=''
	for program_name in $program_names
	do
		command -v $program_name > /dev/null
		check_result=$?
		if [[ $check_result -eq 0 ]]; then
			str_result='ok.'
		else
			str_result='not found!'
		fi
		$verbose && echo "Checking for $program_name... $str_result"
		total_result=$((check_result+total_result))
	done
	return $total_result
}

function ENSURE_is_installed()
{
	local list="$*"
	local -i exit_code=0
	for soft in $list
	do
		if ! command -v $soft > /dev/null ; then
			ERROR_message "$soft must be installed."
			exit_code=1
		fi
	done
	return $exit_code
}

function SUGGEST_softwares()
{
	local list="$*"
	local not_installed=''
	local soft=''
	local make_suggestion=false
	for soft in $list
	do
		if ! command -v $soft > /dev/null ; then
			not_installed="$soft $not_installed"
			make_suggestion=true
		fi
	done
	if $make_suggestion; then
		USER_message '\nYou might want to install the following recommanded softwares:'
		echo $not_installed
	fi
}

# FUNCTION test if OS is GNU/Linux
function ON_LINUX()
{
	[[ $(uname -s) == 'Linux' ]]
}

# FUNCTION test if OS is Windows
function ON_WINDOWS()
{
	[[ $(uname -s) == *'W'* ]]
}

# FUNCTION to test if a user is administrator on windows
function IS_administrator()
{
	net session &> /dev/null
}

# FUNCTION to diplay message and abort script
function ABORT_script ()
{
	echo -e "$*"
	exit 42
}

function GET_git_current_branch()
{
  git rev-parse --abbrev-ref HEAD 2> /dev/null
}

function GET_git_current_version()
{
  git describe 2> /dev/null
}

function GET_git_current_date()
{
    # The function commented is not working on MacOS X;
    # date -d @$(git log -n1 --format="%at") '+%Y/%m/%d'
    # Thus the following command is recommended
    git show -s --format=%ci 2> /dev/null | cut -d' ' -f1 | sed 's/-/\//g'
}

# Test if a variable has been declared (its value can be an empty string)
# Usage: if IS_declared 'variable_name'; then ...
function IS_declared ()
{
	local var=$1
	test "$( set -o posix ; set | grep -e "^${var}=" )"
}

function IS_installed()
{
	local program_name=$1
	command -v $program_name > /dev/null
}

#===============================================================================
# Message functions
#===============================================================================

function USER_message()
{
	echo -e "$(TEXTCOLOR_blue "\x1B[1m$*\x1B[21m")"
}

# Write a log message
function INFO_message ()
{
	echo -e "$(TEXTCOLOR_cyan INFO:) $*"
}

# Write a ok message
function OK_message ()
{
	echo -e "$(TEXTCOLOR_green OK:) $*"
}

# Write a ok message
function FAIL_message ()
{
	echo -e "$(TEXTCOLOR_red FAIL:) $*" 1>&2
}

function OK_or_FAIL_message()
{
	local success=$1
	shift
	test $success -eq 0 && OK_message $* || FAIL_message $*
}

# Write an error log message (on stderr)
function ERROR_message ()
{
	echo -e "$(TEXTCOLOR_red "ERROR: $*")" 1>&2
}

# Write an warning log message (on stderr)
function WARNING_message ()
{
	echo -e "$(TEXTCOLOR_yellow WARNING:) $*" 1>&2
}


# Write an alert log message
function ALERT_message ()
{
	echo -e "$(TEXTCOLOR_red "$*")"
}

# Write a debug log message in stderr
function DEBUG_message ()
{
	if ! IS_declared 'DEBUG_NO_OUTPUT'; then
		echo -e "$(TEXTCOLOR_magenta "DEBUGGING INFO: $*")"
	fi
}

# Generic function to put text in color.
# Usage: TEXTCOLOR_code 31 "$text"
# Note: no coloring is applied if BASH_NO_COLOR is declared
function TEXTCOLOR_code ()
{
  local code=$1
  shift
  if IS_declared BASH_NO_COLOR; then
    echo "$*"
  else
    echo "\x1B[${code}m$*\x1B[0m"
  fi
}

# Convenient function for TEXTCOLOR_code 31 ...
function TEXTCOLOR_red ()
{
  echo "$(TEXTCOLOR_code 31 "$*")"
}

# Convenient function for TEXTCOLOR_code 32 ...
function TEXTCOLOR_green ()
{
  echo "$(TEXTCOLOR_code 32 "$*")"
}

# Convenient function for TEXTCOLOR_code 34 ...
function TEXTCOLOR_blue ()
{
  echo "$(TEXTCOLOR_code 34 "$*")"
}

# Convenient function for TEXTCOLOR_code 35 ...
function TEXTCOLOR_magenta ()
{
  echo "$(TEXTCOLOR_code 35 "$*")"
}

# Convenient function for TEXTCOLOR_code 36 ...
function TEXTCOLOR_cyan ()
{
  echo "$(TEXTCOLOR_code 36 "$*")"
}

# Convenient function for TEXTCOLOR_code 33 ...
function TEXTCOLOR_yellow ()
{
  echo "$(TEXTCOLOR_code 33 "$*")"
}

# Float number comparison
function COMPARE_float()
{
    awk -v n1=$1 -v n2=$2 'BEGIN{ if (n1<n2) exit 0; exit 1}'
		# bc <<< "$1>$2"
}

function APPEND_bashrc_path()
{
	local append_comment="$1"
	local append_path="$2"
	local bashrc_path="$HOME/.bashrc"
	INFO_message "Adding $append_path to PATH in bashrc ($append_comment)"
	echo -e "# $append_comment" >> $bashrc_path
	echo 'export PATH="$PATH:'$append_path'"' >> $bashrc_path
}

function REMOVE_bashrc_path()
{
	local remove_comment="$1"
	local bashrc_path="$HOME/.bashrc"
	local n=$(grep "$remove_comment" $bashrc_path -n | head -1 | cut -d: -f1)
	if [[ "$n" ]]; then
		sed -i -e "${n}d;$((n+1))d" $bashrc_path
	fi
}

#===============================================================================
# Export functions
#===============================================================================
export -f CHECK_is_installed
export -f ON_LINUX
export -f ON_WINDOWS
export -f IS_administrator
export -f ABORT_script
export -f GET_git_current_branch
export -f GET_git_current_version
export -f GET_git_current_date
export -f IS_declared
export -f IS_installed
export -f TEXTCOLOR_code
export -f TEXTCOLOR_blue
export -f TEXTCOLOR_cyan
export -f TEXTCOLOR_red
export -f TEXTCOLOR_magenta
export -f TEXTCOLOR_green
export -f TEXTCOLOR_yellow
export -f USER_message
export -f INFO_message
export -f DEBUG_message
export -f ERROR_message
export -f ALERT_message
export -f WARNING_message
export -f OK_message
export -f FAIL_message
export -f OK_or_FAIL_message
export -f COMPARE_float
export -f SUGGEST_softwares
export -f ENSURE_is_installed
export -f APPEND_bashrc_path
export -f REMOVE_bashrc_path
