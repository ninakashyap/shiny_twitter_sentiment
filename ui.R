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
      menuItem("Tweet Wall", tabName = "twitter_tab", icon = icon("twitter")),
      menuItem("Search Inspiration", tabName = "trending_tab", icon = icon("globe-asia"))
    )
  ),
  
  # Body
  dashboardBody(
    useShinyjs(),
    
    tags$style(HTML(".box.box-solid.box-primary>.box-header {}
                    .box.box-solid.box-primary{background:#FFFFFF}"
                    )
               ),
    
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
              selected = '#covid',
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
              label = 'Number of tweets (up to 10,000)',
              value = 1000,
              min = 100,
              max = 10000,
              width = '20%'
            )),
          fluidRow(
            # Submitt button 
            actionButton(inputId = 'submit_button',
                         label = 'Submit'
            ),
            # Downlaod button
            disabled(downloadButton('download_raw_data', 'Download Raw Data'))
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
        
        # Display after submit 
        conditionalPanel(
          # If submit button has been pressed
          condition = "input.submit_button != 0",
          
          # Plots
          fluidRow(
            uiOutput("hashtags_box"),
            uiOutput("wordcloud_box")
            ),
        
          fluidRow(
            uiOutput("piechart_box"),
            box(
              title = "Most Popular Tweet",
              status = "primary", 
              solidHeader = TRUE,
              collapsible = TRUE, 
              # Scroll box
              div(
                  style='width:600px;overflow-x: scroll;height:400px;overflow-y: scroll;',
                  twitterwidgetOutput('top_tweet', width = "100%", height = "400px")
              )
            )
          )
        )
      ),
      
    # Trending tab
    tabItem(
      tabName = 'trending_tab',
      
      # Summary boxes
      uiOutput("summarybox_trending_tab"),
      
      # Pick a location
      selectInput(
        inputId = "location", 
        label = "Explore Popular Topics In:",
        selected = "Worldwide",
        choices = countries_list
        ),
      
      # Trending plot
      fluidRow(
        highchartOutput('trending_tab_plot')
      )
    ),
      
    # Tweet wall
    tabItem(
      tabName = "twitter_tab",
      
      # Display if page is empty 
      conditionalPanel(
        # If no input
        condition="input.search_term == ''",
        # Ask for input
        h1("Enter a search term on the Summary Dashboard to populate the tweet wall")
      ),

      # Ouput functions
      
      # Summary boxes
      uiOutput("summarybox_sentiment"),

      # Top tweets
      conditionalPanel(
        # If submit button has been pressed
        condition = "input.submit_button != 0",
        
        # Display tweets
        fluidRow(
          box(
            title = "Most Positive Tweet",
            status = "primary", 
            solidHeader = TRUE,
            collapsible = TRUE, 
            width = 4,
            # Scroll box
            div(
              style='width:350px;overflow-x: scroll;height:400px;overflow-y: scroll;',
              twitterwidgetOutput('positive_tweet', width = '350px')
            )
          ),
          box(
            title = "Most Negative Tweet",
            status = "primary", 
            solidHeader = TRUE,
            collapsible = TRUE, 
            width = 4,
            # Scroll box
            div(
              style='width:350px;overflow-x: scroll;height:400px;overflow-y: scroll;',
              twitterwidgetOutput('negative_tweet', width = '350px')
            )
          ),
          box(
            title = "Distribution Of Sentiment In Tweets",
            status = "primary", 
            solidHeader = TRUE,
            collapsible = TRUE, 
            width = 4,
            highchartOutput('sentiment_density')
          )
        )
      ),
      
      # Browse tweets
      fluidRow(
        dataTableOutput('tweet_table')
      ),
      
      # Downlaod button
      fluidRow(
        column(
          1,
          disabled(downloadButton('download_sentiment_data', 'Download Data')),
          offset = 10
        )
      )
      )
    )
  )
)
