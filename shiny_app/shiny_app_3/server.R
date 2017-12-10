library(shiny)
require(ggplot2)

# 
server <- function(input, output){

	reactive({
		if(input$chrm_select == "All"){chrm <- 1:5}else{
			chrm <- as.numeric(input$chrm_select)}
		dat <- dat[dat$Chromosome %in% chrm, ]
  	})
 	# Generate a plot 

	output$scatterPlot <- renderPlot({

		if(input$chrm_select == "All"){
			g <- ggplot(dat, aes(x = Position, y = Length)) +
				geom_point(alpha = 0.02) +
				facet_grid(Chromosome ~ .) +
				xlim(input$lower_lim, input$upper_lim)
			g}else{
			g <- ggplot(dat, aes(x = Position, y = Length)) +
				geom_point(alpha = 0.02) +
				xlim(input$lower_lim, input$upper_lim)
			g}
	})
}