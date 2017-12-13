library(shiny)
library(ggplot2)

# 
server <- function(input, output) {

## Plot 1	
	if (1 == 1){
 	# Generate a plot 
	output$chrm_histPlot <- renderPlot({
	chrom_hist_plot(x, chrm = input$chrm_select, 
		window = input$window_width, in_or_del = input$indel_type, 
			test = input$test_select, centromeres = input$plot_centromeres)
	
	
	})
## Plot 2	
	output$scatterPlot <- renderPlot({
		if(input$chrm_select2 == "All"){
			g <- ggplot(dat, aes(length)) +
				geom_histogram(bins = input$nbins, color = "gray30") +
				facet_grid(chromosome ~ .) +
				xlim(input$lower_lim, input$upper_lim) +
				xlab("Length (bases)") + ylab("Count") +
				theme(axis.title = element_text(size = 14))
			g
			}else{
			dat2 <- dat[dat$chromosome %in% input$chrm_select2, ]

			g <- ggplot(dat2, aes(length)) +
				geom_histogram(bins = input$nbins, color = "gray30") +
				xlim(input$lower_lim, input$upper_lim) +
				xlab("Length (bases)") + ylab("Count") +
				theme(axis.title = element_text(size = 14))
			g
			}
	})
## Plot 3
	output$scatterPlot1 <- renderPlot({
		reactive({
		if(input$chrm_select3 == "All"){chrm <- 1:5}else{
			chrm <- as.numeric(input$chrm_select3)}
		dat <- dat[dat$Chromosome %in% chrm, ]
  	})
		if(input$chrm_select3 == "All"){
			g <- ggplot(dat, aes(x = position, y = length, 
				color = InCodingRegion)) +
				geom_point(alpha = 0.1) +
				facet_grid(chromosome ~ .) +
				xlim(input$lower_lim3, input$upper_lim3) +
				xlab("Position") + ylab("Length (bases)") +
				theme(axis.title = element_text(size = 14)) +
				guides(colour = guide_legend(override.aes = list(alpha = 1)))

			g}else{
				dat2 <- dat[dat$chromosome %in% input$chrm_select3, ]
				if(input$chrm_select3 %in% c("Mt", "Pt")){
				g <- ggplot(dat2, aes(x = position, y = length, 
					color = InCodingRegion)) +
					geom_point() +
					xlim(input$lower_lim3, input$upper_lim3) +
					xlab("Position") + ylab("Length (bases)") +
					theme(axis.title = element_text(size = 14))
				}else{
				g <- ggplot(dat2, aes(x = position, y = length, 
					color = InCodingRegion)) +
					geom_point(alpha = 0.1)  +
					xlab("Position") + ylab("Length (bases)") +
					xlim(input$lower_lim3, input$upper_lim3) +
					theme(axis.title = element_text(size = 14)) + 
					guides(colour = guide_legend(override.aes = list(alpha = 1)))
				}
			g}
	})
	## Plot 4
	output$indel_ratioPlot <- renderPlot({
	ins_del_ratio_plot(x, chrm = input$chrm_select4, 
		window = input$window_width4, centromeres = input$plot_centromeres4)
	})
	## Plot 5
	output$two_histsPlot <- renderPlot({
	two_hists(x = dat, chrm = input$chrm_select5, density = input$dens_select)
	})
	}
}