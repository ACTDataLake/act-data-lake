
result=`python NameCompliance.py "Test"`

if [ "$result" != "" ]; then
	echo $result
	exit 0
fi

echo "No issues with input."
