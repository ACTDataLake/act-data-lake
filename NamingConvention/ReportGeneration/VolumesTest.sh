#!/bin/bash

#Description: Lists mounted volumes with /Data as root.
#Author: Robert A. Marshall
#Date: 16/11/17
#Authorised by:
#Last Modified: 16/11/17
#Audit Log:
#Notes:
#--------------------------------------------------------------------#

#Variables
indent="     "
ind1="%5s"
ind2="%10s"
ind3="%15s"
ind4="%20s"
errorOutput=""
errorCount=0
root="/Data"

. reportConfig.config #Loads $namingTestsDirectory

#Body
printf "\n%20s###VOLUME CHECK###\n"

volumesArray=()

if [[ $# != 0 ]]; then
        volumesArray+=( "$root" )
	for arg in "$@"
	do
		tempArray=()
		tempArray+=( $(maprcli volume list -filter [mt==1]and[p=="$root/$arg*"] -columns mountdir) ) 
		for tempItem in "${tempArray[@]}"
		do
			if [ "$tempItem" != "mountdir" ]; then
				volumesArray+=("$tempItem")
			fi
		done
		if [ "${#tempArray[@]}" == 0 ]; then
			 printf "\nERROR: ""$arg"" is not a known directory.\n"
		fi
	done
else
	tempArray=( $(maprcli volume list -filter [mt==1]and[p=="$root*"] -columns mountdir) ) #All mounted volumes beggining with /Data
	for tempItem in "${tempArray[@]}"
        do
        	if [ "$tempItem" != "mountdir" ]; then
        		volumesArray+=("$tempItem")
        	fi
        done
fi

arraylength=${#volumesArray[@]}

#Naming Conventions check
for (( i=0; i<${arraylength}; i++ ));
do
	tempError=""
	result=`python "$namingTestsDirectory"NameCompliance.py "${volumesArray[$i]}" "Path"`
	if [ "$result" != "" ]; then
        	tempError="${tempError}""$indent""$result""\n"
        fi
	result=`python "$namingTestsDirectory"VolumeNameCompliance.py "${volumesArray[$i]}"`
	if [ "$result" != "" ]; then
        	tempError="${tempError}""$indent""$result""\n"
	fi
	if [ "$tempError" != "" ]; then
		errorOutput="${errorOutput}""${volumesArray[$i]}""\n""$tempError"
		((errorCount++))
	fi
done

#Sort volumes into the root, directorate, BU, BS and Landing/Processed levels
for (( i=0; i<${arraylength}; i++ ));
do
	if [ "$(echo ${volumesArray[$i]} | tr -c -d '/' | wc -c)" -eq 1 ]; then
		rootArray+=("${volumesArray[$i]}")
	elif [ "$(echo ${volumesArray[$i]} | tr -c -d '/' | wc -c)" -eq 2 ]; then
		directoratesArray+=("${volumesArray[$i]}")
	elif [ "$(echo ${volumesArray[$i]} | tr -c -d '/' | wc -c)" -eq 3 ]; then
		businessUnitsArray+=("${volumesArray[$i]}")
	elif [ "$(echo ${volumesArray[$i]} | tr -c -d '/' | wc -c)" -eq 4 ]; then
		businessSystemsArray+=("${volumesArray[$i]}")
	elif [ "$(echo ${volumesArray[$i]} | tr -c -d '/' | wc -c)" -eq 5 ]; then
		landingOrProcessedArray+=("${volumesArray[$i]}")
	else
		printf "\nERROR: Volume ""${volumesArray[$i]}"" entry does not comply to standard structure."
	fi
done

#Name checks and sorts Landing/Processed volumes
for (( i=0; i<${#landingOrProcessedArray[@]}; i++ ));
do
	volumeName=${landingOrProcessedArray[$i]}
        volumeName="${volumeName##*/}"
	if [ "$volumeName" == "Landing" ]; then
		landingArray+=("${landingOrProcessedArray[$i]}")
	elif [ "$volumeName" == "Processed" ]; then
		processedArray+=("${landingOrProcessedArray[$i]}")
	else
		printf "\nERROR: ${landingOrProcessedArray[$i]} is not a valid Landing or Processing volume!\n"
	fi
done

#Reports on volume numbers
rootLength=${#rootArray[@]}
directoratesLength=${#directoratesArray[@]}
businessUnitsLength=${#businessUnitsArray[@]}
businessSystemsLength=${#businessSystemsArray[@]}
landingLength=${#landingArray[@]}
processedLength=${#processedArray[@]}

printf "\nMapR Volumes: \n"
printf "$indent""%-18s %s\n" "Total Volumes" "| $(($rootLength+$directoratesLength+$businessUnitsLength+$businessSystemsLength+$landingLength+$processedLength))"
printf "$indent""%-18s %s\n" "Root" "| $rootLength"
printf "$indent""%-18s %s\n" "Directorates" "| $directoratesLength"
printf "$indent""%-18s %s\n" "Business Units" "| $businessUnitsLength"
printf "$indent""%-18s %s\n" "Business Systems" "| $businessSystemsLength"
printf "$indent""%-18s %s\n" "Landing" "| $landingLength"
printf "$indent""%-18s %s\n" "Processed" "| $processedLength"
printf "$indent""%-18s %s\n" "Non-Compliant" "| $errorCount"

#Report if there is an incorrect number of landing or processed volumes for the number of business systems
if [ $businessSystemsLength != $landingLength ] || [ $businessSystemsLength != $processedLength ];then
	printf "\nERROR: THERE ARE MISSING LANDING AND/OR PROCESSED VOLUMES!\n"
fi

printf "\n"

display=""
read -r -p "Display Volumes Map? [Y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    display="Yes"
else
    display="No"
fi

if [ "$display" == "Yes" ]; then

printf "\nNon-Compliant Volumes: \n"
if [ "$errorCount" != 0 ]; then
	printf "$errorOutput"
else
	printf "None\n"
fi


printf "\nVolume Map: \n"

# Volume Path Diagram
for (( i=0; i<${rootLength}; i++ )); #For each root
do
	printf "${rootArray[$i]}\n"
	for (( b=0; b<${directoratesLength}; b++ )); #Check if matching Directorate volumes
	do
		if [[ ${directoratesArray[$b]} == *"${rootArray[$i]}"* ]]; then
			directorateVolumeName=${directoratesArray[$b]}
			printf "$ind1/${directorateVolumeName##*/}\n"
			
			for (( c=0; c<${businessUnitsLength}; c++ )); #Check if the directorate volume has business units
        		do
				if [[ ${businessUnitsArray[$c]} == *"${directoratesArray[$b]}"* ]]; then
                        		bUVolumeName=${businessUnitsArray[$c]}
                        		printf "$ind2/${bUVolumeName##*/}\n"
					
					for (( d=0; d<${businessSystemsLength}; d++ )); #Check if the business unit has business systems
                        		do
						if [[ ${businessSystemsArray[$d]} == *"${businessUnitsArray[$c]}"* ]]; then
                                        		bSVolumeName=${businessSystemsArray[$d]}
                                        		printf "$ind3/${bSVolumeName##*/}\n"
							
							landingPresent=0
							for (( e=0; e<${landingLength}; e++ )); #Check if the business system has Landing
		                                        do
								if [[ ${landingArray[$e]} == *"$bSVolumeName"* ]]; then
									((landingPresent++))
								fi

							done
							if [[ $landingPresent = 0 ]]; then
								printf "$ind4""ERROR: NO LANDING VOLUME FOUND\n"
							fi

							processedPresent=0
							for (( f=0; f<${processedLength}; f++ )); #Check if the business system has Processed
							do
								if [[ ${processedArray[$f]} == *"$bSVolumeName"* ]]; then
									((processedPresent++))
								fi
							done
							if [[ $processedPresent = 0 ]]; then
								printf "$ind4""ERROR: NO PROCESSED VOLUME FOUND\n"
							fi
							businessSystemsArray[$d]="Done"
						fi
					done
					businessUnitsArray[$c]="Done"
				fi
			done
			directoratesArray[$b]="Done"
		fi
	done
	rootArray[$i]="Done"
done

printf "\n"

#Report any volumes that weren't found in the mount directory diagram
for entry in "${rootArray[@]}"
do
        if [[ $entry != "Done" ]]; then
                printf "ERROR: $entry not found in volume map. Missing parent volume(s).\n"
        fi
done
for entry in "${directoratesArray[@]}"
do
        if [[ $entry != "Done" ]]; then
                printf "ERROR: $entry not found in volume map. Missing parent volume(s).\n"
        fi
done
for entry in "${businessUnitsArray[@]}"
do
        if [[ $entry != "Done" ]]; then
                printf "ERROR: $entry not found in volume map. Missing parent volume(s).\n"
        fi
done
for entry in "${businessSystemsArray[@]}"
do
        if [[ $entry != "Done" ]]; then
                printf "ERROR: $entry not found in volume map. Missing parent volume(s).\n"
        fi
done
for entry in "${landingArray[@]}"
do
        if [[ $entry != "Done" ]]; then
                printf "ERROR: $entry not found in volume map. Missing parent volume(s).\n"
        fi
done
for entry in "${processedSystemsArray[@]}"
do
	if [[ $entry != "Done" ]]; then
		printf "ERROR: $entry not found in volume map. Missing parent volume(s).\n"
	fi
done

fi


