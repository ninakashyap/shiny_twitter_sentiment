###############################################################################
# Server for shiny app 
#
# Author: Nina Kashyap
# Created 2021-08-30 20:38:28
###############################################################################


server <- function(input, output) {
  
  # Title
  rv <- reactiveVal('...')
  
  observeEvent(input$submit_button, {
    rv(isolate(input$search_term))
  })
  
  output$text_header <- renderText({
      paste('How The World Feels About', rv(), 'Right Now')
  })
  
  # Check if input is valid
  iv_n_tweets <- InputValidator$new()
  iv_n_tweets$add_rule("n_tweets", sv_between(100, 10000))
  iv_n_tweets$enable()
  
  # Get data 
  df_tweets <- eventReactive(input$submit_button, {
    
    # Disable download button if empty search term
    if (input$search_term == '') {
      disable('download_raw_data')
      disable('download_sentiment_data')
    }
    
    # Check not an empty search term
    validate(
      need(
        input$search_term != "", 
        paste(
          "Please enter a search term ",
          ji("search"))
        )
    )
    
    # Disable download button if empty dataset 
    d <- get_tweets(input$search_term, input$n_tweets) 
    
    if (nrow(d) == 0){
      disable('download_raw_data')
      disable('download_sentiment_data')
    }
    
    # Check not empty dataset
    validate(
      need(
        nrow(d) != 0, 
        paste(
          "No results available ",
          ji("shrug"))
      )
    )
    
    d
    })

    
  # Refresh the `twitter_output` div
  observeEvent(df_tweets(), {
    shinyjs::js$refresh()
    shinyjs::js$refresh1()
    shinyjs::js$refresh2()
  })
  
  # Enable download buttons
  observeEvent(df_tweets(), {
    enable('download_raw_data')
    enable('download_sentiment_data')
  })
  
  # Downloadable csv of raw dataset 
  output$download_raw_data <- downloadHandler(
    filename = function() {
      paste(isolate(input$search_term), '.csv', sep = '')
    },
    content = function(file) {
      write_csv(df_tweets(), file)
    }
  )
  
  # Downloadable csv of sentiment dataset 
  output$download_sentiment_data <- downloadHandler(
    filename = function() {
      paste(isolate(input$search_term), '_sentiment', '.csv', sep = '')
    },
    content = function(file) {
      write_csv(get_tweet_wall_table(df_tweets()), file)
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
  
  # Sentiment summary boxes 
  output$summarybox_sentiment <- renderUI({
    get_sentiment_summarybox(df_tweets())
  })
  
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
  
  # Trending tab
  
  # Trending summary boxes 
  output$summarybox_trending <- renderUI({
    get_trending_summary()
  })
  
  # Inital trending plot 
  output$trending_plot = renderHighchart({
    get_trending_plot('New Zealand')
  })
  
  # Trending summary boxes 
  output$summarybox_trending_tab <- renderUI({
    get_trending_summary()
  })
  
  # Location trending plot 
  output$trending_tab_plot = renderHighchart({
    validate(
      need(
        try(get_trending_plot(input$location)), 
        paste(
          "  Currently Unavailable ",
          ji("sad"),
          " Please choose another location! ",
          ji("earth")
          )
        )
    )
    get_trending_plot(input$location)
  })
}