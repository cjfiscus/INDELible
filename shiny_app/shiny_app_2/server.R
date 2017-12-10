library(shiny)
library(ggplot2)

# 
server <- function(input, output){

#	reactive({
#		if(input$chrm_select == "All"){chrm <- 1:5}else{
#			chrm <- as.numeric(input$chrm_select)}
#		dat <- dat[dat$Chromosome %in% chrm, ]
#  	})
 	# Generate a plot 

	output$scatterPlot <- renderPlot({
		if(input$chrm_select == "All"){
			g <- ggplot(dat, aes(Length)) +
				geom_histogram(bins = input$nbins, color = "gray30") +
				facet_grid(Chromosome ~ .) +
				xlim(input$lower_lim, input$upper_lim)
			g
			}else{
			chrm <- as.numeric(input$chrm_select)
			dat <- dat[dat$Chromosome %in% chrm, ]
			g <- ggplot(dat, aes(Length)) +
				geom_histogram(bins = input$nbins, color = "gray30") +
				xlim(input$lower_lim, input$upper_lim)
			g
			}
	})
}