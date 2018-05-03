#!/bin/bash

while read pathlog; do
		filename=$(echo $pathlog | cut -d ':' -f1 | sed -e "s/\s//g")
		origpath=$(echo $pathlog | cut -d ':' -f2 | sed -e "s/\s//g")
		movpath=$(echo $pathlog | cut -d ':' -f3 | sed -e "s/\s//g")
		find $2 -type f -exec sed -i "s|$movpath/$filename|$origpath/$filename|g" {} \;
done < $1