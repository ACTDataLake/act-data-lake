#! /bin/bash

#Description: Runs the report generating scripts.
#Author: Robert A. Marshall
#Date: 24/11/17
#Authorised by:
#Last Modified:
#Audit Log:
#Notes: Passes arguments to scripts
#--------------------------------------------------------------------#

scriptDirectory=$(pwd)
clear

#runs scripts
source "VolumesTest.sh" $@
cd "$scriptDirectory"
source "ViewsTest.sh" $@
cd "$scriptDirectory"
source "StreamsetsTest.sh"
cd "$scriptDirectory"

