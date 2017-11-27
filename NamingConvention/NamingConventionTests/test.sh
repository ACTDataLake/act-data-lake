
if [[ $# != 2 ]]; then
	printf "Please enter two arguments in the format of a string to test and naming compliance script. E.g. TestString NameCompliance.\n"
	exit
fi

result=`python "$2".py "$1"`

if [ "$result" != "" ]; then
	echo $result
else
	echo "No issues with input."
fi
