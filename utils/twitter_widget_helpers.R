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
    pull(status_id)
  
  twitterwidget(tweet_id)
}
