###############################################################################
# UI for shiny app
#
# Author: Nina Kashyap
# Created 2021-08-30 20:39:17
###############################################################################

ui <- dashboardPage(
  
  # Browser title
  title = 'Twitter Sentiment Analysis',

  # Dashboard title  
  dashboardHeader(
    title = uiOutput('text_header'),
    titleWidth = 500
  ),

  # Sidebar tabs
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
    
    # Make box backgrounds whitw
    tags$style(
            HTML(
                  ".box.box-solid.box-primary>.box-header {}
                  .box.box-solid.box-primary{background:#FFFFFF}"
            )
    ),
    
    # Fade screen when loading
    tags$body(tags$style(type="text/css", "
             #loading  {
                        content: '';
                        position: fixed;
                        height: 100%;
                        width: 100%;
                        left: 0;
                        top: 0;
                        z-index: 2;
                        background: rgba(255, 255, 255, 0.5);  
                         }
                         ")
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
        
        # Fade screen when loading
        conditionalPanel(
          condition="$('html').hasClass('shiny-busy')",
          tags$div("Loading...",id="loading")
        ),

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
              label = 'Number of tweets (up to 10,000)',
              value = 100,
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
          uiOutput("summarybox_trending"),
         
           # Padding
           fluidRow(
             column(width = 6, offset = 0, style='padding:10px;')
           ),
           
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
            box(
              title = "Top Words", 
              status = "primary", 
              solidHeader = TRUE,
              collapsible = TRUE, 
              highchartOutput('wordcloud')
            ),
            box(
              title = "Top 5 Hashtags", 
              status = "primary", 
              solidHeader = TRUE,
              collapsible = TRUE, 
              highchartOutput('hashtags')
            )
          ),
        
          fluidRow(
            box(
              title = "Number Of Postive, Negative And Neutral Tweets", 
              status = "primary", 
              solidHeader = TRUE,
              collapsible = TRUE, 
              highchartOutput('piechart')
            ),
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
      
      # Padding
      fluidRow(
        column(width = 6, offset = 0, style='padding:10px;')
      ),
      
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
        condition="input.submit_button == 0",
        # Ask for input
        h3("Enter a search term on the Summary Dashboard to populate the tweet wall")
      ),
      
      # Fade screen when loading
      conditionalPanel(
        condition="$('html').hasClass('shiny-busy')",
        tags$div("Loading...",id="loading")
      ),

      # Ouput functions
      
      # Summary boxes
      uiOutput("summarybox_sentiment"),
      
      # Padding
      fluidRow(
        column(width = 6, offset = 0, style='padding:10px;')
      ),

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
      
      # Padding
      fluidRow(
        column(width = 6, offset = 0, style='padding:10px;')
      ),
      
      # Browse tweets
      fluidRow(
        dataTableOutput('tweet_table')
      ),
      
      # Padding
      fluidRow(
        column(width = 6, offset = 0, style='padding:10px;')
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
