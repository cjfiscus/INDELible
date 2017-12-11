library(shiny)
library(ggplot2)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

	# Application title
	headerPanel(p(em("Arabidopsis thaliana"), "Indels")),

	sidebarPanel(
	selectInput(inputId = "chrm_select",
                  label = "Chromosome:",
                  choices = c("All", as.character(1:5))),
	sliderInput("lower_lim", 
			"Lower limit:", 
			min = min(dat$Position),
			max = max(dat$Position), 
			value = min(dat$Position)),
	sliderInput("upper_lim", 
			"Upper limit:", 
			min = min(dat$Position),
			max = max(dat$Position), 
			value = max(dat$Position))
	),
  	mainPanel(
		plotOutput("scatterPlot")
	)
))