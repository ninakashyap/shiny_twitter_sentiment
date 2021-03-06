###############################################################################
# Plotting helper functions 
#
# Author: Nina Kashyap
# Created 2021-08-30 21:38:57
###############################################################################


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
    hc_yAxis(title = list(text = "Tweet Volume")) 
  
}


# Function to generate word cloud for top words ---------------------------

plot_top_words_wordcloud <- function(df, search_word) {
  
  # Get dataset in correct form
  df_clean <- get_wordcount_df(df, search_word)
  
  # Plot
  df_clean %>% 
    head(50) %>% 
    hchart("wordcloud", 
           hcaes(name = word, weight = log(n)),
           name = 'Log Tweet Volume')
  
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
    hc_xAxis(title = list(text = "Hashtag")) %>% 
    hc_yAxis(title = list(text = "Tweet Volume")) %>% 
    hc_colors(c('#5DA9DD'))
  
}


# Function to plot sentiment pie chart ------------------------------------

plot_sentiment_pie <- function(df) {
  
  # Get dataset in correct form
  df_clean <- get_sentiment_df(df)
  
  # Plot
  df_clean %>% 
    count(positive) %>% 
    mutate(positive_name = ifelse(positive == 1,"Positive Tweets","Negative Tweets"),
           positive_name = ifelse(positive == 0,"Neutral Tweets", positive_name)) %>% 
    hchart("pie", 
           hcaes(x = positive_name, y = n),
           name = "Tweet Volume") #%>% 
    # hc_plotOptions(
    #   pie = list(colors = c("#E5E5E5",
    #                         #"#DE1219",
    #                         '#5DA9DD'))
    # )
  
}


# Function to generate sentiment density plot -----------------------------

plot_sentiment_density <- function(df) {
  # Get dataset in correct form
  df_clean <- get_sentiment_df(df) %>% 
    pull(sentiment)
  
  # Plot
  hchart(density(df_clean), 
         type = "area", 
         #color = "#B71C1C", 
         name = "Density")  %>% 
    hc_title(text = "Distribution Of Sentiment In Tweets") %>% 
    hc_xAxis(title = list(text = "Polarity Score"),
             plotLines = list(
               list(value = 0, 
                    color = "red", 
                    width = 1,
                    dashStyle = "shortdash")
             )) 
  
}


# Trending plot  ----------------------------------------------------------

get_trending_plot <- function(country) {
  get_trends(country) %>% 
    select(trend, tweet_volume) %>% 
    filter(!is.na(tweet_volume)) %>% 
    hchart('column',
           color = '#1DBB9C',
           hcaes(y = tweet_volume,x = trend),
           name = 'Tweet Volume'
    ) %>% 
    hc_title(text = paste("Trending In ", country)) %>% 
    hc_xAxis(title = list(text = "Topic")) %>% 
    hc_yAxis(title = list(text = "Tweet Volume"))
}




  
  

