library(leaflet)

# Choices for drop-downs
vars <- c(
  "Year Planted" = "JAAR_VAN_AANPLANT",
  "Type of Tree" = "TYPERING"
)


navbarPage("Trees", id="nav",
           
           tabPanel("Interactive map",
                    div(class="outer",
                        
                        tags$head(
                          #for later use:
                          # Include our custom CSS
                          #includeCSS("styles.css"),
                          #includeScript("gomap.js")
                        ),
                        
                        # Set height of leafletOutput to a number instead of percent
                        leafletOutput("map", width="500", height="500"),
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 330, height = "auto",
                                      
                                      h2("Tree explorer"),
                                      
                                      selectInput("color", "Color", vars),
                                      selectInput("size", "Size", vars, selected = "Type of Tree"),
                                      conditionalPanel("input.color == 'Type of Tree' || input.size == 'Year Planted'"          
                                      ),
                                      
                                      plotOutput("histSpecies", height = 400)
                                     
                        )
                        
                        
                    )
           ),
           
           tabPanel("Year planted",
                    fluidRow(
                      column(3,
                             selectInput("type", "Type", c("All Types"="", cleantable[!duplicated(cleantable$Type),3]), multiple=TRUE)
                      )
                      #column(3,
                      #       conditionalPanel(condition="input.type",
                      #                        selectInput("Species", "Species", c("All Species"="",cleantable[!duplicated(cleantable$Species),2]), multiple=TRUE)
                      #       )
                      #)
                    ),
                    fluidRow(
                      column(2,
                             numericInput("minYear", "Min Year", min=min(cleantable$Year,na.rm=T), max=max(cleantable$Year,na.rm=T), value=0)
                      ),
                      column(2,
                             numericInput("maxYear", "Max Year", min=min(cleantable$Year,na.rm=T), max=max(cleantable$Year,na.rm=T), value=0)
                      )
                    ),
                    hr(),
                    DT::dataTableOutput("treetable")
           ),
           
           
           
           tabPanel("Documentation",
                    fluidRow(
                      column(7,includeMarkdown("documentation.md")))
                       )
           
)