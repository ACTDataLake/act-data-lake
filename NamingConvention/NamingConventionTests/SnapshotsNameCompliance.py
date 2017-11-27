#! /usr/bin/python
import re
import sys

#Description: Checks a string against the naming conventions for Snapshots.
#Author: Robert A. Marshall
#Date: 27/10/17
#Authorised by:
#Last Modified: 27/10/17
#Audit Log:
#Notes: Returns error messages as a string or an empty string if no errors. Does not enforce proper dates or times (e.g 31_31_2050 would pass).
#--------------------------------------------------------------------#

inputString = sys.argv[1]

reDate = r'_[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]$'
reDateTime = r'_[0-9][0-9][0-9][0-9]_[0-9][0-9]_[0-9][0-9]_[0-9][0-9]_[0-9][0-9]$'
reMonths = r'_(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)$'
reDays = r'_(Mon|Tue|Wed|Thu|Fri|Sat|Sun)$'

passedRegex = 0

#Ends with a version number suffix
searchObj = re.search(reDate, inputString) #Date suffix
if searchObj:
	passedRegex = 1

searchObj = re.search(reDateTime, inputString) #DateTime suffix
if searchObj:
        passedRegex = 1

searchObj = re.search(reMonths, inputString) #Months suffix
if searchObj:
        passedRegex = 1

searchObj = re.search(reDays, inputString) #Days suffix
if searchObj:
        passedRegex = 1

if passedRegex == 0:
	print 'ERROR: >>>', inputString, '<<< does not end in a proper frequency suffix.'

#Contains non-suffix underscore
underScoreCount = len(re.findall('_', inputString))
if underScoreCount > 1:
        print 'ERROR: >>>', inputString, '<<< format is incorrect or not correctly marked with underscores.'

sys.exit(0)

