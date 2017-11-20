#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Flat Files.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 27/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

#Includes at least one suffix marked by an underscore.
underScoreCount = len(re.findall('_', inputString))
if underScoreCount < 1:
        print 'ERROR: >>>', inputString, '<<< is missing a suffix seperated by an underscore.'
if underScoreCount > 1:
	print 'ERROR: >>>', inputString, '<<< contains underscore other than to denote a suffix.'

sys.exit(0)


