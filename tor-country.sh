#!/bin/bash
# Shell script to change Tor exit node country

IFS=$'\n'
PS3="Chose the country: "

get_country_code() {
    country_data=$(grep -i "$1" data.csv)
    if [ "$country_data" ]
    then
        
        if [ $(echo "$country_data" | wc -l) -gt 1 ]
        then
            select country in $country_data
            do
                if [ "$country" ]
                then
                    country_data=$country
                    break
                fi
            done
        fi
        
        country_code=$(echo $country_data | rev | cut -d "," -f1 | rev)
        
    else
        echo "Could not find country."
        return 1
    fi
    
    echo "Country code: $country_code"
    return 0
}

get_torrc_path() {
    torrc_path=$(find / -type f -iwholename "*/Tor/torrc" 2>/dev/null)
    if [ ! "$torrc_path" ]
    then
        echo "The torrc file was not found."
        return 1
    fi
    echo -e "Paths found:\n$torrc_path"
    return 0
}

change_country() {
    for path in $torrc_path
    do
        if [ -r $path ] && [ -w $path ]
        then
            grep -v "^ExitNodes" $path > temp
            if [ "$country_name" != "all" ]
            then
                echo "ExitNodes {$country_code}" >> temp
            fi
            mv temp $path
        fi
    done
    
    echo "You might need to restart Tor to apply the changes."
    return 0
}

if [ $# -eq 1 ]
then
    country_name=$1
else
    read -p "Country name to search: " country_name
fi


test $country_name = "all" || get_country_code $country_name && get_torrc_path && change_country