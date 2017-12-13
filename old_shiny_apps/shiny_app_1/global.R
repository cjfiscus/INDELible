# Read data.
dat <- read.delim("indels_annotated.txt", sep = "\t")

# Makes ref and alt columns as.character.
dat$alt <- as.character(dat$alt)
dat$ref <- as.character(dat$ref)

# Pull out the first alt seq from entries with multiple entries..
# and store the lengths.
lengths <- numeric(length(dat$alt))
for(i in 1:length(dat$alt)){
	if(grepl(",", dat$alt[i]) == TRUE){
	lengths[i] <- gregexpr(",", dat$alt[i])[[1]][1] - 1
	}else{
	lengths[i] <- nchar(dat$alt[i]) - 2
	}
}


# Calculate the lengths of indels and make new column on dat.
dat$length <- lengths - nchar(dat$ref)

# Convert dat to a list, where the first 7 items are positions for each chromosome..
# and items 8-14 are lengths of indels
x <- list()
for(i in 1:7){
x[[i]] <- dat$position[dat$chromosome == levels(dat$chromosome)[i]]
x[[i + 7]] <- dat$length[dat$chromosome == levels(dat$chromosome)[i]]
}


# Define plot function
chrom_hist_plot <- function(x, chrm, window, in_or_del, test,
	centromeres){

	# Define centromeres vector
	centromere_locs <- c(14514163, 3611836, 13593470, 3133661, 11194542, NA, NA)

	# Ony selected chromosome

	if(chrm[1] %in% as.character(1:5)){chrm <- as.numeric(chrm)}
	if(chrm[1] == "Mt"){chrm <- 6}
	if(chrm[1] == "Pt"){chrm <- 7}
	if(chrm[1] == "All"){chrm <- 1:7}
	chrm_char <- c(paste("Chr",as.character(1:5)), "Mt", "Pt")

	# Loop through list of positions and keep only insertions, deletions or both
	keep_list <- list()
	for(i in chrm){
	if(in_or_del == "Insertions"){
		keep_list[[i]] <- x[[i]][x[[i + 7]] > 1]
		}else{
		if(in_or_del == "Deletions"){
			keep_list[[i]] <- x[[i]][x[[i + 7]] < 1]
			}else{
			keep_list[[i]] <- x[[i]]
			}
		}
	}

	# Unlist all position values for some calculations
	all_vals <- unlist(keep_list[chrm])

	# Max and min of position all values
	x_min <- min(all_vals)
	x_max <- max(all_vals)

	# Calculate breaks by window width
	x_end <- x_max + (window - (x_max %% window))
	breakz <- seq(0, x_end, window)

	# Create vectors to store max and min counts for given breaks
	max_counts <- numeric(7)
	min_counts <- numeric(7)

	# Loop through all chromosomes and calculate the max and min counts
	for(i in chrm){
		h <- hist(keep_list[[i]], breaks = breakz, 
			plot = FALSE)
		max_counts[i] <- max(h$counts)
		min_counts[i] <- min(h$counts)
	}

	# Adjust graphical parameters
	par(mfrow = c(length(chrm), 1), mar = c(0.5, 8, 0.5, 9), oma = c(7, 0, 0, 0),
	cex.axis = 1.6)
	# Plot histograms
	for(i in chrm){
		# Histogram
		hist(keep_list[[i]], axes = FALSE, xlab = "", ylab = "", main = "",
			col = "gray30", breaks = breakz,
			xlim = c(x_min, x_max), 
			ylim = c(min(min_counts), max(max_counts)))
		# Centromere lines
		if(centromeres == "Yes"){
			abline(v = centromere_locs[i], lwd = 3, lty = 3, col = "red")
		}
		# Color void space into which chromosome does not extend
		rect(max(keep_list[[i]]), min(min_counts), x_max, max(max_counts),
			col = rgb(0, 0, 0, 0.2), border = "transparent")
		axis(2, las = 1, at = round(seq(min(min_counts), 
			max(max_counts), length.out = 3)))
		text(x_max, (max(max_counts) - min(min_counts)) * 0.8, pos = 4, 
			chrm_char[i], cex = 2, xpd = TRUE)
		pois_bins <- hist(keep_list[[i]], breaks = breakz, plot = FALSE)
		pois_p_val <- ks.test(pois_bins$counts, 
		"ppois", lambda = mean(pois_bins$counts))$p.value
		text(x_max, (max(max_counts) - min(min_counts)) * 0.45, pos = 4, 
			bquote("p ="~.(signif(pois_p_val, 3))), cex = 1.5, xpd = TRUE)

		if(i == median(chrm)){
			mtext(side = 2, line = 4.5, "Count", cex = 1.6)}

		if(i == max(chrm)){
			axis(1, at = round(seq(0, x_max, length.out = 10)))
			mtext(side = 1, line = 4, "Position", cex = 1.6)}
	}
}






