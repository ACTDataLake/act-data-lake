#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Access Views.
#Author: Robert A. Marshall
#Date: 26/10/17
#Authorised by:
#Last Modified: 26/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

#Begins with "View_"
searchObj = re.search('^View_', inputString)
if not searchObj:
        print 'ERROR: >>>', inputString, '<<< does not begin with "View_".'

#Ends with a suffix
underScoreCount = len(re.findall('_.', inputString))
if underScoreCount < 2:
	print 'ERROR: >>>', inputString, '<<< is missing a prefix or suffix.'

sys.exit(0)

