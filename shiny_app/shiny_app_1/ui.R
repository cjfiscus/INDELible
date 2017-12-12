library(shiny)


# Define UI
shinyUI(pageWithSidebar(

  # Application title
  headerPanel(p("Indels in 80", em("Arabidopsis"), "genomes")),

	sidebarPanel(
		sliderInput("window_width", 
			"Width of window (bases):", 
			min = 100000,
			max = 4000000, 
			step = 4000000 / 50,
			value = 1000000),

		selectInput(inputId = "chrm_select",
                  label = "Chromosome:",
                  choices = c("All", as.character(1:5), "Mt", "Pt")),

		selectInput(inputId = "indel_type",
                  label = "Type:",
                  choices = c("Insertions and deletions", "Insertions", "Deletions")),

		selectInput(inputId = "plot_centromeres",
                  label = "Plot centromeres?:",
                  choices = c("No", "Yes")),

		selectInput(inputId = "test_select",
                  label = "Statistical test:",
                  choices = c("K-S uniform", "K-S Poisson (counts)"))

	),


  mainPanel(
	plotOutput("chrm_histPlot"))
))
