#!/bin/bash
ACTIVATOR=5000
check()
{
RATING=0
LINE=1
while read l; do
    if [[ $(tail -n+$LINE current_image_temp.txt | head -n1) == 1 ]]
	then
	l=$(echo $l | awk '{print $2}')
	RATING=$(($RATING+$l))
	echo "$RATING"
	fi
	LINE=$(($LINE+1))
done < new_model.model
printf "Image rating is $RATING\n"
if [[ $RATING -ge $ACTIVATOR ]]
then
echo "It's a human face!"
else
echo "It's not a human face!"
fi
}
rm -f current_image_temp.txt temp.image
convert $1 -threshold 30% temp.image
convert temp.image sparse-color: | tr " " "\n" | tr "," " " | awk '{print $3}' | sed '/gray(255)/ s//1/g' | sed '/gray(0)/ s//0/g' > current_image_temp.txt
check
rm -f current_image_temp.txt temp.image