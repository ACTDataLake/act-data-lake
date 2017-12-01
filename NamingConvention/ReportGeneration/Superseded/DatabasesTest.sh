#! /bin/bash

#Description: Lists .db files in Landing and Processed folders.
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
databaseArray=()
currentDirectory=$(pwd)

count=0

. reportConfig.config #Loads $dataDirectory and $namingTestsDirectory

#Body

cd "$dataDirectory"
shopt -s nullglob
tempDirectoryArray=(*/)
shopt -u nullglob # Turn off nullglob

printf "\n%20s###DATABASE CHECK###\n\n"

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

#Build the databases diagram output string
errorCount=0
for (( i=0; i<${arraylength}; i++ ));
do
	directoryName="${directoryArray[$i]}"
	output="${output}""/""$directoryName""\n"
	dirError=""
	cd "$dataDirectory""$directoryName"
	shopt -s nullglob
	tempArray=(*) ###Change this to (*/)
	shopt -u nullglob
	for x in "${tempArray[@]}"
	do
		#might have to change to (*/) to get only directories. 
		#get all and create BU array, iterate through and if any == Landing or Processed open and process as below
		#Once done with that level put everything other than Landing/ and Processed/ into a BI array and repeat

		if [ "$x" == "Landing" ] || [ "$x" == "Processed" ]; then
			output="${output}""$indent""/""$x""\n"
			tempLPDirArray=($(ls "$dataDirectory""$directoryName""/""$x"))
			directoryType="Landing"
			if [ "$x" == "Processed" ]; then
				directoryType="Processed"
			fi
			for dbFile in "${tempLPDirArray[@]}";
			do
				fileName=${dbFile%.db}
				output="${output}""$indent""$indent""$dbFile""\n"
                                databaseArray+=("$fileName")
                                cd "$currentDirectory"
                                tempError=""
                                result=`python "$namingTestsDirectory"NameCompliance.py "$fileName"`
                                if [ "$result" != "" ]; then
                                        tempError="${tempError}""$result""\n"
                                fi
                                result=`python "$namingTestsDirectory"DatabaseNameCompliance.py "$fileName" "$directoryType"`
                                if [ "$result" != "" ]; then
                                        tempError="${tempError}""$result""\n"
                                fi
                                if [ "$tempError" != "" ]; then
                                        dirError="${dirError}""$indent""$x""\n""$tempError"
                                        ((errorCount++))
                                fi

			done
		fi 
	done
	if [ "$dirError" != "" ]; then
		errorOutput="${errorOutput}""/""$directoryName""\n""$dirError"
	fi
done

#Report Database numbers
printf "Databases:\n"
totalDatabases="${#databaseArray[@]}"
comDatabases=$((totalDatabases - errorCount))
printf "$indent""%-17s %s\n" "Total Databases:" "| "$totalDatabases""
printf "$indent""%-17s %s\n" "Compliant:" "| "$comDatabases""
printf "$indent""%-17s %s\n" "Non-Compliant:" "| "$errorCount""
printf "\n"

display=""
read -r -p "Display Database Lists? [Y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    display="Yes"
else
    display="No"
fi

#Display Non-Compliant Databases
if [ "$display" == "Yes" ]; then
	printf "\nNon-Compliant Databases List:\n"
	if [ "$errorCount" == 0 ]; then
		printf "None\n\n"
	else
		errorStr="$indent""$indent""ERROR:"
	        errorOutput=${errorOutput//ERROR:/"$errorStr"}
        	printf "$errorOutput\n"
	fi

#Display Database List
	printf "Database Map: \n"
	printf "$output"
fi

