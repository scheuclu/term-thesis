#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script is supposed to be invoked by the parent script setup.sh from cobra

# The directory texmf/ is deployed on a server
declare -r deploy_server='tumwlam-pcli02.amm.mw.tum.de'
declare -r deploy_username='cobra'
declare -r deploy_destination='/home/cobra/AMlatex'
declare -r deploy_ssh_options="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
rsync -avz -e "$deploy_ssh_options" --progress $texmf_dir_path ${deploy_username}@${deploy_server}:$deploy_destination

# The directories texmf/ and templates/ are copied locally on cobra
declare -r cobra_amlatex='/home/gitlab-runner/report/amlatex'
cp -vR $texmf_dir_path $cobra_amlatex
cp -vR $templates_dir_path $cobra_amlatex

exit $?
