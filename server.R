# Title: Final Project - Week 4
# Course: Developing Data Products
# University: Johns Hopkins University
# Author: "Rejane Rodrigues de Carvalho Pereira, Brasília-Brazil"
# Date: "November 26, 2021"

library(shiny)
library(tidyverse)
library(plotly)
library(DT)

# DOWNLOADING THE FILE.

fileUrl <- "http://dados.mma.gov.br/dataset/41a79b71-445f-4a6a-8c70-d46af991292a/resource/1f13b062-f3f6-4198-a4c5-3581548bebec/download/lista-de-especies-ameacas-2020.csv"

setwd("C:/Users/Rejane/Documents/Cursos_R/Developing_Data_Products/")

download.file(fileUrl, 
              destfile = "lista-de-especies-ameacas-2020.csv", 
              method = "auto")

# READING THE FILE.
endangered_species <- data.table::fread("lista-de-especies-ameacas-2020.csv",                                           encoding = "UTF-8") %>%
  janitor::clean_names()

# SELECTING ONLY THE FAUNA.

fauna <- 
  endangered_species %>%
  filter(fauna_flora %in% "Fauna" &
         nome_comum != "-") %>%
  select(-fauna_flora)

#dplyr::glimpse(fauna)

fauna_group <- 
  fauna %>%
  distinct(grupo) %>%
  arrange

shinyServer(function(input, output){
  
  
  group <-  reactive({
    
    fauna %>% 
        filter(grupo %in% input$FAUNA_GROUP) %>% 
        select(-grupo)
    
  })
  
  output$plot1 <- renderPlotly({
   
    # Plotting the FAUNA.
    plot_ly(group(), 
            x = ~bioma, 
            y = ~nome_comum, 
            color = ~as.factor(categoria_de_ameaca),
            type = "scatter",
            mode = "markers",
            hovertext = "text") %>%
    layout(title = paste0("\nEndangered Fauna by Group: ", input$FAUNA_GROUP, "\n"))
    
  })
  
  idc_Brazil <-  reactive({
      
      fauna %>% 
        filter(especie_exclusiva_do_brasil %in% input$FAUNA_PLACE) %>% 
        select(-especie_exclusiva_do_brasil)
      
  })
  
  
  observe({
    if (req(input$FAUNA_PLACE) %in% c("Sim", "Não")) {
        output$plot2 <- renderPlotly({    
          # Plotting the FAUNA.
          plot_ly(idc_Brazil(), 
                  x = ~bioma, 
                  y = ~nome_comum, 
                  color = ~as.factor(categoria_de_ameaca),
                  type = "scatter",
                  mode = "markers",
                  hovertext = "text") %>%
          layout(title = paste0("\nEndangered Fauna Exclusive of Brazil: ", input$FAUNA_PLACE, "\n"))
        })
    }
 })
})



