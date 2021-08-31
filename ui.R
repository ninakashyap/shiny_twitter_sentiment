###############################################################################
# UI for shiny app
#
# Author: Nina Kashyap
# Created 2021-08-30 20:39:17
###############################################################################


# Libraries ---------------------------------------------------------------

library(shiny)
library(highcharter)


# UI ----------------------------------------------------------------------

ui <- fluidPage(
  # Input functions
  textInput(inputId = 'search_term',
            label = 'Search a topic',
            #value = 'covid',
            placeholder = '#covid-19'
            ),
  actionButton(inputId = 'submit_button',
               label = 'Submit'),
  # Output functions 
  highchartOutput('wordcloud'),
  highchartOutput('hashtags'),
  highchartOutput('piechart')
)
