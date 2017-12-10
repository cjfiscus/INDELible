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
	sliderInput("nbins", 
			"Number of bins:", 
			min = 20,
			max = 200, 
			value = 50),
	sliderInput("lower_lim", 
			"Lower limit:", 
			min = min(dat$Length),
			max = 0, 
			value = min(dat$Length)),
	sliderInput("upper_lim", 
			"Upper limit:", 
			min = 0,
			max = max(dat$Length), 
			value = max(dat$Length))
	),
  	mainPanel(
		plotOutput("scatterPlot")
	)
))