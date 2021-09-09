###############################################################################
# Function to retrieve twitter data for search term 
#
# Author: Nina Kashyap
# Created 2021-08-30 21:06:14
###############################################################################


get_tweets <- function(search_word, n_tweets) {
  # ONLY RETURNS DATA FROM THE PAST 6-9 DAYS
  search_tweets(q = search_word,
                type = 'mixed',
                n = n_tweets,
                lang = 'en',
                include_rts = F)
}

