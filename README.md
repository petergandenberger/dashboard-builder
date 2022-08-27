# dashboardBuilder

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

The Dashboard-Builder helps you to create Shiny-Dashboards without writing any code.

![dashboard-builder](https://user-images.githubusercontent.com/22965104/186987442-bca48b8e-4a45-4e09-8765-d58b18bf812c.png)


The dashboard-builder is still in development. If you have any questions or feedback please don't hesitate to reach out to me via email or github.

## Run the Dashboard-Builder locally
To run the dashboard-builder you need to download the package and execute the run_app function.
``` r
devtools::install_github("https://github.com/petergandenberger/dashboard-builder")
dashboardBuilder::run_app()
```

## Online Demo
There is a [demo available on shinyapps.io](https://pega.shinyapps.io/dashboard-builder/).

## gridstackeR
The exported dashboards use the gridstackeR package. You can check out the [project here](https://github.com/petergandenberger/gridstackeR)

## Workflow
There are four steps in creating shiny apps with the dashboard builder

1. Import data
2. Create Elements
3. Export the Dashboard
4. Improve and Extend

## Talk at rstudio::conf(2022)
Please have a look at [my talk at rstudio::conf(2022) introducing the dashboard-builder](https://www.rstudio.com/conference/2022/talks/dashboard-builder/)
