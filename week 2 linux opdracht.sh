#! /bin/bash

###
# Studenten: Eric Low & Martijn Oosterhuis
# script om bestanden te verplaatsen, te sorteren en automatisch te verwijderen
###

echo "Script wordt gestart"

dir=$1 # directory als parameter van het script
var=$2 # maand of week

if [ -d "$dir" ]; # als dir een directory is, ga het verder met de code
then	
	# gaat door de directory $dir heen
	for x in "$dir"/*
	do
		if [ -f "$x" ]; # als item een bestand is (-f) ...
		then
			if [ $var == "week" ]; # als er geordend moet worden op week
			then
				fullDir="$dir$creationweek" # directory naam
				creationweek=$(ls -l --time-style='+%-V' "$x" | awk '{print $6}')
				
                if [ -d "$dir$creationweek" ]; 
				then # als de directory naam al bestaat hoeft deze niet aangemaakt te worden
					cp $x "$dir$creationweek/"
				else # als de directory naam nog niet bestaat moet deze wel aangemaakt worden
					mkdir "$dir$creationweek/"
					cp $x "$dir$creationweek/"
				fi
				
				originalhash=$(sudo md5sum "$x" | cut -d " " -f1) # hash van het originele bestand
				
                newhash=$(sudo md5sum "$dir$creationweek/${x##*/}" | cut -d " " -f1) # hash van het nieuwe bestand
				
                if [ $originalhash == $newhash ];
				then # als deze hashes gelijk zijn kan het origineel verwijdert worden
					rm $x
				fi

				echo "Bestand $x is gemaakt in week: $creationweek en gekopieerd naar $dir/$creationweek/" # laat zien waar het bestand heen is verplaatst
			else
				creationmaand=$(ls -l --time-style='+%-m' "$x" | awk '{print $6}')
				
                if [ -d "$dir$creationmaand" ];
				then # als de directory naam al bestaat hoeft deze niet aangemaakt te worden
					cp $x "$dir$creationmaand/"
				else # als de directory naam nog niet bestaat moet deze wel aangemaakt worden
					mkdir "$dir$creationmaand/"
					cp $x "$dir$creationmaand/"
				fi
				
				originalhash=$(sudo md5sum "$x" | cut -d " " -f1) # hash van het originele bestand
				newhash=$(sudo md5sum "$dir$creationmaand/${x##*/}" | cut -d " " -f1) # hash van het nieuwe bestand
				if [ $originalhash == $newhash ];
				then # als deze hashes gelijk zijn kan het origineel verwijdert worden
					rm $x 
				fi
				echo "Bestand $x is gemaakt in maand: $creationmaand en gekopieerd naar $dir/$creationmaand/" # laat zien waar het bestand heen is verplaatst
			fi
		fi
	done
else
	echo "Geen directory ingevoerd, code stopt"
	exit		
fi