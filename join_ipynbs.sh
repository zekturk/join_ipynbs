#!/bin/bash
 
# Creates a new ipynb file joining all the .pynb files
# in a given folder
# Author: Zekeriya SENTURK
# github.com/zekturk

# 1 argument
# The folder adress that includes targeted .ipynb files
# Usage: ./ipynb_combainer.sh /my/project/folder


declare structure_1
declare my_line
declare my_line_with_comma
declare structure_2
declare my_comma=","
declare -a MY_ARRAY
declare -i num

declare project_folder="${1}"
declare created_file=""${project_folder}"/all.ipynb"

[[ $1 ]] || { echo "Missing argument : Folder_Adress" >&2; exit 1; }

if [[ -e "${created_file}" ]]; then { echo "There is already an all.ipynb file! Rename or delete exsisting one" >&2; exit 1; }; fi

printf -v structure_1 "{\n \"cells\": ["
printf -v my_line "  {\n   \"cell_type\": \"markdown\",\n   \"metadata\": {\n    \"collapsed\": true\n   },\n   \"source\": [\n    \"---\"\n   ]\n  }"
printf -v my_line_with_comma "  {\n   \"cell_type\": \"markdown\",\n   \"metadata\": {\n    \"collapsed\": true\n   },\n   \"source\": [\n    \"---\"\n   ]\n  },"

MY_ARRAY=("$(ls "${project_folder}" | grep .ipynb)")
[[ ${MY_ARRAY} ]] || { echo "There is no ipynb file!" >&2; exit 1; }

touch "${created_file}"

printf "${structure_1}" > "${created_file}"

num=0

for file in ${MY_ARRAY}; do
    if [[ num -eq 0 ]]; then
        my_folder=""${project_folder}"/"${file}""
        structure_2=$(cat "$my_folder");
        structure_2=${structure_2##*]};
        ((++num))
    fi
    new_var=$(cat "$my_folder") 
    new_var=${new_var#*[}
    new_var=${new_var%]*}
    echo -n "${new_var}" >> "${created_file}"
    echo ${my_comma} >> "${created_file}"
    echo "${my_line_with_comma}" >> "${created_file}"
done

echo "${my_line}" >> "${created_file}"
printf "]" >> "${created_file}"
echo "${structure_2}" >> "${created_file}"
