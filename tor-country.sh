#!/bin/bash
# Shell script to change Tor exit node country

get_country_code() {
    country=$(grep -i "$1" data.csv)
    if [ "$country" ]
    then
    
        lines=$(echo "$country" | wc -l)
        if [ $lines -eq 1 ]
        then
            country_code=$(echo $country | rev | cut -d "," -f1 | rev)
        else
            echo -e "Multiple countries matched:\n$country"
            return 1
        fi
        
    else
        echo "Could not find country."
        return 1
    fi
    
    return 0
}


get_country_code $1
echo $country_code