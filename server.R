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
  search_term <- isolate({input$search_term})
  
  # Word count plot
  output$words_plot <- renderHighchart({
    plot_top10_words(df_tweets(), search_term)
  })
}