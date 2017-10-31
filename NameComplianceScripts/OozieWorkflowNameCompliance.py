#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Oozie Workflows.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 27/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

#String ends with a version number
searchObj = re.search(r'_V[0-9][.][0-9]$', inputString)
if not searchObj:
        print 'ERROR: >>>', inputString, '<<< does not contain a proper version number (e.g. V1.0).'

sys.exit(0)

