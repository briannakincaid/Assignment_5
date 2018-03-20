#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

library(tidyverse)
library(readxl)
library(stringr)

## READ
veg.1 <- read_xlsx("veg1.xlsx", na = "(D)")
#D = Withheld to avoid  disclosing data for individual  operations. = NA 
names <- colnames(veg.1)

# Define UI for application that draws various graphs.
ui <- dashboardPage(
  dashboardHeader(
    title = "Vegetable Data",
    titleWidth = 350
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Charts", icon = icon("bar-chart-o"))
    )
  ),
  dashboardBody(
    
    fluidRow(
      box(
        sliderInput("bins",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 30)
      ),
      box(
        plotOutput("noonAirTemp")
      )
    ),
    fluidRow(
      box(
        sliderInput("bins",
                    "Number of bins:",
                    min = 1,
                    max = 50,
                    value = 30)
      ),
      box(
        plotOutput("noonWaterTemp")
      )
    )
  )
)
# Define server logic required to draw the various graphs.
server <- function(input, output) {
  set.seed(300)
  allyears_noon <- rnorm(500)
  output$noonAirTemp <- renderPlot({
    x    <- allyears_noon[13]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, xlim = c(-13, 13), ylim = c(0,200), col = 'darkgray', border = 'white', plot = TRUE)
    
  })
  output$noonWaterTemp <- renderPlot({
    x    <- allyears_noon[14]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, xlim = c(0, 13), ylim = c(0,300), col = 'darkgray', border = 'white', plot = TRUE)
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)