###############################################################################
# Function for twitter data retrieval
#
# Author: Nina Kashyap
# Created 2021-08-30 21:06:14
###############################################################################


# Function to retrieve twitter data for search term  ----------------------

get_tweets <- function(search_word, n_tweets) {
  # ONLY RETURNS DATA FROM THE PAST 6-9 DAYS
  search_tweets(q = search_word,
                type = 'mixed',
                n = n_tweets,
                lang = 'en',
                include_rts = F)
}


# Funtion to get most trending topic in a country -------------------------

get_top_trend <- function(country) {
  get_trends(country) %>% 
    filter(tweet_volume == max(tweet_volume, na.rm = T)) %>%
    head(1) %>% 
    pull(trend)
}


