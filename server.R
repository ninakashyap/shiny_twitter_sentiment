###############################################################################
# Server for shiny app 
#
# Author: Nina Kashyap
# Created 2021-08-30 20:38:28
###############################################################################

# Libraries  -------------------------------------------------------------

library(shiny)
library(highcharter)
library(twitterwidget)
library(shinyjs)
library(DT)

# Helper functions --------------------------------------------------------
source('utils/get_tweets.R')
source('utils/plotting_helpers.R')
source('utils/data_helpers.R')
source('utils/twitter_widget_helpers.R')

# Server ------------------------------------------------------------------

server <- function(input, output) {
  
  # Title
  rv <- reactiveVal('...')
  
  observeEvent(input$submit_button, {
    rv(isolate(input$search_term))
  })
  
  output$text_header <- renderText({
    # h3(
      paste('How The World Feels About', rv(), 'Right Now')
      # ,align = 'center'
      #  )
  })
  
  # Get data 
  
  df_tweets <- eventReactive(input$submit_button, {get_tweets(input$search_term, input$n_tweets) })
    
  # Refresh the `twitter_output` div
  observeEvent(df_tweets(), {
    shinyjs::js$refresh()
    shinyjs::js$refresh1()
    shinyjs::js$refresh2()
  })
  
  # Downloadable csv of selected dataset 
  observeEvent(input$submit_button, {
    enable('downloadData')
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(isolate(input$search_term), '.csv', sep = '')
    },
    content = function(file) {
      write_csv(df_tweets(), file)
    }
  )
  
  # Summary tab
  
  # Wordcloud
  output$wordcloud <- renderHighchart({
    plot_top_words_wordcloud(df_tweets(), isolate(input$search_term))
  })
  
  # Top hashtags plot
  output$hashtags <- renderHighchart({
    plot_top5_hashtags(df_tweets(), isolate(input$search_term))
   })
  
  # Top tweet
  output$top_tweet <- renderTwitterwidget({
    get_top_tweet_widget(df_tweets())
  })
  
  # Sentiment pie chart 
  output$piechart <- renderHighchart({
    plot_sentiment_pie(df_tweets())
  })
  
  # Twitter Tab
  
  # Most postitive tweet
  output$positive_tweet <- renderTwitterwidget({
    get_positive_tweet_widget(df_tweets())
  })
  
  # Most negative tweet
  output$negative_tweet <- renderTwitterwidget({
    get_negative_tweet_widget(df_tweets())
  })
  
  # Density plot
  output$sentiment_density <- renderHighchart({
    plot_sentiment_density(df_tweets())
  })
  
  # Tweet table
  output$tweet_table = renderDataTable({
    get_tweet_wall_table(df_tweets())
  })
}