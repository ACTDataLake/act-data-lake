#! /bin/bash

#Description: Lists streamsets.
#Author: Robert A. Marshall
#Date: 24/11/17
#Authorised by:
#Last Modified:
#Audit Log:
#Notes:
#--------------------------------------------------------------------#

prefix="  \"title\" : \""
suffix="\","
indent="     "

streamIDArray=($(ls /var/lib/sdc/pipelines/))
streamTitlesArray=()
nonCompliantCount=0

#Get streamset titles from ID match
for entry in "${streamIDArray[@]}"
do
	while IFS='' read -r line || [[ -n "$line" ]];
	do
        	if [[ "$line" == "$prefix"* ]]; then
                	string=${line#$prefix}
                	string=${string%$suffix}
			streamTitlesArray+=("$string")
        	fi
	done < /var/lib/sdc/pipelines/"$entry"/info.json

done

#Check streamset titles against naming conventions
IFS=$'\n' streamTitlesArray=($(sort <<<"${streamTitlesArray[*]}"))
outputString=""
for entry in "${streamTitlesArray[@]}"
do
	compliantCheck=0
	outputString="${outputString}""$entry""\n"
	result=`python NameCompliance.py "$entry" "Version"`
	if [ "$result" != "" ]; then
        	outputString="${outputString}""$result""\n"
		compliantCheck=1
        fi
	result=`python StreamsetsJobNameCompliance.py "$entry"`
	if [ "$result" != "" ]; then
		outputString="${outputString}""$result""\n"
        	compliantCheck=1
	fi
	if [ "$compliantCheck" != 0 ]; then
		((nonCompliantCount++))
	fi
done

#Print numbers
printf "\n%20s###STREAMSETS CHECK###\n"
compliantCount=$((${#streamTitlesArray[@]} - $nonCompliantCount))
printf "\nStreamsets:\n"
printf "$indent""%-15s %s\n" "Total:" "| "${#streamTitlesArray[@]}""
printf "$indent""%-15s %s\n" "Compliant:" "| "$compliantCount""
printf "$indent""%-15s %s\n" "NonCompliant:" "| "$nonCompliantCount""
printf "\n"

display=""
read -r -p "Display Streamsets List? [Y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    display="Yes"
else
    display="No"
fi

#Display Streamsets List
if [ "$display" == "Yes" ]; then
	printf "\nStreamsets List:\n"
	errorStr="$indent""$indent""ERROR:"
	errorOutput=${outputString//ERROR:/"$errorStr"}
	printf "$errorOutput\n"
fi


printf "\n"
