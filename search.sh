#!/bin/bash

if [ -z "$2" ]; then
  search_path="."
else
  search_path="$2"
fi

searched=$(grep -Hrin "$1" "$search_path" -C1 | sed -E 's/(-)([[:digit:]]+)(-)/:\2:/g')

search_array=()

while read line; do
  if [ "$line" = "--" ]; then continue; fi
  file_name="$(echo $line | awk -F ":" '{print $1}'):$(echo $line | awk -F ":" '{print $2}')"
  file_content="$(echo $line | awk -F ":" '{$1=$2=""; print $0}')"
  search_array+=("$file_name" "$file_content")
done <<EOF
$searched
EOF

ret_vim=$(whiptail --menu "Select" "" "" "" "${search_array[@]}" 3>&1 1>&2 2>&3)
if [ "$ret_vim" = "" ]; then exit; fi
ret_vim_file=$(echo $ret_vim | awk -F ":" '{print $1}')
ret_vim_line=$(echo $ret_vim | awk -F ":" '{print $2}')

vim +$ret_vim_line $ret_vim_file

