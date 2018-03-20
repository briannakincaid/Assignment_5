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
library(ggplot2)
library(lubridate)

yr1985 <- read_table2("46035 Data/46035h1985.txt", skip = 1, col_names = names[-5][-17])
yr1986 <- read_table2("46035 Data/46035h1986.txt", skip = 1, col_names = names[-5][-17])
yr1987 <- read_table2("46035 Data/46035h1987.txt", skip = 1, col_names = names[-5][-17])
yr1988 <- read_table2("46035 Data/46035h1988.txt", skip = 1, col_names = names[-5][-17])
yr1989 <- read_table2("46035 Data/46035h1989.txt", skip = 1, col_names = names[-5][-17])
yr1990 <- read_table2("46035 Data/46035h1990.txt", skip = 1, col_names = names[-5][-17])
yr1991 <- read_table2("46035 Data/46035h1991.txt", skip = 1, col_names = names[-5][-17])
yr1992 <- read_table2("46035 Data/46035h1992.txt", skip = 1, col_names = names[-5][-17])
yr1993 <- read_table2("46035 Data/46035h1993.txt", skip = 1, col_names = names[-5][-17])
yr1994 <- read_table2("46035 Data/46035h1994.txt", skip = 1, col_names = names[-5][-17])
yr1995 <- read_table2("46035 Data/46035h1995.txt", skip = 1, col_names = names[-5][-17])
yr1996 <- read_table2("46035 Data/46035h1996.txt", skip = 1, col_names = names[-5][-17])
yr1997 <- read_table2("46035 Data/46035h1997.txt", skip = 1, col_names = names[-5][-17])
yr1998 <- read_table2("46035 Data/46035h1998.txt", skip = 1, col_names = names[-5][-17])
yr1999 <- read_table2("46035 Data/46035h1999.txt", skip = 1, col_names = names[-5][-17])


#added tide measurement in 2000
yr2000 <- read_table2("46035 Data/46035h2000.txt", skip = 2, col_names = names[-5])[,-17]
#this gives a warning message because there is no data for tide until part of the way through 2000, so the row length changes 
yr2001 <- read_table2("46035 Data/46035h2001.txt", skip = 1, col_names = names[-5])[,-17]
yr2002 <- read_table2("46035 Data/46035h2002.txt", skip = 1, col_names = names[-5])[,-17]
yr2003 <- read_table2("46035 Data/46035h2003.txt", skip = 1, col_names = names[-5])[,-17]
yr2004 <- read_table2("46035 Data/46035h2004.txt", skip = 1, col_names = names[-5])[,-17]


#added minute measurement in 2005
yr2005 <- read_table2("46035 Data/46035h2005.txt", skip = 1, col_names = names)[,-18][,-5]
yr2006 <- read_table2("46035 Data/46035h2006.txt", skip = 1, col_names = names)[,-18][,-5]
yr2007 <- read_table2("46035 Data/46035h2007.txt", skip = 2, col_names = names)[,-18][,-5]
yr2008 <- read_table2("46035 Data/46035h2008.txt", skip = 2, col_names = names)[,-18][,-5]
yr2009 <- read_table2("46035 Data/46035h2009.txt", skip = 2, col_names = names)[,-18][,-5]
yr2010 <- read_table2("46035 Data/46035h2010.txt", skip = 2, col_names = names)[,-18][,-5]
yr2011 <- read_table2("46035 Data/46035h2011.txt", skip = 2, col_names = names)[,-18][,-5]
yr2012 <- read_table2("46035 Data/46035h2012.txt", skip = 2, col_names = names)[,-18][,-5]
yr2014 <- read_table2("46035 Data/46035h2014.txt", skip = 2, col_names = names)[,-18][,-5]
yr2015 <- read_table2("46035 Data/46035h2015.txt", skip = 2, col_names = names)[,-18][,-5]
yr2016 <- read_table2("46035 Data/46035h2016.txt", skip = 2, col_names = names)[,-18][,-5]
yr2017 <- read_table2("46035 Data/46035h2017.txt", skip = 2, col_names = names)[,-18][,-5]

allyears <- rbind(yr1985,yr1986, yr1987, yr1988, yr1989, yr1990, yr1991, yr1992, yr1993, yr1994, yr1995, yr1996, yr1997, yr1998, yr1999, yr2000, yr2001, yr2002, yr2003, yr2004, yr2005, yr2006, yr2007, yr2008, yr2009, yr2010, yr2011, yr2012, yr2014, yr2015, yr2016, yr2017)

# Define UI for application that draws various graphs.
ui <- dashboardPage(
  dashboardHeader(
    title = "Buoy 46035 Data",
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
