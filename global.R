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


# Helper functions --------------------------------------------------------

source('utils/get_tweets.R')
source('utils/plotting_helpers.R')
source('utils/data_helpers.R')
source('utils/twitter_widget_helpers.R')
