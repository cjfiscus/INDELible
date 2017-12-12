library(shiny)
library(ggplot2)

# 
server <- function(input, output){

 	# Generate a plot 

	output$scatterPlot <- renderPlot({
		if(input$chrm_select == "All"){
			g <- ggplot(dat, aes(length)) +
				geom_histogram(bins = input$nbins, color = "gray30") +
				facet_grid(chromosome ~ .) +
				xlim(input$lower_lim, input$upper_lim) +
				xlab("Length (bases)") + ylab("Count") +
				theme(axis.title = element_text(size = 14))
			g
			}else{
			dat2 <- dat[dat$chromosome %in% input$chrm_select, ]

			g <- ggplot(dat2, aes(length)) +
				geom_histogram(bins = input$nbins, color = "gray30") +
				xlim(input$lower_lim, input$upper_lim) +
				xlab("Length (bases)") + ylab("Count") +
				theme(axis.title = element_text(size = 14))
			g
			}
	})
}