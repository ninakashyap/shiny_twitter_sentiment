###############################################################################
# Server for shiny app 
#
# Author: Nina Kashyap
# Created 2021-08-30 20:38:28
###############################################################################

# Libraries  -------------------------------------------------------------

library(shiny)
library(highcharter)

# Helper functions --------------------------------------------------------
source('utils/get_tweets.R')
source('utils/plotting_helpers.R')
source('utils/data_helpers.R')

# Server ------------------------------------------------------------------

server <- function(input, output) {
  
  # Get data 
  df_tweets <- eventReactive(input$submit_button, {get_tweets(input$search_term)})
  
  # Wordcloud
  output$wordcloud <- renderHighchart({
    plot_top_words_wordcloud(df_tweets(), isolate(input$search_term))
  })
    
  # Top hashtags plot
  output$hashtags <- renderHighchart({
    plot_top5_hashtags(df_tweets(), isolate(input$search_term))
   })
  
  # Sentiment pie chart 
  output$piechart <- renderHighchart({
    plot_sentiment_pie(df_tweets())
  })
}