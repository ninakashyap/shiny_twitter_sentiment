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


# Helper functions --------------------------------------------------------

source('utils/rtweet_helpers.R')
source('utils/plotting_helpers.R')
source('utils/data_helpers.R')
source('utils/twitter_widget_helpers.R')
source('utils/summarybox_helpers.R')


# Variables ---------------------------------------------------------------

# Topic search bar suggestions
d_nz_trending <- get_trends('New Zealand')
nz_trending_list <- c(d_nz_trending[,'trend'], '')

# Country search bar suggestions
countries_list <- trends_available() %>% 
  filter(country != "") %>% 
  pull(country) %>% 
  unique()
countries_list <- c('Worldwide',countries_list)



