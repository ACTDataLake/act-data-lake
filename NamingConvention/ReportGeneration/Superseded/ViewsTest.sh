#! /bin/bash

#Description: Lists .view.drill access views.
#Author: Robert A. Marshall
#Date: 21/11/17
#Authorised by:
#Last Modified: 24/11/17
#Audit Log:
#Notes:
#--------------------------------------------------------------------#

#Variables
indent="     "
output=""
errorOutput=""
viewArray=()
currentDirectory=$(pwd)

count=0

. reportConfig.config #Loads $dataDirectory and $namingTestsDirectory

#Body

cd "$dataDirectory"
shopt -s nullglob
tempDirectoryArray=(*/)
shopt -u nullglob # Turn off nullglob

printf "\n%20s###VIEWS CHECK###\n\n"

#Create list of directories, limit by arguments if present
if [[ $# != 0 ]]; then
	shopt -s nullglob
	for arg in "$@"
	do
		if [[ " ${tempDirectoryArray[@]} " =~ " ${arg}/ " ]]; then
    			directoryArray+=("$arg")
		else
			printf "ERROR: ""$arg"" is not a known directory.\n\n"
		fi
	done
	shopt -u nullglob # Turn off nullglob
else
	for dirTemp in "${tempDirectoryArray[@]}"
	do
		directoryArray+=(${dirTemp: : -1})
	done
fi

arraylength=${#directoryArray[@]}

#Build the views diagram output string
errorCount=0
for (( i=0; i<${arraylength}; i++ ));
do
	directoryName="${directoryArray[$i]}"
	output="${output}""/""$directoryName""\n"
	dirError=""
	cd "$dataDirectory""$directoryName"
	shopt -s nullglob
	tempArray=(*)
	shopt -u nullglob
	for x in "${tempArray[@]}"
	do
		if [ "$x" != "Landing" ] && [ "$x" != "Processed" ]; then
			if [[ ! "$x" =~ ".drill"+$ ]]; then
				output="${output}""$indent""ERROR:""$x"" is not a .drill file and should not be in this location.""\n"
			else
				output="${output}""$indent""$x""\n"
				fileName=${x%.view.drill}
				viewArray+=("$fileName")
				cd "$currentDirectory"
				tempError=""
			        result=`python "$namingTestsDirectory"NameCompliance.py "$fileName"`
        			if [ "$result" != "" ]; then
                			tempError="${tempError}""$result""\n"
			        fi
			        result=`python "$namingTestsDirectory"AccessViewsNameCompliance.py "$fileName"`
			        if [ "$result" != "" ]; then
		                	tempError="${tempError}""$result""\n"
			        fi
			        if [ "$tempError" != "" ]; then
			                dirError="${dirError}""$indent""$x""\n""$tempError"
			                ((errorCount++))
			        fi
			fi
		fi 
	done
	if [ "$dirError" != "" ]; then
		errorOutput="${errorOutput}""/""$directoryName""\n""$dirError"
	fi
done

#Report View numbers
printf "Access Views:\n"
totalViews="${#viewArray[@]}"
comViews=$((totalViews - errorCount))
printf "$indent""%-15s %s\n" "Total Views:" "| "$totalViews""
printf "$indent""%-15s %s\n" "Compliant:" "| "$comViews""
printf "$indent""%-15s %s\n" "Non-Compliant:" "| "$errorCount""
printf "\n"

display=""
read -r -p "Display Views Lists? [Y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    display="Yes"
else
    display="No"
fi

#Display Non-Compliant Views
if [ "$display" == "Yes" ]; then
	printf "\nNon-Compliant Views List:\n"
	if [ "$errorCount" == 0 ]; then
		printf "None\n\n"
	else
		errorStr="$indent""$indent""ERROR:"
	        errorOutput=${errorOutput//ERROR:/"$errorStr"}
        	printf "$errorOutput\n"
	fi

#Display View Diagram
	printf "Views Map: \n"
	printf "$output"
fi
