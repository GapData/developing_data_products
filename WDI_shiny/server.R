
library(shiny)
library(WDI)
library(plotly)
library(googleVis)
library(DT)
library(tidyr)
library(dplyr)


shinyServer(function(input, output, session) {
    
    # Functions for the World overview tab
    
    selected_indicator_world <- reactive({ 
        switch(input$category_world,
               "ard"   = input$ard_world,
               "ud"    = input$ud_world,
               "eg"    = input$eg_world,
               "fs"    = input$fs_world,
               "edu"   = input$edu_world,
               "hlth"  = input$hlth_world,
               "infra" = input$infra_world
        )
    })
    
    selected_data_world <- reactive({
        
        df = WDI(country = "all", indicator = selected_indicator_world(),
                 start = input$year, end = input$year) %>% slice(-(1:47))
        
    })
    
    
    text_to_display <- reactive({
        
        all_indicators %>% filter_(~ indicator == selected_indicator_world())
    })
    
    
    output$description <- renderText({
        paste("Indicator Description: ", text_to_display()[3])
    })
    
    output$name <- renderText({
        paste(text_to_display()[2], "in", input$year)
    })
    
    
    # map - world overview tab
    
    output$map <- renderGvis({
        
        gvisGeoChart(selected_data_world(), "country", selected_indicator_world(), 
                     options=list(colors = "['#91BFDB', '#FC8D59']",
                                  width = 800, height = 500))
         
    })
    
    # datatable - world overview tab
    
    output$table_world <- DT::renderDataTable({
        
        df = selected_data_world() %>% 
            select_("-iso2c", "-year", Country = "country", 
                    Value = selected_indicator_world()) 
        
        datatable(df, rownames = FALSE, 
                  options = list(language = list(search = 'Search Countries:'), 
                                 initComplete = headerColor)) %>%
            formatStyle(1:2, fontSize = '18px') %>%
            formatRound(2, digits = 2)
    })
    
    
    
    # Functions for the Specific Countries tab
    
    selected_indicator_country <- reactive({ 
        switch(input$category_country,
               "ard"   = input$ard_country,
               "ud"    = input$ud_country,
               "eg"    = input$eg_country,
               "fs"    = input$fs_country,
               "edu"   = input$edu_country,
               "hlth"  = input$hlth_country,
               "infra" = input$infra_country
        )
    })
        
        

        country_data <- reactive({

            df = WDI(country = input$country, 
                     indicator = selected_indicator_country(),
                      start = 1980, end = 2015) %>%
                select_(Country = "country", Year = "year",
                        Value = selected_indicator_country())

        })
        
        
        text_to_display2 <- reactive({
            
            all_indicators %>% filter_(~ indicator == selected_indicator_country())
            
        })
        
        
        output$description2 <- renderText({
            paste("Indicator Description: ", text_to_display2()[3])
        })
        
        output$name2 <- renderText({
            paste(text_to_display2()[2])
        })

        
        # plotly plot - specific countries tab
        
        output$country_plot <- renderPlotly({

            plot_ly(country_data(), x = Year, y = Value, color = Country) %>%
                layout(autosize = FALSE, width = 800, height = 600, 
                       xaxis = list(range = c(1980, 2016)),
                       legend = list(x = 0.1, y = 1, font = font))
             # 

        })
        
        # datatable - specific countries tab
    
        output$table_country <- DT::renderDataTable({

            df = country_data() %>% spread(Country, Value)

            datatable(df, rownames = FALSE, 
                      options = list(language = list(search = 'Search Years:'), 
                                     initComplete = headerColor, 
                                     pageLength = 12, 
                                     lengthMenu = c(12, 24, 36))) %>%
                formatStyle(1:6, fontSize = '18px') %>%
                formatRound(2:6, digits = 2)

        })
        

})


