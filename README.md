# Movies-Sentiment-Analyzer

This project implements a Bash Script for analyzing the sentiment of movies based on their tags. 

It classifies movies as positive, negative, or neutral based on the number of positive and negative word stems in the tags provided.

Input Files:

positive_stems.txt - List of positive stems (one per line).

negative_stems.txt - List of negative stems (one per line).

tags_stemmed_tokenized_clean_no_stopwords.dat - Processed tags for each movie.

Output:

The script generates a report with the following columns:

movie_id - Unique ID of the movie.

positive_count - Count of positive stems in tags.

negative_count - Count of negative stems in tags.

sentiment - Classification as positive, negative, or neutral.
