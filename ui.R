###############################################################################
# UI for shiny app
#
# Author: Nina Kashyap
# Created 2021-08-30 20:39:17
###############################################################################


# Libraries ---------------------------------------------------------------

library(shiny)
library(highcharter)
library(twitterwidget)
library(shinyjs)
library(shinydashboard)
library(dashboardthemes)

# UI ----------------------------------------------------------------------

ui <- dashboardPage(

  # Title 
  dashboardHeader(title = uiOutput('text_header'),
                  titleWidth = 500
                  ),

  # Sidebar 
  dashboardSidebar(
    sidebarMenu(
      menuItem("Summary Dashboard", tabName = "summary_tab", icon = icon("chart-bar")),
      menuItem("Tweet Wall", tabName = "twitter_tab", icon = icon("twitter"))
    )
  ),
  
  # Body
  dashboardBody(
    useShinyjs(),
    
    # Refresh 3 tweet widgets
    extendShinyjs(
      text = "shinyjs.refresh = function() {
      var div = document.getElementById('top_tweet');
      while(div.firstChild){
      div.removeChild(div.firstChild);
      }
      }",
    functions = c("refresh")
    ),
    extendShinyjs(
      text = "shinyjs.refresh1 = function() {
      var div = document.getElementById('negative_tweet');
      while(div.firstChild){
      div.removeChild(div.firstChild);
      }
      }",
    functions = c("refresh1")
    ),
    extendShinyjs(
      text = "shinyjs.refresh2 = function() {
      var div = document.getElementById('positive_tweet');
      while(div.firstChild){
      div.removeChild(div.firstChild);
      }
      }",
    functions = c("refresh2")
    ),
    
    # Theme
    shinyDashboardThemes(
      theme = "poor_mans_flatly"
    ),

    # # CSS
    # tags$style(type="text/css", "
    #            #loadmessage {
    #            position: fixed;
    #            top: 500px;
    #            left: 0px;
    #            width: 100%;
    #            padding: 5px 0px 5px 0px;
    #            text-align: center;
    #            font-weight: bold;
    #            font-size: 100%;
    #            color: #000000;
    #            background-color: #EF7579;
    #            z-index: 105;
    #            }
    #            "),
  
    tabItems(
      
      # Summary dashboard
      tabItem(
        tabName = "summary_tab",
        # Input functions
        wellPanel(
          fluidRow(
            # Search bar
            textInput(inputId = 'search_term',
                      label = 'Search tweets from the last 6-9 days:',
                      placeholder = '#covid-19',
                      width = '50%'
            ),
            # Number of tweets
            numericInput(
              inputId = 'n_tweets',
              label = 'Number of tweets (up to 15,000)',
              value = 1000,
              min = 1,
              max = 10000,
              width = '20%'
            )),
          fluidRow(
            # Submitt button 
            actionButton(inputId = 'submit_button',
                         label = 'Submit'
            ),
            # Downlaod button
            disabled(downloadButton('downloadData', 'Download Data'))
          )
        ),
        
        # # Loading panel
        # conditionalPanel(condition = "$('html').hasClass('shiny-busy')",
        #                  tags$div("Loading...", id = "loadmessage")
        #                  ),
        
        # Output functions 
        fluidRow(
          column(6, highchartOutput('hashtags')),
          column(6, highchartOutput('wordcloud'))
          ),
      
        fluidRow(
          column(6, highchartOutput('piechart')),
          column(6, twitterwidgetOutput('top_tweet', width = "100%", height = "400px"))
          )
      ),
      
    # Tweet wall
    tabItem(
      tabName = "twitter_tab",
      h2("Widgets tab content"),

      # Ouput functions

      # Top tweets
      fluidRow(
        column(4, twitterwidgetOutput('positive_tweet')),
        column(4, twitterwidgetOutput('negative_tweet'))
      )

      # Browse tweets
      )
    )
  )
)
