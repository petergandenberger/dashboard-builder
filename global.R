#devtools::install_github("https://github.com/petergandenberger/gridstackeR/tree/experiments")

library(shiny)
library(shinyjs)
library(gridstackeR)
library(ggplot2)
library(esquisse)
library(dplyr)
library(shinydashboard)
library(shinyAce)
library(checkmate)
library(emojifont)


# resources -----------------------------------------------------------------
source("ui.R")
source("server.R")
source("dRagon_helpers.R")

shinyApp(ui(), server)
