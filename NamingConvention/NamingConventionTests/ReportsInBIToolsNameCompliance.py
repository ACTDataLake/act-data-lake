#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Reports in Business Intelligence Tools.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 27/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

#Ends with a version number suffix
searchObj = re.search(r'_V[0-9][.][0-9]$', inputString)
if not searchObj:
        print 'ERROR: >>>', inputString, '<<< does not contain a proper version number (e.g. V1.0).'

#Contains exactly three underscores
underScoreCount = len(re.findall('_', inputString))
if underScoreCount != 2:
        print 'ERROR: >>>', inputString, '<<< format is incorrect or not correctly marked with underscores.'

sys.exit(0)

