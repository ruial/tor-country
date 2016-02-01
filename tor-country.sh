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
    
    echo "Country code: $country_code"
    return 0
}

get_torrc_path() {
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
    
    echo "Path: $torrc_path"
    return 0
}

change_country() {
    if [ -r $torrc_path ] && [ -w $torrc_path ]
    then
        grep -v "^ExitNodes" $torrc_path > temp
        echo "ExitNodes {$country_code}" >> temp
        mv temp $torrc_path
    else
        echo "You don't have permissions to read or write the torrc file."
        return 1
    fi
    
    echo "Tor will now use the specified country."
    return 0
}

if [ $# -eq 1 ]
then
    search_country=$1
else
    read -p "Country name to search: " search_country
fi

get_country_code $search_country && get_torrc_path && change_country