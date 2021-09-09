###############################################################################
# Functions for data cleaning and wrangling 
#
# Author: Nina Kashyap
# Created 2021-08-30 21:48:55
###############################################################################


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
           word != tolower(search_word),
           !(word %in% c("it's",
                         "it",
                         "its",
                         "don't",
                         "i'm")
             )
           ) %>% 
    # Uppercase first letter
    mutate(word =  str_to_title(word))
}


# Function to get hashtag counts ------------------------------

get_hashtag_count_df <- function(d, search_word) {
  d %>% 
    select(hashtags) %>% 
    unnest(cols = c(hashtags)) %>% 
    filter(!is.na(hashtags)) %>% 
    count(hashtags, sort=TRUE) %>% 
    filter(tolower(hashtags) != tolower(search_word)) %>% 
    # Add hastag prefix
    mutate(hashtags = paste('#', hashtags))
}


# Function to get polarity score for each tweet ---------------------------

get_sentiment_df <- function(d) {
  sentiment(d$text) %>% 
    filter(!is.na(word_count)) %>% 
    group_by(element_id) %>% 
    mutate(weight = word_count/sum(word_count)) %>%
    ungroup() %>% 
    mutate(sentimentxweight = sentiment * weight) %>% 
    group_by(element_id) %>% 
    summarise(sentiment = sum(sentimentxweight, na.rm = T)) %>% 
    cbind(d) %>% 
    #filter(sentiment != 0, !is.na(sentiment))  %>% 
    mutate(positive = ifelse(sentiment > 0, 1, -1),
           positive = ifelse(sentiment == 0, 0, positive))
}

# Function to get tweet wall dataset  ---------------------------

get_tweet_wall_table <- function(d) {
  d_senti <- get_sentiment_df(d)
  
  d_senti %>% 
    select(Time = created_at, 
           Username = screen_name,
           Tweet = text,
           Retweets = retweet_count, 
           Favorites = favorite_count,
           `Polarity Score` = sentiment)
}

