#! /usr/bin/python
import re
import sys

#Description: Checks a string against the Volume and Sub-Volume naming conventions.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 27/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

#Does not contain underscores
searchObj = re.search('_', inputString)
if searchObj:
        print 'ERROR: >>>', inputString, '<<< should not contain underscores.'

#Is a directory path
searchObj = re.search('^[/]', inputString)
if not searchObj:
        print 'ERROR: >>>', inputString, '<<< does not begin with a slash.'


sys.exit(0)

