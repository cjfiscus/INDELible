library(shiny)
library(ggplot2)

# 
server <- function(input, output) {

	
	if (1 == 1){
 	# Generate a plot 
	output$chrm_histPlot <- renderPlot({
	chrom_hist_plot(x, chrm = input$chrm_select, 
		window = input$window_width, in_or_del = input$indel_type, 
			test = input$test_select, centromeres = input$plot_centromeres)
	
	
	})
	
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
	output$scatterPlot1 <- renderPlot({
		reactive({
		if(input$chrm_select == "All"){chrm <- 1:5}else{
			chrm <- as.numeric(input$chrm_select)}
		dat <- dat[dat$Chromosome %in% chrm, ]
  	})
		if(input$chrm_select == "All"){
			g <- ggplot(dat, aes(x = position, y = length, 
				color = InCodingRegion)) +
				geom_point(alpha = 0.1) +
				facet_grid(chromosome ~ .) +
				xlab("Position") + ylab("Length (bases)") +
				theme(axis.title = element_text(size = 14)) +
				guides(colour = guide_legend(override.aes = list(alpha = 1)))

			g}else{
				dat2 <- dat[dat$chromosome %in% input$chrm_select, ]
				if(input$chrm_select %in% c("Mt", "Pt")){
				g <- ggplot(dat2, aes(x = position, y = length, 
					color = InCodingRegion)) +
					geom_point() +
					xlab("Position") + ylab("Length (bases)") +
					theme(axis.title = element_text(size = 14))
				}else{
				g <- ggplot(dat2, aes(x = position, y = length, 
					color = InCodingRegion)) +
					geom_point(alpha = 0.1)  +
					xlab("Position") + ylab("Length (bases)") +
					theme(axis.title = element_text(size = 14)) + 
					guides(colour = guide_legend(override.aes = list(alpha = 1)))
				}
			g}
	})
	output$indel_ratioPlot <- renderPlot({
	ins_del_ratio_plot(x, chrm = input$chrm_select, 
		window = input$window_width, centromeres = input$plot_centromeres)
	})
	output$two_histsPlot <- renderPlot({
	two_hists(x = dat, chrm = input$chrm_select, density = input$dens_select)
	})
	}
}