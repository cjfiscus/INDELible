library(shiny)


# 
server <- function(input, output) {

	

 	# Generate a plot 
	output$chrm_histPlot <- renderPlot({
	chrom_hist_plot(x, chrm = input$chrm_select, 
		window = input$window_width, in_or_del = input$indel_type, 
			test = input$test_select, centromeres = input$plot_centromeres)
	})
}