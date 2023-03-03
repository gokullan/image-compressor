#!/bin/bash

change_quality()
{
	SOURCE=$1
	DESTINATION=$2
	LIMIT=$3
	
	## quality should range from 70 to 85
	LOW=70
	HIGH=85
	MID=$(( (LOW + HIGH) / 2 ))
	OPTIMAL=$MID
	while [ $LOW -le $HIGH ]
	do
		convert $SOURCE -sampling-factor 4:2:0 -strip -quality $MID -interlace JPEG -colorspace RGB $DESTINATION
		FILESIZE=$(stat -c%s $DESTINATION);  # filesize in bytes
		FILESIZE=$(echo "scale = 2; $FILESIZE / 1000" | bc -l)  # filesize in kilobytes upto 2 decimal places
		if (( $(echo "$FILESIZE > $LIMIT" | bc -l) ))
		then
			HIGH=$(( $MID - 1 ))
		else
			LOW=$(( $MID + 1 ))
			OPTIMAL=$MID
		fi
		MID=$(( (LOW + HIGH) / 2 ))
	done
	echo $OPTIMAL
}

change_geometry()
{
	echo "Hi!"	
}

RESULT=$(change_quality $1 $2 50)
echo $RESULT

# if (( $(echo "$filesize > 50" | bc -l) ))
# then
# 	echo "Change Geometry"
# fi
