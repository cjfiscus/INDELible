# Read data.
dat <- read.delim("indels_annotated.txt", sep = "\t")

library(ggplot2)

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

z<-x
for(i in 1:7){
z[[i]] <- dat$position[dat$chromosome == levels(dat$chromosome)[i]]
z[[i + 7]] <- ifelse(dat$length[dat$chromosome == i] > 0, "insertion", "deletion")
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
ins_del_ratio_plot <- function(x, chrm, window, centromeres){

	# Define centromeres vector
	centromere_locs <- c(14514163, 3611836, 13593470, 3133661, 11194542, NA, NA)

	# Ony selected chromosome

	if(chrm[1] %in% as.character(1:5)){chrm <- as.numeric(chrm)}
	if(chrm[1] == "Mt"){chrm <- 6}
	if(chrm[1] == "Pt"){chrm <- 7}
	if(chrm[1] == "All"){chrm <- 1:7}
	chrm_char <- c(paste("Chr",as.character(1:5)), "Mt", "Pt")

	# Unlist all position values for some calculations
	all_vals <- unlist(z[chrm])

	# Max and min of position all values
	x_min <- min(all_vals)
	x_max <- max(all_vals)

	# Calculate breaks by window width
	x_end <- x_max + (window - (x_max %% window))
	breakz <- seq(0, x_end, window)


	# Loop through all chromosomes and calculate insertion to deletion ratio
	ratios_list <- vector("list", length(chrm))
	for(i in chrm){
		positions_i <- z[[i]]
		types_i <- z[[i + 7]]

		ratios <- numeric(length(breakz) - 1)
		counter <- 1
		for(j in 1:(length(breakz) - 1)){
			positions_i_j <- positions_i[
				(positions_i >= breakz[j]) & (positions_i < breakz[j] + window)]
			types_i_j <- types_i[
				(positions_i >= breakz[j]) & (positions_i < breakz[j] + window)]
			n_inserts <- length( positions_i_j[types_i_j == "insertion"] )
			n_deletes <- length( positions_i_j[types_i_j == "deletion"] )
			ratios[counter] <- n_inserts / n_deletes
			counter <- counter + 1
		}
	ratios_list[[i]] <- ratios
	}
	
	# Unlist and store maximum and minimum ratio values
	ratios_max <- max(na.omit(unlist(ratios_list)))
	ratios_min <- min(na.omit(unlist(ratios_list)))

	# Adjust graphical parameters
	par(mfrow = c(length(chrm), 1), mar = c(0.5, 7, 0.5, 6), mgp = c(3.3, 1, 0), 
		oma = c(7, 0, 0, 0), cex.axis = 1.6)
	# Plot
	for(i in chrm){
		positions_i <- z[[i]]
		ratios_i <- ratios_list[[i]]
		
		# Set up plot
		plot(breakz[-length(breakz)] + (window / 2), ratios_i, 
			pch = 16, col = "transparent",
			xlim = c(0, x_max), ylim = c(ratios_min, ratios_max),
			xlab = "", ylab = "", axes = FALSE)
		# Centromere lines
		if(centromeres == "Yes"){
			abline(v = centromere_locs[i], lwd = 3, lty = 3)
		}
		# Color void space into which chromosome does not extend
		rect(max(positions_i), ratios_min, x_max, ratios_max,
			col = rgb(0, 0, 0, 0.2), border = "transparent")
		# Pot line
		lines(breakz[-length(breakz)] + (window / 2), ratios_i, lwd = 3, col = "red")
		# Rest of the plot fixin's
		axis(2, las = 1, at = signif(seq(ratios_min, 
			ratios_max, length.out = 3), 2))
		text(x_max, ((ratios_max - ratios_min) + ratios_min) * 0.8, pos = 4, 
			chrm_char[i], cex = 2, xpd = TRUE)
		if(i == median(chrm)){
			mtext(side = 2, line = 5, "n insertions / n deletions", 
				cex = 1.6)}
		if(i == max(chrm)){
			axis(1, at = round(seq(0, x_max, length.out = 10)))
			mtext(side = 1, line = 4, "Position", cex = 1.6)}else{
			axis(1, at = round(seq(0, x_max, length.out = 10)),
				labels = rep("", 10))}

  }
}

two_hists <- function(x, chrm, density){
	# Ony selected chromosome
	if(chrm != "All"){
		x <- x[x$chromosome %in% chrm, ]
	}
	# Calculate modulos of lengths by three and adjust to have correct sign
	signed_modulos <- (x$length %% 3) * (x$length / abs(x$length))
	# Count unique values
	coding_modulos_table <- table(signed_modulos[x$InCodingRegion == TRUE])
	noncoding_modulos_table <- table(signed_modulos[x$InCodingRegion == FALSE])
	
	# Adjust graphical parameters
	par(mar = c(6, 5, 2, 10), cex.lab = 1.5, cex.axis = 1.2)
	
	# Plot densities if requested
	if(density == "Density"){
	dens_coding_modulos_table <- 
		coding_modulos_table / sum(coding_modulos_table)
	dens_noncoding_modulos_table <- 
		noncoding_modulos_table / sum(noncoding_modulos_table)
	y_max <- max(c(dens_coding_modulos_table, dens_noncoding_modulos_table))
	plot(dens_coding_modulos_table, xlab = "", ylab = "",
		lwd = 5, col = "chartreuse3", las = 1,
		ylim = c(0, y_max))
	lines(dens_noncoding_modulos_table, xlab = "", ylab = "Count")
	mtext(side = 1, line = 2.5, "Indel length modulo 3 (re-signed)")
	mtext(side = 2, line = 4, "Density")
	}else{
	# Plot counts
	y_max <- max(c(coding_modulos_table, noncoding_modulos_table))
	plot(coding_modulos_table, xlab = "", ylab = "",
		lwd = 5, col = "chartreuse3", las = 1,
		ylim = c(0, y_max))
	lines(noncoding_modulos_table, xlab = "", ylab = "Count")
	mtext(side = 1, line = 2.5, "Indel length modulo 3 (re-signed)")
	mtext(side = 2, line = 4, "Count")
	}
	# Plot legend on top figure
	segments(-1.5, 1.1 * y_max, -1, 1.1 * y_max, col = "chartreuse3",
		lwd = 5, xpd = TRUE)
	segments(0.5, 1.1 * y_max, 1, 1.1 * y_max, xpd = TRUE)
	text(-1, 1.1 * y_max, xpd = TRUE,
		pos = 4, "Coding regions", font = 2, col = "chartreuse3")
	text(1, 1.1 * y_max, xpd = TRUE,
		pos = 4, "Noncoding regions", font = 2)
}







