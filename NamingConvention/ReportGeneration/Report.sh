#! /bin/bash

if [[ "$1" == "" ]]; then
	printf "\nERROR: Please input a test type as an argument. E.g. \"view\".\n\n"
	exit
fi

. reportConfig.config

#Report Details
details_import="$1""_details"
eval details_import=\$$details_import
declare temp_import=$details_import
IFS=',' read -r -a details_array <<< "$temp_import"
REPORT_TYPE="${details_array[0]}"
FILE_EXTENSION="${details_array[1]}"
FILE_TEST="${details_array[2]}"

#Import Locations - Currently unused
details_import="$1""_locations"
eval details_import=\$$details_import
declare temp_import=$details_import
IFS=',' read -r -a CORRECTLOCATION <<< "$temp_import"

#Import Depths
details_import="$1""_depths"
eval details_import=\$$details_import
declare temp_import=$details_import
IFS=',' read -r -a CORRECTDEPTH <<< "$temp_import"

#Import Type - Currently unused
details_import="$1""_type"
eval details_import=\$$details_import
declare test_type=$details_import


#Import data and name test directory locations
NAME_TESTS="$namingTestsDirectory"
DATA="$dataDirectory"
DIRECTORY="$2"
if [[ "$DIRECTORY" != "" ]] && [[ ! "$DIRECTORY" =~ /$ ]]; then
        DIRECTORY="${DIRECTORY}""/"
fi

#Arrays
FILE_ARRAY=()
DIRECTORY_ARRAY=()

#Styling
INDENT="%-8s"
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
erc=$'\e[1;32m'
end=$'\e[0m'


shopt -s globstar
for file in "$DATA""$DIRECTORY"**
do
	is_file=0
	if [[ "$file" =~ "$FILE_EXTENSION"+$ ]]; then
		temp_file="${file#"$DATA"}"
		FILE_ARRAY+=( "$temp_file" )
		is_file=1
	fi
	#if [[ -d "${file}" ]] && [[ "$is_file" == 0 ]]; then
	#	temp_directory="${file#"$DATA"}"
        #        DIRECTORY_ARRAY+=( "$temp_directory" )
        #fi
done
shopt -u nullglob

error_count=0
output=""
error_output=""
previous_path=""
for file in "${FILE_ARRAY[@]}"; do	
	file_name="${file%"$FILE_EXTENSION"}"
	file_name="${file_name##*/}"
	file_path="${file%/*}"
	file_path="${file_path##"$DIRECTORY"}"
	if [[ "$file_path"/ == "$DIRECTORY" ]]; then
		file_path=""
	fi
	file_directory="${file_path##*/}"
	temp_error=""
	result=`python "$NAME_TESTS"NameCompliance.py "$file_name"`
	if [[ "$result" != "" ]]; then
		temp_error="${temp_error}""$INDENT""$INDENT""${red}""$result""${end}""\n"
	fi
	result=`python "$NAME_TESTS""$FILE_TEST" "$file_name" "$file_directory"`
	if [[ "$result" != "" ]]; then
		temp_error="${temp_error}""$INDENT""$INDENT""${red}""$result""${end}""\n"
	fi
	file_depth="$(echo "$file" | tr -c -d '/' | wc -c)"
	depth_correct=0
	for depth in "${CORRECTDEPTH[@]}"; do
		if [[ "$file_depth" == "$depth" ]]; then
			depth_correct=1
		fi
	done
	if [[ "$depth_correct" == 0 ]]; then
		temp_error="${temp_error}""$INDENT""$INDENT""${red}""ERROR: This file type should be at a directory depth of ""${CORRECTDEPTH[@]}"", is at ""$file_depth"".""${end}""\n"
	fi
	if [ "$temp_error" != "" ]; then
		if [[ "$previous_path" != "$file_path" ]]; then
                	error_output="${error_output}""${yel}""/""$file_path""${end}""\n""$INDENT""$file_name""$FILE_EXTENSION""\n"
        	else
                	error_output="${error_output}""$INDENT""$file_name""$FILE_EXTENSION""\n"
        	fi
		error_output="${error_output}""$temp_error"
		((error_count++))
	fi
	if [[ "$previous_path" != "$file_path" ]]; then
                output="${output}""${yel}""/""$file_path""${end}""\n""$INDENT""$file_name""$FILE_EXTENSION""\n"
        else
                output="${output}""$INDENT""$file_name""$FILE_EXTENSION""\n"
        fi
	output="${output}""$temp_error"
	previous_path="$file_path"
done

printf "${yel}\n%20s###""$REPORT_TYPE""###\n\n${end}"

if [[ "$DIRECTORY" != "" ]]; then
        printf "Displaying records under: ""${yel}""$DIRECTORY""${end}""\n"
else
        printf "Displaying records under: ""${yel}""Data/""${end}""\n"
fi
if [[ "$error_count" != 0 ]]; then
	erc=$'\e[1;31m'
fi

printf "\n"
printf "$indent""%-15s %s\n" "Total:" "| "${#FILE_ARRAY[@]}""
printf "$indent""%-15s %s\n" "Errors:" "| ${erc}"$error_count"${end}"
printf "\n"

display=""
read -r -p "List all [A], only errors [E] or nothing [N]? " response
if [[ "$response" =~ ^([aA])+$ ]]; then
	display="A"
elif [[ "$response" =~ ^([eE])+$ ]]; then
	display="E"
else
	display="N"
fi
if [[ "$display" == "A" ]]; then
	printf "List: ""\n"
	printf "$output"
elif [[ "$display" == "E" ]]; then
	printf "Errors List: ""\n"
        printf "$error_output"
fi

printf "\n\n"


