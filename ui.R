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
  
  # CSS
  tags$style(type="text/css", "
           #loadmessage {
             position: fixed;
             top: 0px;
             left: 0px;
             width: 100%;
             padding: 5px 0px 5px 0px;
             text-align: center;
             font-weight: bold;
             font-size: 100%;
             color: #000000;
             background-color: #EF7579;
             z-index: 105;
             }
             "),
  
  # Theme
  theme = bs_theme(version = 4, bootswatch = "minty"),
  
  # Title
  uiOutput('text_header'),
  
  # Input functions
  wellPanel(
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
  
  # Loading panel
  conditionalPanel(condition="$('html').hasClass('shiny-busy')",
                   tags$div("Loading...",id="loadmessage")
                   ),
  
  # Output functions 
  fluidRow(
    column(6, highchartOutput('hashtags')),
    column(6, highchartOutput('wordcloud'))
    ),

  fluidRow(
    column(4, highchartOutput('piechart')),
    column(4, twitterwidgetOutput('twitter', width = "100%", height = "400px"))
    )
)
