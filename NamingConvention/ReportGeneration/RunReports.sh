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
	printf "\nERROR: ""$dataDirectory"" does not exist.\n"
	exit
fi
if [ ! -d "$namingTests" ]; then
	printf "\nERROR: ""$namingTests"" does not exist.\n"
	exit
fi

scriptDirectory=$(pwd)
#clear

#runs scripts
source "VolumesTest.sh" $@
cd "$scriptDirectory"
source "ViewsTest.sh" $@
cd "$scriptDirectory"
source "StreamsetsTest.sh"
cd "$scriptDirectory"

