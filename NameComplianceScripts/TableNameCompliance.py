#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Tables.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 26/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

#Begins with "View_"
searchObj = re.search('_', inputString)
if searchObj:
        print 'ERROR: >>>', inputString, '<<< should not contain underscores.'

sys.exit(0)


