library(shiny)
library(plotly)
library(googleVis)
library(DT)

shinyUI(pageWithSidebar(  
    headerPanel("Featured Indicators from The World Bank"),
    sidebarPanel(width = 3,
                 # World overview tab
        conditionalPanel(condition="input.conditional_input == 'World Overview'",     
                         h4(em("To explore an indicator for a specific year, 
                            first pick a", strong("Category", 
                            style = "color: blue;"), "and",
                            strong("Indicator", style = "color: blue;"),
                            "from the drop down menus below, then pick a", 
                            strong("Year", style = "color: blue;"), 
                            "by sliding over the given range"), align = "center"), 
                         h4(em("The corresponding data for the indicator can 
                                 be found in a table below the map. 
                                 The table can be filtered by a country name or 
                                 can be sorted based on values"),
                            align = "center"),
                         h5(em("To compare an indicator across countries, 
                               click on the", strong("Specific Countries", 
                                                     style = "color: blue;"),
                               "tab"), align = "center"),
                         br(), 
                         selectInput("category_world", "Pick a Category",
                                     list("Agriculture & Rural Development" = "ard",
                                          "Urban Development" = "ud",
                                          "Economy & Growth" = "eg", 
                                          "Financial Sector" = "fs",
                                          "Education" = "edu",
                                          "Health" = "hlth",
                                          "Infrastructure" = "infra"), 
                                     selected = "eg"),
                         # Display indicators conditionally based on the category
                         conditionalPanel(condition = "input.category_world == 'ard'",
                                          selectInput("ard_world", "Pick an Indicator",
                                                      choices = ard,
                                                      selected = "AG.LND.AGRI.K2")),
                         conditionalPanel(condition = "input.category_world == 'ud'",
                                          selectInput("ud_world", "Pick an Indicator",
                                                      choices = ud,
                                                      selected = "EN.POP.DNST")),
                         conditionalPanel(condition = "input.category_world == 'eg'",
                                          selectInput("eg_world", "Pick an Indicator",
                                                      choices = eg,
                                                      selected = "NY.GDP.PCAP.CD")),
                         conditionalPanel(condition = "input.category_world == 'fs'",
                                          selectInput("fs_world", "Pick an Indicator",
                                                      choices = fs,
                                                      selected = "FR.INR.LEND")),
                         conditionalPanel(condition = "input.category_world == 'edu'",
                                          selectInput("edu_world", "Pick an Indicator",
                                                      choices = edu,
                                                      selected = "SE.ADT.LITR.ZS")),
                         conditionalPanel(condition = "input.category_world == 'hlth'",
                                          selectInput("hlth_world", "Pick an Indicator",
                                                      choices = hlth,
                                                      selected = "SP.DYN.LE00.IN")),
                         conditionalPanel(condition = "input.category_world == 'infra'",
                                          selectInput("infra_world", "Pick an Indicator",
                                                      choices = infra,
                                                      selected = "IT.NET.USER.P2")),
                         
                         sliderInput("year", "Pick a Year", 
                                     2015, min = 1990, max = 2015, step = 1), 
                         br(),
                         h5(em("These indicators are a subset of", 
                               strong("Featured Indicators", 
                                      style = "color: blue;"),
                               "from", 
                               a("here", href="http://data.worldbank.org/indicator")
                               ), align = "center"), 
                         h5(em("The data was extracted using the", 
                               a("WDI", 
                                 href="https://cran.r-project.org/web/packages/WDI/index.html"),
                         "package"), align = "center"),
                         h5(em("App developed by: ", 
                               a("Sumedh Panchadhar", 
                                 href="https://github.com/sumedh10/developing_data_products")
                               ), align = "center")
        ),    
        # Specific countries tab
        conditionalPanel(condition="input.conditional_input == 'Specific Countries'", 
                         h4(em("To compare an indicator across countries, 
                               first pick a", strong("Category", 
                                                  style = "color: blue;"), "and",
                               strong("Indicator", style = "color: blue;"),
                               "from the drop down menus below, then pick upto", 
                               strong("5 Countries", style = "color: blue;")), 
                            align = "center"), 
                         h4(em("The corresponding data for the countries can 
                               be found in a table below the plot. 
                               The table can be filtered by a year or 
                               can be sorted by a country"),
                            align = "center"),
                         br(), 
                         selectInput("category_country", "Pick a Category",
                                     list("Agriculture & Rural Development" = "ard",
                                          "Urban Development" = "ud",
                                          "Economy & Growth" = "eg", 
                                          "Financial Sector" = "fs",
                                          "Education" = "edu",
                                          "Health" = "hlth",
                                          "Infrastructure" = "infra"), 
                                     selected = "eg"),
                         # Display indicators conditionally based on the category
                         conditionalPanel(condition = "input.category_country == 'ard'",
                                          selectInput("ard_country", "Pick an Indicator",
                                                      choices = ard,
                                                      selected = "AG.LND.AGRI.K2")),
                         conditionalPanel(condition = "input.category_country == 'ud'",
                                          selectInput("ud_country", "Pick an Indicator",
                                                      choices = ud,
                                                      selected = "EN.POP.DNST")),
                         conditionalPanel(condition = "input.category_country == 'eg'",
                                          selectInput("eg_country", "Pick an Indicator",
                                                      choices = eg,
                                                      selected = "NY.GDP.PCAP.CD")),
                         conditionalPanel(condition = "input.category_country == 'fs'",
                                          selectInput("fs_country", "Pick an Indicator",
                                                      choices = fs,
                                                      selected = "FR.INR.LEND")),
                         conditionalPanel(condition = "input.category_country == 'edu'",
                                          selectInput("edu_country", "Pick an Indicator",
                                                      choices = edu,
                                                      selected = "SE.ADT.LITR.ZS")),
                         conditionalPanel(condition = "input.category_country == 'hlth'",
                                          selectInput("hlth_country", "Pick an Indicator",
                                                      choices = hlth,
                                                      selected = "SP.DYN.LE00.IN")),
                         conditionalPanel(condition = "input.category_country == 'infra'",
                                          selectInput("infra_country", "Pick an Indicator",
                                                      choices = infra,
                                                      selected = "IT.NET.USER.P2")),
                         selectizeInput('country', 'Pick upto 5 Countries', 
                                        choices = countries, 
                                        selected = c("US", "NZ", "CA", "GB", "AU"),
                                        multiple = TRUE, 
                                        options = list(maxItems = 5)),
                         h5(em("To remove a country from the list, click on it and
                               press", strong("Delete", style = "color: red;"),
                               "or", strong("Backspace", style = "color: red;")), 
                            align = "center")
        )
    ),
    
    mainPanel(
        tabsetPanel(id = "conditional_input", type = "pills",
            tabPanel("World Overview",
                     br(),
                     strong(textOutput("name"),
                            align = "center", 
                            style = "font-size:125%"),
                     br(), br(),
                     htmlOutput("map"), 
                     h5("Note:", strong("Green color", 
                                        style = "color: green;"), 
                        "indicates data was not collected for 
                                    that year/indicator", align = "center"),
                     br(), 
                     strong(textOutput("description"), 
                            align = "center"),
                     br(), br(), br(), br(),
                     DT::dataTableOutput('table_world'),
                     br(), br(),
                     h5(strong("Note: Empty cells indicate data was not collected 
                                    for that year/indicator", 
                               style = "font-weight: bold; 
                               font-style: italic;"), align = "center")
            ),
            tabPanel("Specific Countries",
                     br(),
                     strong(textOutput("name2"), 
                            align = "center", 
                            style = "font-size:125%"),
                     br(),
                     plotlyOutput("country_plot"),
                     br(), br(), br(), br(), br(), br(),
                     br(), br(), br(), br(), br(), br(),
                     strong(textOutput("description2"), 
                            align = "center"),
                     br(), br(), br(), br(),
                     DT::dataTableOutput("table_country"),
                     br(), br(), 
                     h5(strong("Note: Empty cells indicate data was not collected 
                                    for that year/indicator", 
                               style = "font-weight: bold; 
                               font-style: italic;"), align = "center")
            )
        )
    )  
))