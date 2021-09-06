###############################################################################
# UI for shiny app
#
# Author: Nina Kashyap
# Created 2021-08-30 20:39:17
###############################################################################


# Libraries ---------------------------------------------------------------

library(shiny)
library(highcharter)
library(bslib)
library(twitterwidget)


# UI ----------------------------------------------------------------------

ui <- fluidPage(
  # Theme
  theme = bs_theme(version = 4, bootswatch = "minty"),
  
  # Input functions
  fluidRow(
      textInput(inputId = 'search_term',
                label = 'Search tweets from the last 6-9 days:',
                #value = 'covid',
                placeholder = '#covid-19',
                width = '90%'
      ),
      actionButton(inputId = 'submit_button',
                   label = 'Submit'
      )
    
  ),
  # textInput(inputId = 'search_term',
  #           label = 'Search tweets from the last 6-9 days:',
  #           #value = 'covid',
  #           placeholder = '#covid-19'
  #           ),
  # actionButton(inputId = 'submit_button',
  #              label = 'Submit'),
  
  # Output functions 
  fluidRow(
    column(5, highchartOutput('hashtags')),
    column(3, highchartOutput('wordcloud')),
    column(4, twitterwidgetOutput('twitter', width = "100%", height = "400px"))
  ),
  fluidRow(
    column(4, highchartOutput('piechart'))
  )
)
