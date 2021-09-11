###############################################################################
# UI for shiny app
#
# Author: Nina Kashyap
# Created 2021-08-30 20:39:17
###############################################################################

ui <- dashboardPage(

  # Title 
  dashboardHeader(
    title = uiOutput('text_header'),
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
    
    # Loading spinner
    add_busy_spinner(
      spin = "fingerprint", 
      position = "bottom-right"
    ),
  
    # Tabs
    tabItems(
      
      # Summary dashboard
      tabItem(
        tabName = "summary_tab",
        # Input functions
        wellPanel(
          fluidRow(
            # Search bar
            selectizeInput(
              inputId = 'search_term',
              label = 'Search tweets from the last 6-9 days:',
              selected = '',
              choices = nz_trending_list,
              multiple = F,
              options = list(
                placeholder = '#covid',
                createOnBlur = T,
                create = T
                )
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
            disabled(downloadButton('downloadData', 'Download Raw Data'))
          )
        ),
        
        # Display if page is empty 
        conditionalPanel(
          # If no input
          condition = "input.submit_button == 0",
          
          # Show trending stats
         # fluidRow(
         #   h3("Search Inspiration:")
         # ),
         uiOutput("summarybox_trending"),
         
         # NZ trending plot
          fluidRow(
            highchartOutput('trending_plot')
          )
        ),
        
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
      #h2("Widgets tab content"),

      # Ouput functions
      
      # Summary boxes
      uiOutput("summarybox_sentiment"),

      # Top tweets
      fluidRow(
        column(4, twitterwidgetOutput('positive_tweet')),
        column(4, twitterwidgetOutput('negative_tweet')),
        column(4, highchartOutput('sentiment_density'))
      ),
      
      # Browse tweets
      fluidRow(
        dataTableOutput('tweet_table')
      )
      )
    )
  )
)
