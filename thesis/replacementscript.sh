
for file in $(find ./ -name '*.tex')
do
  cat replacements | while read line
  do
    echo "s/$line/g"
    sed "s/$line/g" < $file > tmp
    cp tmp $file
  done
done


#cat replacements | while read line
#do
  #echo $line
#done
