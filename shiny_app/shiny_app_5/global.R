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

# Define plot function for app.
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





