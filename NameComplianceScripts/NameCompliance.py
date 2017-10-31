#! /usr/bin/python
import re
import sys

#Description: Checks a string against the standard naming conventions.
#Author: Robert A. Marshall
#Date: 25/10/17
#Authorised by: 
#Last Modified: 26/10/17
#Audit Log: 
#Notes: Returns error messages as a string or an empty string if no errors.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

stringSizeLimit = 64
stringSize = len(inputString)

#Length limit
if stringSize >= stringSizeLimit:
	print 'ERROR: >>>', inputString, '<<< is too long.'

#No whitespace characters
searchObj = re.search('\s', inputString)
if searchObj:
	print 'ERROR: >>>', inputString, '<<< contains whitespace.'

#Begins with a capital letter
searchObj = re.search('^[A-Z]', inputString)
if not searchObj:
        print 'ERROR: >>>', inputString, '<<< does not begin with a capital letter.'

#Underscore not followed by a capital letter or number
searchObj = re.search('[_][^A-Z0-9]', inputString)
if searchObj:
        print 'ERROR: >>>', inputString, '<<< contains an underscore not followed by capital or number.'

#String contains no non-alphaumeric character other than '_'
searchObj = re.search('\W', inputString)
if searchObj:
        print 'ERROR: >>>', inputString, '<<< contains a character other than alphanumeric or underscore.'

sys.exit(0)
