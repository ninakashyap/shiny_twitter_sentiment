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
  iv <- InputValidator$new()
  iv$add_rule("n_tweets", sv_between(100, 10000))
  iv$enable()
  
  # Get data 
  df_tweets <- eventReactive(input$submit_button, {get_tweets(input$search_term, input$n_tweets) })
    
  # Refresh the `twitter_output` div
  observeEvent(df_tweets(), {
    shinyjs::js$refresh()
    shinyjs::js$refresh1()
    shinyjs::js$refresh2()
  })
  
  # Enable download buttons
  observeEvent(input$submit_button, {
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
  
  output$wordcloud_box <- renderUI({
    
    if (is.null(df_tweets())) {
      return()
    }
    
    box(
      title = paste("Top Words In Recent Tweets About ", str_to_title(isolate(input$search_term))), 
      status = "primary", 
      solidHeader = TRUE,
      collapsible = TRUE, 
      highchartOutput('wordcloud')
    )
    
  })
  
  
  # Top hashtags plot
  output$hashtags <- renderHighchart({
    plot_top5_hashtags(df_tweets(), isolate(input$search_term))
   })
  
  output$hashtags_box <- renderUI({
    
    if (is.null(df_tweets())) {
      return()
    }
    
    box(
      title = paste("Top 5 Hashtags In Recent Tweets About ", str_to_title(isolate(input$search_term))), 
      status = "primary", 
      solidHeader = TRUE,
      collapsible = TRUE, 
      highchartOutput('hashtags')
    )
    
  })
  
  # Top tweet
  output$top_tweet <- renderTwitterwidget({
    get_top_tweet_widget(df_tweets())
  })
  
  output$top_tweet_box <- renderUI({
    
    if (is.null(df_tweets())) {
      return()
    }
    
    box(
      title = paste("Most Populat Tweet About ", str_to_title(isolate(input$search_term))),
      status = "primary", 
      solidHeader = TRUE,
      collapsible = TRUE, 
      twitterwidgetOutput('top_tweet', width = "100%", height = "400px")
    )
    
  })
  
  # Sentiment pie chart 
  output$piechart <- renderHighchart({
    plot_sentiment_pie(df_tweets())
  })
  
  output$piechart_box <- renderUI({
    
    if (is.null(df_tweets())) {
      return()
    }
    
    box(
      title = "Number Of Postive, Negative And Neutral Tweets", 
      status = "primary", 
      solidHeader = TRUE,
      collapsible = TRUE, 
      highchartOutput('piechart')
    )
    
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
    get_trending_plot(input$location)
  })
}