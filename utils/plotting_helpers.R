###############################################################################
# Plotting helper functions 
#
# Author: Nina Kashyap
# Created 2021-08-30 21:38:57
###############################################################################


# Libraries ---------------------------------------------------------------

library(tidyverse)
library(highcharter)


# Helper functions  -------------------------------------------------------

source('utils/data_helpers.R')


# Function to plot top 10 most common words  -----------------------------------

plot_top10_words <- function(df, search_word) {
  
  # Get dataset in correct form
  df_clean <- get_wordcount_df(df, search_word)
  
  # Plot
  df_clean %>% 
    head(10) %>% 
    hchart('bar',
           hcaes(x = word, y = n),
           name = 'Frequency'
    ) %>% 
    hc_title(text = paste("Top 10 Words In Recent Tweets About ", str_to_title(search_word))) %>% 
    hc_xAxis(title = list(text = "Word")) %>% 
    hc_yAxis(title = list(text = "Frequency")) 
  
}


# Function to generate word cloud for top words ---------------------------

plot_top_words_wordcloud <- function(df, search_word) {
  
  # Get dataset in correct form
  df_clean <- get_wordcount_df(df, search_word)
  
  # Plot
  print('Plotting wordcloud')
  df_clean %>% 
    head(50) %>% 
    hchart("wordcloud", 
           hcaes(name = word, weight = n),
           name = 'Frequency') %>% 
    hc_title(text = paste("Top Words In Recent Tweets About ", str_to_title(search_word)))
  
}


# Function to plot top 5 most common hastags  -----------------------------------

plot_top5_hashtags <- function(df, search_word) {
  
  # Get dataset in correct form
  df_clean <- get_hashtag_count_df(df, search_word)
  
  # Plot
  df_clean %>% 
    head(5) %>% 
    hchart('bar',
           hcaes(x = hashtags, y = n),
           name = 'Frequency'
    ) %>% 
    hc_title(text = paste("Top 5 Hashtags In Recent Tweets About ", str_to_title(search_word))) %>% 
    hc_xAxis(title = list(text = "Hashtag")) %>% 
    hc_yAxis(title = list(text = "Frequency")) 
  
}


# Function to plot sentiment pie chart ------------------------------------

plot_sentiment_pie <- function(df) {
  
  # Get dataset in correct form
  df_clean <- get_sentiment_df(df)
  
  # Plot
  df_clean %>% 
    count(positive) %>% 
    mutate(positive = ifelse(positive == 1,"Positive Tweets","Negative Tweets"))%>% 
    hchart("pie", 
           hcaes(x = positive, y = n),
           name = "Number Of Tweets") %>% 
    hc_plotOptions(
      pie = list(colors = c("#E5E5E5", "#DE1219"))
    )
  
}



  
  

