#!/bin/bash
#
#------------------------------------------------------------------------------#
# Author: Romain Pennec                                                        #
# https://gitlab.lrz.de/AM/AMlatex                                             #
#------------------------------------------------------------------------------#
#
# This script is supposed to be invoked by the parent script setup.sh
#
# Extraction script of the style files (*.sty) from the tex documentation
# files (*.dtx). This is done by executing `tex $file.dtx`
# After extraction, the sty files are copied in texmf/tex/latex/AM
#
# Extraction script of the documentations (*.pdf) from the tex documentation
# files (*.dtx). This is done by executing `pdflatex $file.dtx`
# After extraction, the pdf files are copied in texmf/doc/latex/AM
#
# In order to parallelize the extraction of all the dtx files, this script can
# call itself as a subprocess to extract a single file.
# For that we need to know is this script is run as the parent or as child.
# This is what the variable is_extract_parent is for.
#
# Temporary information and command for parallel are stored in the files
#   extraction_fails and extraction_commands
#
# We have to check that the program GNU parallel is installed.

if [[ "$is_extract_parent" != 'true' ]]; then
  export is_extract_parent='true'
else
  is_extract_parent='false'
fi


#-------------------------------------------------------------------------------
# BEGIN function declarations
#
# CHECK_parallel
# SINGLE_EXTRACTION                                              <-- return bool
# COUNT_extraction_fails                                          <-- return int
# PRINT_start_extraction_message
# PRINT_found_dtx_files
# EDIT_AMgit
# EXTRACT_ext_FROM_dtx     <-- call EXTRACT_sty_FROM_dtx or EXTRACT_doc_FROM_dtx
# EXTRACT_sty_FROM_dtx                                       <-- exec tex on dtx
# EXTRACT_doc_FROM_dtx                                  <-- exec pdflatex on dtx
# GET_destination_OF_ext                                   <-- return doc or tex
# GET_dtx_file_name
# GET_generated_file_OF_ext
# EXTRACT_local_all                     <-- call EXTRACT_sty_FROM_dtx on all dtx
# RUN_extractions
# RUN_extraction
#-------------------------------------------------------------------------------

# FUNCTION
function CHECK_parallel()
{
  command -v parallel > /dev/null
  if [[ $? -ne 0 ]]; then
    ON_WINDOWS || WARNING_message 'cannot find parallel.'
    return 1
  fi
}

# FUNCTION
function SINGLE_EXTRACTION()
{
  [[ "$extract_file_name" ]]
}

# FUNCTION
# Possible extraction fails are written in $tmp_path/extraction_fails
function COUNT_extraction_fails()
{
  local file_fails="$tmp_path/extraction_fails"
  if [[ -s $file_fails ]]; then
    cat $file_fails | wc -l
  else
    echo 0
  fi
}

# FUNCTION
function PRINT_start_extraction_message()
{
  local ext=$1
  if [[ $ext == 'doc' ]]; then
    USER_message "$doc_extraction_message"
  elif [[ $ext == 'sty' ]]; then
    USER_message "$sty_extraction_message"
  fi
}

# FUNCTION display founded files
function PRINT_found_dtx_files()
{
  local file_list=''
  for dtx_file in $list_dtx_paths; do
    file_list="$file_list $(basename ${dtx_file%.dtx})"
  done
  INFO_message "Found $(echo $file_list | wc -w) tex documentation files"
  DEBUG_message "$file_list"
}

function EDIT_AMgit()
{
  local current_dir_path="$(pwd)"
  cd "$latex_dir_path/AM"
  if [[ -s 'AMgit.sty' ]]; then
    sed -i.backup "s/h{--branch--/h{$(GET_git_current_branch)/" AMgit.sty
    sed -i.backup "s/n{--version--/n{$(GET_git_current_version)/" AMgit.sty
    sed -i.backup "s#date{--date--#date{$(GET_git_current_date)#" AMgit.sty
    DEBUG_message 'File AMgit.sty edited.'
  else
    ERROR_message 'cannot find file AMgit.sty'
  fi
  cd "$current_dir_path"
}

# FUNCTION generic extraction function
function EXTRACT_ext_FROM_dtx()
{
  if [[ $ext == 'doc' ]]; then
    EXTRACT_doc_FROM_dtx "$*"
  elif [[ $ext == 'sty' ]]; then
    EXTRACT_sty_FROM_dtx "$*"
  fi
  return $?
}

# FUNCTION to extract sty from dtx
function EXTRACT_sty_FROM_dtx()
{
  local current_dir_path="$(pwd)"
  local dtx_name=$(basename $1)
  local sty_name=${dtx_name%.dtx}.sty
  local cls_name=${dtx_name%.dtx}.cls
  local -i extraction_result

  # Run tex on the dtx file to extract the .sty (or .cls)
  cd "$(dirname $1)"
  tex $tex_opts $dtx_name > /dev/null
  extraction_result=$?
  cd "$current_dir_path"

  return $extraction_result
}

# FUNCTION to extract doc from dtx
function EXTRACT_doc_FROM_dtx ()
{
  local base_name=${1%.dtx}
  local doc_name=$base_name.pdf
  local abort_message="Something went wrong. Check $base_name.log"

  # First pdflatex compilation
  pdflatex $pdflatex_opts $1 > /dev/null

  # if compilation failed, we stop everything
  if [[ $? -ne 0 ]]; then
    ALERT_message "$abort_message"
    return 1
  fi

  # generate index and glossary
  makeindex $base_name 2> /dev/null
  makeindex -s gglo.ist -o $base_name.gls $base_name.glo 2> /dev/null

  # generate bibliography
  biber $base_name > /dev/null

  # Second and third pdflatex compilation
  pdflatex $pdflatex_opts $1 > /dev/null
  pdflatex $pdflatex_opts $1 > /dev/null

  # check if the pdf has been created
  if ! [[ -s $doc_name ]]; then
    ALERT_message "$abort_message"
    return 1
  else
    return 0
  fi
}


# FUNCTION destination parent directory associated to ext
function GET_destination_OF_ext ()
{
  local ext=$1
  if [[ $ext == 'doc' ]]; then
    echo 'doc'
  elif [[ $ext == 'sty' ]]; then
    echo 'tex'
  fi
}

function GET_dtx_file_name()
{
  local dtx_file_path="$1"
  echo $(basename ${dtx_file_path%.dtx})
}

# FUNCTION generated file associated to ext
function GET_generated_file_OF_ext()
{
  local ext=$1
  if [[ $ext == 'doc' ]]; then
    echo 'pdf'
  elif [[ $ext == 'sty' ]]; then
    echo 'sty'
  fi
}

# FUNCTION extract locally the package files (AM*.sty)
function EXTRACT_local_all()
{
  DEBUG_message "Local extraction of all the packages"
  for dtx_file in $list_dtx_paths; do EXTRACT_sty_FROM_dtx $dtx_file & done
}

# FUNCTION main extraction over all files
#WARNING GNU parallel is used!
function RUN_extractions()
{
  local current_dir_path="$(pwd)"
  local dtx_file_path

  DEBUG_message 'Writing instructions file for GNU parallel...'
  > "$tmp_path/extraction_commands"

  # Loop over all the dtx files
  # Instructions are written in the file $tmp_path/extraction_commands
  for dtx_file_path in $list_dtx_paths;
  do
    local command="\"$setup_scripts_dir_path\"/extract.sh $ext $(GET_dtx_file_name $dtx_file_path)"
    echo $command >> "$tmp_path/extraction_commands"
  done

  # Execution of the instructions
  $parallel_cmd < "$tmp_path/extraction_commands"

  cd "$current_dir_path"
}

function RUN_extraction()
{
  local dtx_file="$1"
  local dest="$(GET_destination_OF_ext $ext)"

  # relativ and absolute path of the dtx directory, with respect to texmf/source
  local dtx_local_dir="$(dirname $dtx_file)"
  local dtx_dir_path="$source_dir_path/$dtx_local_dir"

  # relativ path of the destination, with respect to texmf/source
  local dest_local_dir="../$dest/$dtx_local_dir"
  local destination_dir_path="$source_dir_path/$dest_local_dir"

  # Files names
  local file_name=$(GET_dtx_file_name $dtx_file)
  local dtx_file_name=${file_name}.dtx
  local pdf_file_name=${file_name}.pdf
  local sty_file_name=${file_name}.sty
  local cls_file_name=${file_name}.cls

  # Go in the directory of the dtx file
  cd "$dtx_dir_path"

  # Execute pdflatex to extract doc file from dtx
  local msg="extraction from $dtx_file_name"
  EXTRACT_ext_FROM_dtx $dtx_file_name
  local extraction_result=$?

  if [[ $extraction_result -eq 0 ]]; then
    # we ensure that the destination directory exists
    mkdir -p "$destination_dir_path"

    # Copy or move extracted files
    if [[ $ext == 'doc' ]]; then
      ext_file_name=$pdf_file_name
      cp "$ext_file_name" "$destination_dir_path"
    elif [[ $ext == 'sty' ]]; then
      cp $( ls *.sty *.cls 2> /dev/null ) "$destination_dir_path"
    fi
    OK_message $msg

  else
    echo $file_name >> $tmp_path/extraction_fails
    FAIL_message $msg
  fi

  # Go back to parent directory `source`
  cd "$source_dir_path"
  return $extraction_result
}

#-------------------------------------------------------------------------------
# BEGIN script
#-------------------------------------------------------------------------------

# Go into directory texmf/source
cd "$source_dir_path"

#> Argument extraction
#  1. (optional) type of extraction: doc, all, sty, local
#  2. (optional) file name, without extension
#<
declare type="$1"
declare extract_file_name="$2"

# Find dtx files inside texmf/source/latex and its subdirectories
list_dtx_paths=$( find latex -name "*.dtx" )

#> Read extraction type
if [[ -n "$type" ]]; then
  if [[ "$type" == 'doc' ]]; then
    ext_list='doc'
  elif [[ "$type" == 'all' ]]; then
    ext_list='sty doc'
  elif [[ "$type" == 'sty' ]]; then
    ext_list='sty'
  elif [[ "$type" == 'local' ]]; then
    EXTRACT_local_all
    exit $?
  else
    ERROR_message "Unknown extract argument $type. Aborting."
    exit 42
  fi
else
  ext_list='sty'
fi
#< end: $type $ext_list are set.

if echo $ext_list | grep 'doc' > /dev/null; then
  ENSURE_is_installed 'pygmentize biber' || exit 45
fi

# Actions specific to the parent script.
if [[ $is_extract_parent == 'true' ]]; then
  rm $tmp_path/extraction_fails 2> /dev/null
  PRINT_found_dtx_files
fi

# Local extraction of the packages
# (only once)
if [[ $type != 'sty' ]] && [[ "$local_extraction_done" != 'true' ]]; then
  EXTRACT_local_all
  export local_extraction_done='true'
fi

# Extract all extension in ext_list
for ext in $ext_list;
do
  if SINGLE_EXTRACTION; then
    RUN_extraction "latex/AM/${extract_file_name}.dtx"
  else
    CHECK_parallel || { parallel_cmd='bash' ; }
    PRINT_start_extraction_message $ext
    RUN_extractions
    USER_message "Extraction finished"
    DEBUG_message "Number of extraction fails: $(COUNT_extraction_fails)"
  fi
done

# Write Git version and branch in AMgit.sty
if [[ $type != 'doc' ]] && [[ $is_extract_parent == 'true' ]]; then
  EDIT_AMgit
fi

exit $(COUNT_extraction_fails)
