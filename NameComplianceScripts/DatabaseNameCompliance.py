#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Databases.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 27/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

#Underscore not followed by an approved suffix
underScoreCount = len(re.findall('_', inputString))
searchObj = re.search(r'_Landing$|_Intermediate$', inputString)
if not searchObj:
        if underScoreCount > 0:
                print 'ERROR: >>>', inputString, '<<< contains underscores not in an approved suffix.'
if searchObj and underScoreCount > 1:
        print 'ERROR: >>>', inputString, '<<< contains underscores not in an approved suffix.'

sys.exit(0)


