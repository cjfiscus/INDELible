library(shiny)
library(ggplot2)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

	# Application title
	headerPanel(p("Indels in 80", em("Arabidopsis"), "genomes")),

	sidebarPanel(
		selectInput(inputId = "chrm_select",
                  label = "Chromosome:",
                  choices = c("All", as.character(1:5), "Mt", "Pt")),
		sliderInput("lower_lim", 
			"Lower limit:", 
			min = min(dat$position),
			max = max(dat$position), 
			value = min(dat$position)),
		sliderInput("upper_lim", 
			"Upper limit:", 
			min = min(dat$position),
			max = max(dat$position), 
			value = max(dat$position))
	),
  	mainPanel(
		plotOutput("scatterPlot")
	)
))