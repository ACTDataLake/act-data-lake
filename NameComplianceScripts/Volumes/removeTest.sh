#declare an array variable
declare -a volArray=()

#volArray[$[${#volArray[@]}+1]]="elememt4"
volArray[$[${#volArray[@]}]]="elememt4"


## now loop through the above array
for i in "${volArray[@]}"
do
   echo "$i"
   # or do whatever with individual element of the array
done

# You can access them using echo "${arr[0]}", "${arr[1]}" also

arrayCount=${#volArray[@]}
let arrayCount-=1

until [ $arrayCount -lt 0 ]; do
	echo "****LOOP****"
	echo ArrayCount is $arrayCount
	echo Array Entry is ${volArray[$arrayCount]}
	let arrayCount-=1
done


