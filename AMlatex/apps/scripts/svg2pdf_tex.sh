#!/bin/bash
# Usage: svg2pdf_tex.sh *.svg
declare svg_list="$*"
declare verbose=true

# Check that inkscape is installed
command -v inkscape || { echo 'Cannot find inkscape. Aborting.'; exit 1; }
declare inkscape_version=$(inkscape --version | awk '{print $2}')

# Loop over all given files
for svg_file in $svg_list
do
	declare file_name=${svg_file%.svg}
	if [[ ${file_name}.svg == $svg_file ]]; then
		$verbose && echo "Convert $file_name.svg to $file_name.pdf_tex"
		inkscape -z -D -f $file_name.svg --export-pdf=$file_name.pdf --export-latex
	fi
done

# Fix nonsense caused by inkscape version 0.91
if [[ $inkscape_version == '0.91' ]]; then
	command -v fixInkscapeNonsense.sh || { echo 'Cannot find fixInkscapeNonsense.sh'; exit 0; }
	exec fixInkscapeNonsense.sh
fi
