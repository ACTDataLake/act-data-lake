#!/bin/bash

#Description: Creates the Data volume and a volume for each listing in directorates.name
#Author: Robert A. Marshall
#Date: 12/10/2017
#Authorized by:
#Last Modified: 12/10/2017
#Audit Log:
#--------------------------------------------------------------------------------------------------------------------------------------------------

# Clear the screen
clear

#Variables
VolumeName=Data
VolumePath=/Data
BS=/
DirectoratesFile=/directorates.name #Assumes that .name file is in same location as script file
DirectoratesFilePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)$DirectoratesFile"

#Body
if [ $USER = mapr ]; then
        echo Creating Data Volume
        maprcli volume create -name $VolumeName -ae mapr -aetype 0  -auditenabled true -coalesce 120 -path $VolumePath -readAce p -writeAce p -rootdirperms 777

        while read -r line
        do
                echo Creating "$line" Volume
                maprcli volume create -name $line -ae mapr -aetype 0  -auditenabled true -coalesce 120 -path $VolumePath$BS$line -readAce p -writeAce p -rootdirperms 777
        done < "$DirectoratesFilePath"
        echo Create Volumes Script Completed.
else
        echo ERROR: This script must be run as super user mapr. No volumes created.
fi
