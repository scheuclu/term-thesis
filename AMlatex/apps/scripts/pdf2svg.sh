#!/bin/bash

for i in $*
do
	declare file_name=${i%.pdf}
	if [[ ${file_name}.pdf == $i ]]; then
		echo Convert $file_name.pdf to $file_name.svg
		pdf2svg $file_name.pdf $file_name.svg
	fi
done

