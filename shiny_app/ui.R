library(shiny)

shinyUI(navbarPage("Plots",
  tabPanel("Position vs. Count", plotOutput("chrm_histPlot"),
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

	)),
  tabPanel("Lengths",plotOutput("scatterPlot"), 
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
	)),
  tabPanel("Position vs. Length", plotOutput("scatterPlot1"), 
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
	)),
  tabPanel("Ratios", plotOutput("indel_ratioPlot"), sidebarPanel(
		sliderInput("window_width", 
			"Width of window (bases):", 
			min = 100000,
			max = 4000000, 
			step = 4000000 / 50,
			value = 1000000),

		selectInput(inputId = "chrm_select",
                  label = "Chromosome:",
                  choices = c("All", as.character(1:5), "Mt", "Pt")),

		selectInput(inputId = "plot_centromeres",
                  label = "Plot centromeres?:",
                  choices = c("No", "Yes"))

	)),
  tabPanel("Functional", plotOutput("two_histsPlot"), 
  sidebarPanel(

	selectInput(inputId = "chrm_select",
                  label = "Chromosome:",
                  choices = c("All", as.character(1:5), "Mt", "Pt")),
	selectInput(inputId = "dens_select",
                  label = "Y axis:",
                  choices = c("Count", "Density"))

	))
))