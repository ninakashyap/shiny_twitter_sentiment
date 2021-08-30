###############################################################################
# UI for shiny app
#
# Author: Nina Kashyap
# Created 2021-08-30 20:39:17
###############################################################################

ui <- fluidPage(
  # Input functions
  sliderInput(inputId = 'num',
              label = 'Choose a num',
              value = 5,
              min = 1,
              max = 100
              ),
  # Output functions 
  plotOutput('hist')
)
