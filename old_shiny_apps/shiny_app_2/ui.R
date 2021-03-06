library(shiny)
library(ggplot2)

# Define ui
shinyUI(pageWithSidebar(

	# Application title
	headerPanel(p("Indels in 80", em("Arabidopsis"), "genomes")),

	sidebarPanel(
	selectInput(inputId = "chrm_select",
                  label = "Chromosome:",
                  choices = c("All", as.character(1:5), "Mt", "Pt")),
	sliderInput("nbins", 
			"Number of bins:", 
			min = 20,
			max = 200, 
			value = 50),
	sliderInput("lower_lim", 
			"Lower limit:", 
			min = min(dat$length),
			max = 0, 
			value = min(dat$length)),
	sliderInput("upper_lim", 
			"Upper limit:", 
			min = 0,
			max = max(dat$length), 
			value = max(dat$length))
	),
  	mainPanel(
		plotOutput("scatterPlot")
	)
))
