#! /bin/bash

#Description: Runs the report generating scripts.
#Author: Robert A. Marshall
#Date: 24/11/17
#Authorised by:
#Last Modified:
#Audit Log:
#Notes: Passes arguments to scripts
#--------------------------------------------------------------------#

. reportConfig.config



if [ ! -d "$dataDirectory" ]; then
	printf "\nERROR: Data Directory not found.\n"
	exit
fi
if [ ! -d "$namingTestsDirectory" ]; then
	printf "\nERROR: Naming Tests Directory not found.\n"
	exit
fi

scriptDirectory=$(pwd)
clear

if [[ $# != 0 ]]; then
	printf "Limiting reports to the following directorates: ""$*""\n"
fi

#runs scripts
./VolumesTest.sh $@
cd "$scriptDirectory"
./Report.sh database "$1"
cd "$scriptDirectory"
./Report.sh view "$1"
cd "$scriptDirectory"
./StreamsetsTest.sh
