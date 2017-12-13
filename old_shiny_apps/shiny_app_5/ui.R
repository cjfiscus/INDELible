library(shiny)


# Define UI
shinyUI(pageWithSidebar(

  # Application title
  headerPanel(p("Indels in 80", em("Arabidopsis"), "genomes")),

	sidebarPanel(

	selectInput(inputId = "chrm_select",
                  label = "Chromosome:",
                  choices = c("All", as.character(1:5), "Mt", "Pt")),
	selectInput(inputId = "dens_select",
                  label = "Y axis:",
                  choices = c("Count", "Density"))

	),


  mainPanel(
	plotOutput("two_histsPlot"))
))
