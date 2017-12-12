library(shiny)


# 
server <- function(input, output) {

	# Generate a plot 
	output$two_histsPlot <- renderPlot({
	two_hists(x = dat, chrm = input$chrm_select, density = input$dens_select)
	})
}
