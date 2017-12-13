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
# and items 8-14 are insertion vs deletion.
x <- list()
for(i in 1:7){
x[[i]] <- dat$position[dat$chromosome == levels(dat$chromosome)[i]]
x[[i + 7]] <- ifelse(dat$length[dat$chromosome == i] > 0, "insertion", "deletion")
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
	all_vals <- unlist(x[chrm])

	# Max and min of position all values
	x_min <- min(all_vals)
	x_max <- max(all_vals)

	# Calculate breaks by window width
	x_end <- x_max + (window - (x_max %% window))
	breakz <- seq(0, x_end, window)


	# Loop through all chromosomes and calculate insertion to deletion ratio
	ratios_list <- vector("list", length(chrm))
	for(i in chrm){
		positions_i <- x[[i]]
		types_i <- x[[i + 7]]

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
		positions_i <- x[[i]]
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


ins_del_ratio_plot(x, window = 400000, chrm = "All", centromeres = "Yes")


