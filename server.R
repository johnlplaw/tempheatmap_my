# Group project for WQD7001 Principles Of Data Science
# 19/12/2017

#Group members:
# Low Cheng Kuan
# John Law Leh Ping (WQD170020)
# Lee Joe Juan
# See Kai Jun (WQD170008)

# Library
library(shiny)
library(curl)
library(jsonlite)
library(data.table)
library(leaflet)
library(leaflet.extras)

# Load the cities data (to obtain the coordinates of the cities in Malaysia)
# The cities list is obtained from http://bulk.openweathermap.org/sample/city.list.json.gz
# city.list.json.gz is a zipped file. 
 cityListDF <- fromJSON("city.list.json.gz")
 mycityListDF <- subset(cityListDF, cityListDF$country == 'MY')
#mycityListDF <- fromJSON("MyData.json")

print(mycityListDF)

## Obtain the corrdinates to include all the cities in Malaysia by calculating the Latitude and Longitude
## the value plus 1 or - 1 is for include more area 
## minlon - min value of longitude
## maxlon - max value of longitude
## minlat - min value of latitude
## maxlat - max value of latitude
minlon <- min(mycityListDF$coord$lon) - 1  
maxlon <- max(mycityListDF$coord$lon) + 1
minlat <- min(mycityListDF$coord$lat) - 1
maxlat <- max(mycityListDF$coord$lat) + 1
print(paste0('min value of longitude', ' = ', minlon))
print(paste0('max value of longitude', ' = ', maxlon))
print(paste0('min value of latitude', ' = ', minlat))
print(paste0('max value of latitude', ' = ', maxlat))

# Main function to requering data
plotMap <- function(input, output){
  
  # Querying live data from openweathermap API
  # Example url:
  # http://api.openweathermap.org/data/2.5/box/city?bbox=99,0,120,10,10&appid=4e6c991cd69de992db2a57796bee4bc9
  # id = the id for querying service (4e6c991cd69de992db2a57796bee4bc9)
  boxWeatherInfoUtl <- paste0('http://api.openweathermap.org/data/2.5/box/city?bbox=',minlon,',',minlat,',',maxlon,',',maxlat,',','200','&appid=4e6c991cd69de992db2a57796bee4bc9', sep='')
  allWeatherInfo <- fromJSON(boxWeatherInfoUtl)
  
  # Extract the data from the responded data to fit into Leftlet map ploting parameters
  # 
  id = allWeatherInfo$list$id
  temp = allWeatherInfo$list$main$temp
  resultWeather <- data.frame(id, temp)
  
  # Only select the cities in Malaysia
  latestCityTemp <- merge( mycityListDF, resultWeather, by=c("id"))
  
  #Extract the lists required for map plotting
  lon.list <- latestCityTemp$coord$lon  # longitude list
  lat.list <- latestCityTemp$coord$lat  # longitude list
  temp.list <- latestCityTemp$temp      # temperature list
  
  #Popup marker
  popup.list <- paste0(latestCityTemp$name, ', ', latestCityTemp$temp, intToUtf8(176), 'C')
  
  # Rendering the leftlet map plotting
  output$mymap <- renderLeaflet({
    
    leaflet() %>%
      addTiles() %>%
      #addMarkers(lng=lon.list, lat=lat.list,  popup=popup.list, label = popup.list ) %>%
      addHeatmap(lng=lon.list, lat=lat.list, minOpacity = input$opacity[1], max = input$opacity[2], blur = input$blur, intensity = (temp.list), gradient = c('yellow','red'), radius = input$radian)%>%
      addCircleMarkers( radius = 6, color = 'red', stroke = FALSE, fillOpacity = 0.5, lng=lon.list, lat=lat.list,  popup=popup.list, label = popup.list)
  })
}



# shiny server
shinyServer(function(input, output) {
   
  plotMap(input, output)
  
  observeEvent(input$do, {
      # reload data
      plotMap(input, output)
  })
  
  observeEvent(input$opacity, {
    # reload data
    plotMap(input, output)
  })
  
  observeEvent(input$blur, {
    # reload data
    plotMap(input, output)
  })
  
  observeEvent(input$radian, {
    # reload data
    plotMap(input, output)
  })
  
})
