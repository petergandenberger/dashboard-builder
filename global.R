#devtools::install_github("https://github.com/petergandenberger/gridstackeR")

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
library(styler)
library(datamods)
library(shinyalert)


# resources -----------------------------------------------------------------
source("ui.R")
source("server.R")

source("elements/dashboardBuilderElement.R")
source("elements/dashboardBuilderElementBuilder.R")


source("elements/TextElementBuilder.R")
source("elements/NumberElementBuilder.R")
source("elements/GGPlotElementBuilder.R")
source("elements/ValueboxElementBuilder.R")
source("elements/DataTableElementBuilder.R")


source("helpers/element_helpers.R")
source("helpers/element_builder_modal.R")
source("helpers/export_dashboard.R")

shinyApp(ui, server)
