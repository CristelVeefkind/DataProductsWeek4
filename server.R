library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)


set.seed(100)
treeData <- allTrees
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
treeData <- treeData[order(treeData$JAAR_VAN_AANPLANT),]

function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
        attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
      ) %>%
      setView(lng = 4.65, lat = 52.20, zoom = 13)
  })
  
  # A reactive expression that returns the set of trees that are
  # in bounds right now
  TreesInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(treeData[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(treeData,
           latitude >= latRng[1] & latitude <= latRng[2] &
             longitude >= lngRng[1] & longitude <= lngRng[2])
  })
  
  
  output$histSpecies <- renderPlot({
    # If no trees are in view, don't plot
    if (nrow(TreesInBounds()) == 0)
      return(NULL)
    pal <- colorFactor("viridis",as.factor(allTrees$TYPERING),na.color= NA)
    par(mar=c(14.3,3,1.7, 0.3))
    barplot(table(TreesInBounds()$SORTIMENT),
            las=2,
            main = "Species found in current map \ncolored by type",
            
            col= pal(allTrees$TYPERING)
            )
    

  })
  
  
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
 observe({
     colorBy <-input$color
     sizeBy <- input$size
     radius <- (200-as.numeric(as.factor(treeData[[sizeBy]]))*9)/5
     print(colorBy)
     #use the category for year planted for a nicer look
    if (colorBy == "JAAR_VAN_AANPLANT") {
      colorData <-as.factor(allTrees$planted_category)
      pal <- colorFactor("viridis", colorData,na.color= NA)
      labels<- c("1850-1900","1901-1950","1951-2000","2000-now")
      legendValues<- colorData
      
    } 
     else {
      colorData<- as.factor(treeData[[colorBy]])
      pal <- colorFactor("viridis",colorData,na.color= NA)
      legendValues<- colorData
      labels<- colorData
      }
    
    leafletProxy("map", data = treeData) %>%
      clearShapes() %>%
     addCircles(~longitude, ~latitude, radius=radius, layerId=~JAAR_VAN_AANPLANT,
                 stroke=FALSE, fillOpacity=0.5,  fillColor=~pal(colorData),popup=~htmlEscape(SORTIMENT)) %>%
            addLegend("bottomleft", pal=pal, values=legendValues,labels=labels, title=colorBy,
            layerId="colorLegend")
  })
  

  
  
  ## Data Explorer ###########################################

  observe({
    trees <- if (is.null(input$type)) character(0) else {
      filter(cleantable, Type %in% input$type) %>%
        `$`('Species') %>%
        unique() %>%
        sort()
      
    }
    
  })
  
  
 

  output$treetable <- DT::renderDataTable({
    df <- cleantable %>%
      filter(
        Year >= input$minYear,
        Year <= input$maxYear,
        is.null(input$type) | Type %in% input$type,
        is.null(input$species) | Species %in% input$species
      )

    DT::datatable(df, escape = FALSE)

  })
}