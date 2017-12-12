# Group project for WQD7001 Principles Of Data Science
# 19/12/2017

#Group members:
# Low Cheng Kuan
# John Law Leh Ping
# Lee Joe Juan
# See Kai Jun

# Library
library(shiny)
library(jsonlite)
library(data.table)
library(leaflet)
library(leaflet.extras)

#UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Temperature HeatMap for cities in Malaysia"),
  leafletOutput("mymap"),
  actionButton("do", "Reload")
  
))
