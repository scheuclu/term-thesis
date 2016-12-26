#!/bin/bash

for i in $*
do
	declare file_name=${i%.eps}
	if [[ ${file_name}.eps == $i ]]; then
		echo Convert $file_name.eps to $file_name.svg
		epstopdf $file_name.eps --outfile=eps2svgtmp.pdf
		pdf2svg eps2svgtmp.pdf $file_name.svg
		rm eps2svgtmp.pdf
	fi
done

