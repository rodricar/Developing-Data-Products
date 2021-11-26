# Title: Final Project - Week 4
# Course: Developing Data Products
# University: Johns Hopkins University
# Author: "Rejane Rodrigues de Carvalho Pereira, Brasília-Brazil"
# Date: "November 24, 2021"

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

fauna_group <- 
    fauna %>%
    distinct(grupo) %>%
    arrange

# Object: user interface
shinyUI(
ui <- fluidPage(
  navbarPage("DEFENSE ANIMAL", 
              tabPanel(
                div(strong("This shiny application shows the interactive graphics about Brazil' Fauna.")),
                div("The data are based on the Official List 2020 of the Environment Ministery of the Brazilian Government."),
                div("The Brazilian government concerns species threatened with extinction, overexploitation, unsustainable, and with negative consequences that, sooner or later, will be harmful from the point of view economic, social or environmental."),
                div("This problem requires specific recovery policies for both terrestrial and aquatic fauna and flora."),
                div("More information can be obtained from: http://dados.mma.gov.br/dataset/especies-ameacadas"),
                title="Endangered Fauna", 
                       textOutput(""),
                       tabBox(
                         id = "tab1",
                         width = NULL,
                         height = 250,
                         side = "left",
                        # TAB Group's Fauna
                        tabPanel(title = "Group's Fauna",   
                                 sidebarLayout(
                                 sidebarPanel(
                                   div("This page allows you to select the fauna' group and returns the dynamics graphics.\n"),
                                   title = "",  
                                              selectInput("FAUNA_GROUP",
                                                          "Select Fauna' Group",
                                                          choices = fauna_group,
                                                          selectize = TRUE)),
                                 mainPanel(plotlyOutput("plot1"))))
                        ,
                        # TAB Fauna Exclusive or not of Brazil
                        tabPanel(title="Fauna Exclusive or not of Brazil", 
                                 sidebarLayout(
                                 sidebarPanel(title = "",  
                                              div("This page allows you to select the fauna' kind (exclusive or not of Brazil) and returns the dynamics graphics.\n"),
                                              radioButtons("FAUNA_PLACE",
                                                           "Select Fauna Exclusive of Brazil",
                                                           choices = list("Sim",
                                                                          "Não"),
                                                           selected = "Sim")),
                                 mainPanel(plotlyOutput("plot2"))))))
)))