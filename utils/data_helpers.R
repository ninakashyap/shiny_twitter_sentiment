###############################################################################
# Functions for data cleaning and retrieval 
#
# Author: Nina Kashyap
# Created 2021-08-30 21:48:55
###############################################################################

# Libraries  --------------------------------------------------------------

# library(rtweet)
library(tidyverse)
library(tidytext)


# # Function to retrieve twitter data for search term  ----------------------
# 
# get_tweets <- function(search_word) {
#   # ONLY RETURNS DATA FROM THE PAST 6-9 DAYS
#   search_tweets(q = search_word,
#                 #type = 'popular',
#                 n = 1000,
#                 lang = 'en',
#                 include_rts = F)
# }


# Function to get word counts ------------------------------

get_wordcount_df <- function(d, search_word) {
  d %>% 
    select(text) %>% 
    # Remove http elements
    mutate(text = gsub('http\\S+', '', text)) %>% 
    # Convert to lower case, remove punctuation, convert to one col of words
    unnest_tokens(word, text) %>% 
    # Remove stop words
    anti_join(stop_words) %>% 
    # Count unique words
    count(word, sort = T) %>% 
    # Remove numbers 
    filter(!str_detect(word,"\\b\\d+\\b"),
           !str_detect(word, tolower(search_word)),
           word != tolower(search_word)) %>% 
    # Uppercase first letter
    mutate(word =  str_to_title(word))
}


# Function to get hashtag counts ------------------------------

#get_hastag_df
