# Group project for WQD7001 Principles Of Data Science
# 19/12/2017

#Group members:
# Low Cheng Kuan
# John Law Leh Ping
# Lee Joe Juan
# See Kai Jun

# Library
library(shiny)
library(shinyjs)
library(jsonlite)
library(data.table)
library(leaflet)
library(leaflet.extras)

#UI
shinyUI(
  fluidPage(
  
    headerPanel("Temperature HeatMap for cities in Malaysia"),
    sidebarPanel(
      actionButton("do", "Reload"),
      sliderInput("opacity", "Opacity",
                  min = -50., max = 50., value = c(20, 40)),
      sliderInput("blur", "Blur", 
                  min = 0, max = 100, value= 20),
      sliderInput("radian", "radian", 
                  min = 0, max = 50, value= 20)
    ),
    mainPanel(
      # Use imageOutput to place the image on the page
      leafletOutput("mymap")
    )
  )

)
