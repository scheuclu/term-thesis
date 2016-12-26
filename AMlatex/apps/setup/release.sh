#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script is supposed to be invoked by the parent script setup.sh
#
cd "$AMlatex_dir_path"

if [[ "$(GET_git_current_branch)" != 'master'  ]]; then
	ERROR_message 'A release can only be created from branch master'
	exit 32
fi

declare release_version=$(git describe master)
declare release_version_h=$(git describe master | cut -d'-' -f1)
declare release_name="AMlatex-$release_version"
declare release_date="$(date +'%Y-%m-%d')"
declare release_date_us="$(date +'%Y/%d/%m')"
declare release_date_eu="$(date +'%Y/%m/%d')"
declare release_author="romain.pennec@tum.de"

# Create archive file AMlatex.tar from git repository
git archive master --prefix='AMlatex/' > AMlatex.tar
OK_or_FAIL_message $? 'export git project as archive'

# Extract AMlatex.tar to AMlatex/
tar -mxf AMlatex.tar
rm AMlatex.tar
OK_or_FAIL_message $? 'unpack archive to modify it'

# Create version file in AMlatex/
echo $release_version > AMlatex/version.txt
OK_or_FAIL_message $? 'create file version.txt that goes in the archive'

USER_message 'Write release version and date in:'
declare dtx_files=$(find AMlatex/texmf/source/latex -name '*.dtx')
declare dtx_file
for dtx_file in $dtx_files
do
	sed -i "s/<!AMreleaseVersion!>/$release_version_h/g" $dtx_file \
	&& sed -i '/\\RequirePackage{AMgit}/d' $dtx_file \
	&& sed -i 's#\\AMinsertGitDate{}#'$release_date_eu'#g' $dtx_file \
	&& sed -i 's#\\AMinsertGitVersion{}#'$release_version_h'#g' $dtx_file \
	&& sed -i 's#\\AMinsertGitBranch{}#stable#g' $dtx_file
	OK_or_FAIL_message $? '  ' $dtx_file
done

USER_message 'Edit AMdocumentation.cls'
declare doc_cls='AMlatex/texmf/source/latex/AM/AMdocumentation.cls'
sed -i 's#\\AMinsertGitVersion#'$release_version_h'#g' $doc_cls
sed -i 's#\\AMinsertGitDate#'$release_date_eu'#g' $doc_cls
sed -i 's#\\gitBranch#master#g' $doc_cls
sed -i 's#\\gitFirstTagDescribe#'$release_version_h' stable#g' $doc_cls
sed -i 's#\\gitAuthorEmail#'$release_author'#g' $doc_cls

chmod 664 AMlatex/texmf/source/latex/AM/*

USER_message 'Extract packages and documentations'
AMlatex/setup.sh extract all
AMlatex/setup.sh clean

chmod 664 AMlatex/texmf/tex/latex/AM/*
chmod 664 AMlatex/texmf/doc/latex/AM/*

# Compress AMlatex in a zip archive
zip -r ${release_name}.zip AMlatex > /dev/null
OK_or_FAIL_message $? 'create zip archive'
rm -rf AMlatex

# Version file
echo "$release_version_h;$release_date" > AMlatex-version.txt
ALERT_message "${release_name}.zip created. Copy it on syncandshare.lrz.de"
ALERT_message "AMlatex-version.txt created. Move it on syncandshare.lrz.de"
