library(shiny)


# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel(p(em("Arabidopsis thaliana"), "Indels")),

	sidebarPanel(
		sliderInput("nbins", 
			"Number of bins:", 
			min = 4,
			max = 150, 
			value = 40),

	selectInput(inputId = "chrm_select",
                  label = "Chromosome:",
                  choices = c("All", as.character(1:5))),

	selectInput(inputId = "indel_type",
                  label = "Type:",
                  choices = c("Insertions and deletions", "Insertions", "Deletions")),

	selectInput(inputId = "test_select",
                  label = "Statistical test:",
                  choices = c("Chi-squared (counts)", "K-S uniform", "K-S Poisson (counts)"))

	),


  mainPanel(
	plotOutput("chrm_histPlot"))
))