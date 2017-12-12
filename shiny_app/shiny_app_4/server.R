library(shiny)


# 
server <- function(input, output) {
	
	# Generate a plot 
	output$indel_ratioPlot <- renderPlot({
	ins_del_ratio_plot(x, chrm = input$chrm_select, 
		window = input$window_width, centromeres = input$plot_centromeres)
	})
}