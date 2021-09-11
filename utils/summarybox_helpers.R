###############################################################################
# Helper functions for summary boxes
#
# Author: Nina Kashyap
# Created 2021-09-11 14:10:20
###############################################################################


# Function to get summary boxes for tweet wall ----------------------------

get_sentiment_summarybox <- function(df) {
  fluidRow(
    summaryBox2(
      'Total Tweets Collected', 
      nrow(df), 
      width = 3, 
      icon = "fas fa-wave-square", 
      style = "info"
    ),
    summaryBox2(
      'Total Postive Tweets', 
      get_sentiment_summary(df, 1),
      width = 3, 
      icon = "fas fa-smile-beam",
      style = "success"
    ),
    summaryBox2(
      'Total Negative Tweets', 
      get_sentiment_summary(df, -1),
      width = 3, 
      icon = "fas fa-sad-tear", 
      style = "danger"
    ),
    summaryBox2(
      'Total Neutral Tweets', 
      get_sentiment_summary(df, 0),
      width = 3, 
      icon = "fas fa-meh-blank", 
      style = "primary"
    )
  )
}



# Function to get summary boxes for trending page -------------------------

get_trending_summary <- function() {
  fluidRow(
    summaryBox2(
      "Top Trend Worldwide", 
      get_top_trend("Worldwide"), 
      width = 3, 
      icon = "fas fa-globe-asia", 
      style = "info"
    ),
    summaryBox2(
      "Top Trend NZ",
      get_top_trend("New Zealand"), 
      width = 3, 
      icon = "fas fa-kiwi-bird", 
      style = "success"
    ),
    summaryBox2(
      "Top Trend USA", 
      get_top_trend("United States"), 
      width = 3, 
      icon = "fas fa-flag-usa", 
      style = "danger"
    ),
    summaryBox2(
      "Top Trend UK", 
      get_top_trend("United Kingdom"), 
      width = 3, 
      icon = "fas fa-pound-sign", 
      style = "light")
  )
}
