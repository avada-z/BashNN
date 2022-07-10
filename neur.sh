#!/bin/bash
ACTIVATOR=5000
rm current_image_temp.txt
blankmodel()
{
	for i in {1..4096}
	do
	printf "neur""$i"" ""$(( RANDOM % 10 ))""\n" >> new_model.model
	done
}
punishment_down()
{
	echo "Running punishment down"
	ACTLINE=1
	while read l; do
    if [[ $(tail -n+$ACTLINE current_image_temp.txt | head -n1) == 1 ]]
	then
	REPL=$(($(echo $l | awk '{print $2}')-1)) 
	sed -i ""$ACTLINE"s/$l/neur"$ACTLINE" $REPL/" new_model.model
	fi
	ACTLINE=$(($ACTLINE+1))
	done < new_model.model
}
punishment_up()
{
	echo "Running punishment up"
	ACTLINE=1
	while read l; do
    if [[ $(tail -n+$ACTLINE current_image_temp.txt | head -n1) == 1 ]]
	then
	REPL=$(($(echo $l | awk '{print $2}')+1))
	sed -i ""$ACTLINE"s/$l/neur"$ACTLINE" $REPL/" new_model.model
	fi
	ACTLINE=$(($ACTLINE+1))
	done < new_model.model
}
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
printf "Image $f rating is $RATING\n"
if [[ $RATING -ge $ACTIVATOR && $f == *".jpg"* ]]
then
#printf "It's a human face! (Y/N)"
#read -r FALSEPOS
#if [[ $FALSEPOS == "N" ]]
#then
punishment_down
fi
if [[ $RATING -lt $ACTIVATOR && $f == *".png"* ]]
then
#else
#printf "It's not a human face! (Y/N)"
#read -r FALSENEG
#if [[ $FALSENEG == "N" ]]
#then
punishment_up
#fi
fi
}
main()
{	
	printf "Starting training\n"
	printf "Specify the image folder: "
	read -r IMPATH
	for f in $IMPATH/*
	do
	convert $f -threshold 30% $f
	convert $f sparse-color: | tr " " "\n" | tr "," " " | awk '{print $3}' | sed '/gray(255)/ s//1/g' | sed '/gray(0)/ s//0/g' > current_image_temp.txt
	check
	done
}
main