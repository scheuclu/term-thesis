#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script is supposed to be invoked by the parent script setup.sh
#
declare test_log_file='/dev/null'
declare -i setup_test_score=0
declare ci_runner_hostname='tumwlam-pcli22'

function COMPILE_template ()
{
	local template_name="$1"
	local -i test_result=0
	cd "$templates_dir_path"
	cd "$template_name"

	# pdflatex
  pdflatex $pdflatex_opts "${template_name}.tex" > $test_log_file
	test_result=$?

	# biber
	if [[ $2 == 'biblio' ]]; then
		local -i biblio_result=0
		local -i relatex_result=0
		biber $template_name > $test_log_file
		biblio_result=$?
		test_result=$((biblio_result + test_result))
		pdflatex $pdflatex_opts "${template_name}.tex" > $test_log_file
		relatex_result=$?
		test_result=$((relatex_result + test_result))
	fi

	# test result
	OK_or_FAIL_message $test_result "compilation of template $template_name"
	return $test_result
}

function COMPILE_dissertation()
{
	local -i test_result=0
	local template_name='Dissertation'
	cd "$templates_dir_path"
	cd "$template_name/texfiles"

	# pdflatex
	pdflatex $pdflatex_opts "Thesis.tex" > $test_log_file
	test_result=$?

	# test result
	OK_or_FAIL_message $test_result "compilation of template $template_name"
	return $test_result
}

#-------------------------------------------------------------------------------
# BEGIN script
#-------------------------------------------------------------------------------

#--------------
# Pre-Processing
#--------------
if [[ $(hostname) == $ci_runner_hostname ]]; then
	"$setup_scripts_dir_path"/extract.sh sty
	"$setup_scripts_dir_path"/clean.sh 'temp_files'
fi

#--------------
# Latex environment
#--------------
cd "$AMlatex_dir_path"
export TEXMFLOCAL="$(pwd)/texmf:$TEXMFLOCAL"
echo $TEXMFLOCAL

# texhash is needed by cobra and I do not know why!!
if [[ $(hostname) == $ci_runner_hostname ]]; then
	texhash
fi

#--------------
# Compile templates
#--------------
cd "$templates_dir_path"

COMPILE_template 'thesis' biblio
setup_test_score=$(($? + setup_test_score))

COMPILE_template 'poster'
setup_test_score=$(($? + setup_test_score))

COMPILE_template 'scenario'
setup_test_score=$(($? + setup_test_score))

COMPILE_template 'abstract' biblio
setup_test_score=$(($? + setup_test_score))

COMPILE_template 'letter'
setup_test_score=$(($? + setup_test_score))

COMPILE_dissertation
setup_test_score=$(($? + setup_test_score))

INFO_message "Number of compilation fail: $setup_test_score"

exit $setup_test_score
