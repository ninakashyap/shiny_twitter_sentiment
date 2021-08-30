###############################################################################
# Server for shiny app 
#
# Author: Nina Kashyap
# Created 2021-08-30 20:38:28
###############################################################################

server <- function(input, output) {
  output$hist <- renderPlot({
    hist(rnorm(input$num))
  })
}