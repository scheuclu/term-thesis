#!/bin/bash
declare verbose=false

# Check that podofocountpages or pdftk is installed
command -v podofocountpages || command -v pdftk || { echo 'Neither podofocountpages nor pdftk is installed. Cannot count pages' ; exit 1; }

# Default page counter is podofo. If not installed, we use pdftk.
declare pdf_counter='podofo'
if [[ ! $(command -v podofocountpages) ]]; then
	$verbose && echo 'INFO: podofocountpages is not installed. Using pdftk instead.'
	pdf_counter='pdftk'
fi

# FUNCTION. Take the pdf file as first argument. Returns the number of pages.
function COUNT_pages() {
		local pdf_file="$1"
		if [[ $pdf_counter != 'pdftk' ]]; then
			podofocountpages -s $pdf_file
		else
			pdftk $pdf_file dump_data | grep NumberOfPages | awk '{print $2}'
		fi
}

# FUNCTION. Remove the buggy lines in the tex file.
# Take 3 mandatory arguments.
function REMOVE_wrong_lines() {
	local -i nbTexPages=$1
	local -i diffNbPages=$2
	local texName=$3
	for page in $(seq $((nbTexPages+1-diffNbPages)) $nbTexPages)
	do
		sed -i "/page=${page}/d" $texName
	done
}

# Loop over all the svg files in the current directory
for svg in $(ls *.svg)
do
	declare pdfName=${svg%.svg}.pdf
	declare texName=${svg%.svg}.pdf_tex
	declare -i nbPdfPages=$(COUNT_pages $pdfName)
	declare -i nbTexPages=$(grep page= $texName | wc -l)
	declare -i diffNbPages=$((nbTexPages - nbPdfPages))
	$verbose && echo $svg $diffNbPages
	if [[ $((nbTexPages - nbPdfPages)) -gt 0 ]]; then
		echo "Nonsense in $texName"
		REMOVE_wrong_lines $nbTexPages $diffNbPages $texName
	fi
done
