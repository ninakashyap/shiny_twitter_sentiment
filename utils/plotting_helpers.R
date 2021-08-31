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



  
  

