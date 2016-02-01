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

get_torrc_path(){
    torrc_path=$(find / -type f -iwholename "*/Browser/TorBrowser/Data/Tor/torrc" 2>/dev/null)
    if [ "$torrc_path" ]
    then
        
        lines=$(echo "$torrc_path" | wc -l)
        if [ $lines -gt 1 ]
        then
            counter=0;
            for path in $torrc_path
            do
                counter=$((counter + 1))
                echo "$counter- $path"
            done
            read -p "Chose the correct path: " op
            torrc_path=$(echo "$torrc_path" | head -$op | tail -1)
        fi
        
    else
        echo "The torrc file was not found."
        return 1
    fi
    
    return 0
}


get_country_code $1
echo $country_code
get_torrc_path
echo $torrc_path