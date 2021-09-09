###############################################################################
# Functions to generate twitter widgets
#
# Author: Nina Kashyap
# Created 2021-09-02 21:21:35
###############################################################################


# Libraries ---------------------------------------------------------------

library(twitterwidget)
library(tidyverse)

# Helper functions  -------------------------------------------------------

source('utils/data_helpers.R')

# Function to get most positive tweet -------------------------------------

get_positive_tweet_widget <- function(df) {
  df_sentiment <- get_sentiment_df(df)
  
  tweet_id <- df_sentiment %>% 
    filter(sentiment == max(sentiment)) %>% 
    head(1) %>% 
    pull(status_id)
  
  twitterwidget(tweet_id)
}

# Function to get top tweet -------------------------------------

get_top_tweet_widget <- function(df) {

  tweet_id <- df %>% 
    mutate(popularity = sum(favorite_count, retweet_count, quote_count, reply_count, na.rm = T)) %>% 
    filter(popularity == max(popularity)) %>% 
    head(1) %>% 
    pull(status_id)
  
  twitterwidget(tweet_id)
}

# Function to get most negative tweet -------------------------------------

get_negative_tweet_widget <- function(df) {
  df_sentiment <- get_sentiment_df(df)
  
  tweet_id <- df_sentiment %>% 
    filter(sentiment == min(sentiment)) %>% 
    head(1) %>% 
    pull(status_id)
  
  twitterwidget(tweet_id)
}
