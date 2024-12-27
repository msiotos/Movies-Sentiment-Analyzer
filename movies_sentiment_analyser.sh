%%file movies_sentiment_analyser.sh
#!/bin/bash

declare -A movieIDs_with_tags

#We read the given tags file using ':' as a delimiter and adding "empty" when
#necessary because IFS can't handle multi characters like '::' and then we fill
#the associative array movieIDs_with_tags with movieID as key and tags as values
#checking if it already exists or not

function read_tags(){
    OLDIFS="$IFS"
    IFS=$':'
    while read -r userID empty movieID empty tag empty timestamp
    do
        if [[ "${movieIDs_with_tags[$movieID]}" ]]
        then
            movieIDs_with_tags["$movieID"]="${movieIDs_with_tags[$movieID]},$tag"
        else
            movieIDs_with_tags["$movieID"]="$tag"
        fi
    done < "/content/drive/MyDrive/tags_stemmed_tokenized_clean_no_stopwords.dat"
    IFS="$OLDIFS"
}

#We parse the associative array for each movie, we separate each tag by ' '
#then each word by '\n' and then we use the command grep -w (for exact match)
#-f (for the pattern file) and wc -l to get the amount of lines (tags)
#finally we do the comparisons nad print the apropriate message

function parse_tags(){
    echo -e "movie_id\t\tpositive_count\t\tnegative_count\t\tsentiment"
    echo "__________________________________________________________________________________________"

    for movieID in "${!movieIDs_with_tags[@]}"
    do
        tags="${movieIDs_with_tags[$movieID]}"
        positive_count=0
        negative_count=0

        separated_tags=$(echo "$tags" | tr ',' ' ')
        positive_count=$(echo "$separated_tags" | tr ' ' '\n' | grep -w -f /content/drive/MyDrive/positive_stems.txt | wc -l)
        negative_count=$(echo "$separated_tags" | tr ' ' '\n' | grep -w -f /content/drive/MyDrive/negative_stems.txt | wc -l)
        if [[ "$positive_count" -eq "$negative_count" ]]
        then
            echo -e "$movieID\t\t\t$positive_count\t\t\t$negative_count\t\t\tneutral"
        elif [[ "$positive_count" -gt "$negative_count" ]]
        then
            echo -e "$movieID\t\t\t$positive_count\t\t\t$negative_count\t\t\tpositive"
        else
            echo -e "$movieID\t\t\t$positive_count\t\t\t$negative_count\t\t\tnegative"
        fi
    done
}

function main(){
    read_tags
    parse_tags
}
main