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

#Body
printf "\n%20s###VOLUME CHECK###\n"

volumesArray=( $(maprcli volume list -filter [mt==1]and[p=="/Data*"] -columns mountdir) ) #All mounted volumes beggining with /Data

#Sort volumes into the root, directorate, BU, BS and Landing/Processed levels
arraylength=${#volumesArray[@]}

#Naming Conventions check
for (( i=2; i<${arraylength}+1; i++ ));
do
	result=`python NameCompliance.py "${volumesArray[$i-1]}" "Path"`
	if [ "$result" != "" ]; then
        	echo $result
        fi
	result=`python VolumeNameCompliance.py "${volumesArray[$i-1]}"`
	if [ "$result" != "" ]; then
        	echo $result
	fi
done


for (( i=2; i<${arraylength}+1; i++ )); #Starts at 2 to skip the heading row of the mapcrli volume list
do
	if [ "$(echo ${volumesArray[$i-1]} | tr -c -d '/' | wc -c)" -eq 1 ]; then
		rootArray+=("${volumesArray[$i-1]}")
	elif [ "$(echo ${volumesArray[$i-1]} | tr -c -d '/' | wc -c)" -eq 2 ]; then
		directoratesArray+=("${volumesArray[$i-1]}")
	elif [ "$(echo ${volumesArray[$i-1]} | tr -c -d '/' | wc -c)" -eq 3 ]; then
		businessUnitsArray+=("${volumesArray[$i-1]}")
	elif [ "$(echo ${volumesArray[$i-1]} | tr -c -d '/' | wc -c)" -eq 4 ]; then
		businessSystemsArray+=("${volumesArray[$i-1]}")
	elif [ "$(echo ${volumesArray[$i-1]} | tr -c -d '/' | wc -c)" -eq 5 ]; then
		landingOrProcessedArray+=("${volumesArray[$i-1]}")
	else
		printf "\nERROR: Volume [" "${volumesArray[$i-1]}"  "] entry does not comply to standard structure."
	fi
done

#Name checks and sorts Landing/Processed volumes
for (( i=1; i<${#landingOrProcessedArray[@]}+1; i++ ));
do
	volumeName=${landingOrProcessedArray[$i-1]}
        volumeName="${volumeName##*/}"
	if [ "$volumeName" == "Landing" ]; then
		landingArray+=("${landingOrProcessedArray[$i-1]}")
	elif [ "$volumeName" == "Processed" ]; then
		processedArray+=("${landingOrProcessedArray[$i-1]}")
	else
		printf "\nERROR: ${landingOrProcessedArray[$i-1]} is not a valid Landing or Processing volume!\n"
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

#Report if there is an incorrect number of landing or processed volumes for the number of business systems
if [ $businessSystemsLength != $landingLength ] || [ $businessSystemsLength != $processedLength ];then
	printf "\nERROR: THERE ARE MISSING LANDING AND/OR PROCESSED VOLUMES!\n"
fi

printf "\nVolume Map: \n"

# Volume Path Diagram
for (( i=1; i<${rootLength}+1; i++ )); #For each root
do
	printf "${rootArray[$i-1]}\n"
	for (( b=1; b<${directoratesLength}+1; b++ )); #Check if matching Directorate volumes
	do
		if [[ ${directoratesArray[$b-1]} == *"${rootArray[$i-1]}"* ]]; then
			directorateVolumeName=${directoratesArray[$b-1]}
			printf "$ind1/${directorateVolumeName##*/}\n"
			
			for (( c=1; c<${businessUnitsLength}+1; c++ )); #Check if the directorate volume has business units
        		do
				if [[ ${businessUnitsArray[$c-1]} == *"${directoratesArray[$b-1]}"* ]]; then
                        		bUVolumeName=${businessUnitsArray[$c-1]}
                        		printf "$ind2/${bUVolumeName##*/}\n"
					
					for (( d=1; d<${businessSystemsLength}+1; d++ )); #Check if the business unit has business systems
                        		do
						if [[ ${businessSystemsArray[$d-1]} == *"${businessUnitsArray[$c-1]}"* ]]; then
                                        		bSVolumeName=${businessSystemsArray[$d-1]}
                                        		printf "$ind3/${bSVolumeName##*/}\n"
							
							landingPresent=0
							for (( e=1; e<${landingLength}+1; e++ )); #Check if the business system has Landing
		                                        do
								if [[ ${landingArray[$e-1]} == *"$bSVolumeName"* ]]; then
									((landingPresent++))
								fi

							done
							if [[ $landingPresent = 0 ]]; then
								printf "$ind4""ERROR: NO LANDING VOLUME FOUND\n"
							fi

							processedPresent=0
							for (( f=1; f<${processedLength}+1; f++ )); #Check if the business system has Processed
							do
								if [[ ${processedArray[$f-1]} == *"$bSVolumeName"* ]]; then
									((processedPresent++))
								fi
							done
							if [[ $processedPresent = 0 ]]; then
								printf "$ind4""ERROR: NO PROCESSED VOLUME FOUND\n"
							fi
							businessSystemsArray[$d-1]="Done"
						fi
					done
					businessUnitsArray[$c-1]="Done"
				fi
			done
			directoratesArray[$b-1]="Done"
		fi
	done
	rootArray[$i-1]="Done"
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

printf "\n"
