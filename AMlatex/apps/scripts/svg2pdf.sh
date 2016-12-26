#!/bin/bash

for i in $*
do
	declare file_name=${i%.svg}
	if [[ ${file_name}.svg == $i ]]; then
		echo Convert $file_name.svg to $file_name.pdf
		inkscape -z -D -f $file_name.svg --export-pdf=$file_name.pdf
	fi
done

