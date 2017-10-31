#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Oozie Coordinators.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 27/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

#Ends with a frequency suffix
searchObj = re.search('_Yearly$|_Monthly$|_Weekly$|_Daily$|_Hourly$', inputString)
if not searchObj:
        print 'ERROR: >>>', inputString, '<<< does not end with a correct frequency suffix.'

#Contains only one underscore
underScoreCount = len(re.findall('_', inputString))
if underScoreCount > 1:
        print 'ERROR: >>>', inputString, '<<< contains underscores other than marking the suffix.'

sys.exit(0)


