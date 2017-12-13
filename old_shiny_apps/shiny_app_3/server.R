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
			g <- ggplot(dat, aes(x = position, y = length, 
				color = InCodingRegion)) +
				geom_point(alpha = 0.1) +
				facet_grid(chromosome ~ .) +
				xlim(input$lower_lim, input$upper_lim)  +
				xlab("Position") + ylab("Length (bases)") +
				theme(axis.title = element_text(size = 14)) +
				guides(colour = guide_legend(override.aes = list(alpha = 1)))

			g}else{
				dat2 <- dat[dat$chromosome %in% input$chrm_select, ]
				if(input$chrm_select %in% c("Mt", "Pt")){
				g <- ggplot(dat2, aes(x = position, y = length, 
					color = InCodingRegion)) +
					geom_point() +
					xlim(input$lower_lim, input$upper_lim)  +
					xlab("Position") + ylab("Length (bases)") +
					theme(axis.title = element_text(size = 14))
				}else{
				g <- ggplot(dat2, aes(x = position, y = length, 
					color = InCodingRegion)) +
					geom_point(alpha = 0.1) +
					xlim(input$lower_lim, input$upper_lim)  +
					xlab("Position") + ylab("Length (bases)") +
					theme(axis.title = element_text(size = 14)) + 
					guides(colour = guide_legend(override.aes = list(alpha = 1)))
				}
			g}
	})
}