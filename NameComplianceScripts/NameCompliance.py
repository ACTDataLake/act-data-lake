#! /usr/bin/python
import re
import sys

#Description: Checks a string against the standard naming conventions.
#Author: Robert A. Marshall
#Date: 25/10/17
#Authorised by: 
#Last Modified: 17/11/17
#Audit Log: 
#Notes: Returns error messages as a string or an empty string if no errors.
#	Accepts nothing, 'Version' or 'Path' as a second argument to allow for exceptions.
#--------------------------------------------------------------------#

inputString = sys.argv[1]

stringType = ""
if len(sys.argv) == 3:
	stringType = sys.argv[2]

stringSizeLimit = 64
stringSize = len(inputString)

#Invalid argument
if stringType != "" and stringType != "Version" and stringType != "Path":
	print 'ERROR: >>>', inputString, '<<< submitted with invalid second argument. Second argument should be "Version" or "Path" if present.'

#Length limit
if stringSize >= stringSizeLimit:
	print 'ERROR: >>>', inputString, '<<< is too long.'

#No whitespace characters
searchObj = re.search('\s', inputString)
if searchObj:
	print 'ERROR: >>>', inputString, '<<< contains whitespace.'

#Underscore not followed by a capital letter or number
searchObj = re.search('[_][^A-Z0-9]', inputString)
if searchObj:
       	print 'ERROR: >>>', inputString, '<<< contains an underscore not followed by capital or number.'

#Begins with a capital letter, not a Path
if stringType == "" or stringType == "Version":
        searchObj = re.search('^[A-Z]', inputString)
        if not searchObj:
                print 'ERROR: >>>', inputString, '<<< does not begin with a capital letter.'

#No argument
if stringType == "":
	#String contains no non-alphaumeric character other than '_'
	searchObj = re.search('\W', inputString)
	if searchObj:
        	print 'ERROR: >>>', inputString, '<<< contains a character other than alphanumeric or underscore.'

#Version Argument
if stringType == "Version":
	dotCount = len(re.findall('\.', inputString))
	searchObj = re.search('[^a-zA-Z0-9_\.]', inputString)
	if searchObj or dotCount > 1:
        	print 'ERROR: >>>', inputString, '<<< contains a character other than alphanumeric, underscore or . outside of a version number.'

#Path Argument
if stringType == "Path":
        firstChar = re.search('^[^/]', inputString)
        searchObj = re.search('[^a-zA-Z0-9_/]', inputString)
        if searchObj or firstChar:
                print 'ERROR: >>>', inputString, '<<< contains a character other than alphanumeric, underscore or /, or does not begin with /.'


sys.exit(0)
