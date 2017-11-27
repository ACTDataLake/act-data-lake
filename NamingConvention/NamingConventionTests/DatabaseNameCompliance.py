#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Databases.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 27/11/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

if len(sys.argv) != 3:
	print 'ERROR: DatabaseNameCompliance.py must be given two arguments.'
	sys.exit(0)

inputString = sys.argv[1]
databaseType = sys.argv[2]

if databaseType == "Landing":
	searchObj = re.search(r'_Landing$|_Intermediate$', inputString)
	if not searchObj:
		print 'ERROR: >>>', inputString, '<<< must end in _Landing or _Intermediate.'
elif databaseType == "Processed":
	underscoreCount = len(re.findall('_', inputString))
	if underscoreCount > 0:
		print 'ERROR: >>>', inputString, '<<< must not contain underscores.'
else:
	print 'ERROR:', databaseType, 'is not a recognised argument - please check your test code.'

sys.exit(0)
