#devtools::install_github("https://github.com/petergandenberger/gridstackeR/tree/experiments")

library(shiny)
library(shinyjs)
library(gridstackeR)
library(R6)
library(shinydashboard)
library(storr)
library(esquisse)
library(ggplot2)
library(bs4Dash)
library(tidyr)
library(dplyr)


# resources -----------------------------------------------------------------
source("ui.R")
source("server.R")

source("dRagonElement.R")
source("dRagonElementBuilder.R")


source("elements/TextElementBuilder.R")
source("elements/NumberElementBuilder.R")
source("elements/GGPlotElementBuilder.R")
source("elements/ValueboxElementBuilder.R")
source("elements/DataTableElementBuilder.R")


source("element_helpers.R")
source("element_builder_modal.R")
source("export_dashboard.R")

shinyApp(ui, server)
