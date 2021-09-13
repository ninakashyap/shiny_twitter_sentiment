###############################################################################
# Entrypoint for the shiny app
#
# Author: Nina Kashyap
# Created 2021-09-09 18:46:28
###############################################################################


# Libraries ---------------------------------------------------------------

library(shiny)
library(shinyjs)
library(shinydashboard)
library(shinyvalidate)
library(dashboardthemes)
library(shinybusy)
library(rtweet)
library(twitterwidget)
library(tidytext)
library(sentimentr)
library(tidyverse)
library(DT)
library(highcharter)
library(summaryBox)


# Token -------------------------------------------------------------------

source('credentials.R')

token <- create_token(
  app = "shiny_twitter_sentiment",
  API_KEY,
  API_KEY_SECRET,
  access_token = ACCESS_TOKEN,
  access_secret = ACCESS_TOKEN_SECRET,
  set_renv = TRUE
)

token <- get_tokens()


# Helper functions --------------------------------------------------------

source('utils/rtweet_helpers.R')
source('utils/plotting_helpers.R')
source('utils/data_helpers.R')
source('utils/twitter_widget_helpers.R')
source('utils/summarybox_helpers.R')


# Variables ---------------------------------------------------------------

# Topic search bar suggestions
d_nz_trending <- get_trends('New Zealand')
nz_trending_list <- c(d_nz_trending[,'trend'], '#covid')

# Country search bar suggestions
countries_list <- trends_available() %>% 
  filter(country != "") %>% 
  pull(country) %>% 
  unique()
countries_list <- c('Worldwide',countries_list)



