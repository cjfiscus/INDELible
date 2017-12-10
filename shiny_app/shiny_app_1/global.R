dat <- read.csv("indels.csv")
dat <- dat[dat$chromosome %in% levels(dat$chromosome)[1:5], ]
#dat <- dat[sample(100000, replace = FALSE), ]
dat$ref <- as.character(dat$ref)
dat$alt <- as.character(dat$alt)

dat$length <- (nchar(dat$alt) - 2) - nchar(dat$ref)

x <- list()
for(i in 1:5){
x[[i]] <- dat$position[dat$chromosome == i]
x[[i + 5]] <- dat$length[dat$chromosome == i]
}


chrom_hist_plot <- function(x, chrm, bins, in_or_del, test){

if(chrm == "All"){chrm <- 1:5}else{chrm <- as.numeric(chrm)}

keep_list <- list()
for(i in chrm){
if(in_or_del == "Insertions"){
	keep_list[[i]] <- x[[i]][x[[i + 5]] > 1]
	}else{
	if(in_or_del == "Deletions"){
		keep_list[[i]] <- x[[i]][x[[i + 5]] < 1]
		}else{
		keep_list[[i]] <- x[[i]]
		}
	}
}

all_vals <- unlist(keep_list[chrm])

x_min <- min(all_vals)
x_max <- max(all_vals)

window <- (x_max + (x_max %% bins)) / bins
x_end <- x_max + (x_max %% bins)
breakz <- seq(0, x_end, window)

max_counts <- numeric(5)
min_counts <- numeric(5)

for(i in chrm){
	h <- hist(keep_list[[i]], breaks = breakz, 
		plot = FALSE, test = "Chi-squared")
	max_counts[i] <- max(h$counts)
	min_counts[i] <- min(h$counts)
}

par(mfrow = c(length(chrm), 1), mar = c(0.5, 6, 0.5, 6), oma = c(7, 0, 0, 0),
	cex.axis = 1.6)
for(i in chrm){
	# Histogram
	hist(keep_list[[i]], axes = FALSE, xlab = "", ylab = "", main = "",
		col = "gray30", breaks = breakz,
		xlim = c(x_min, x_max), 
		ylim = c(min(min_counts), max(max_counts)))
	# Median line
	abline(v = median(keep_list[[i]]), lwd = 3, lty = 3, col = "red")
	# Color void space into which chromosome does not extend
	rect(max(keep_list[[i]]), min(min_counts), x_max, max(max_counts),
		col = rgb(0, 0, 0, 0.2), border = "transparent")
	axis(2, las = 1, at = round(seq(min(min_counts), 
		max(max_counts), length.out = 3)))
	text(x_max, (max(max_counts) - min(min_counts)) * 0.8, pos = 4, 
		bquote("Chr"~.(i)),
		cex = 2, font = 3, xpd = TRUE)
	if(test == "Chi-squared (counts)"){
	chi_bins <- hist(keep_list[[i]], breaks = breakz, plot = FALSE)
	chi_p_val <- chisq.test(chi_bins$counts)$p.value
	text(x_max, (max(max_counts) - min(min_counts)) * 0.45, pos = 4, 
		bquote("p ="~.(signif(chi_p_val, 3))),
		cex = 1.5, xpd = TRUE)
	}else{
		if(test == "K-S uniform"){
		ks_p_val <- ks.test(keep_list[[i]], 
			"punif", min(keep_list[[i]]), max(keep_list[[i]]))$p.value
		text(x_max, (max(max_counts) - min(min_counts)) * 0.45, pos = 4, 
			bquote("p ="~.(signif(ks_p_val, 3))),
			cex = 1.5, xpd = TRUE)
		}else{
			pois_bins <- hist(keep_list[[i]], breaks = breakz, plot = FALSE)
			pois_p_val <- ks.test(pois_bins$counts, 
				"ppois", lambda = mean(pois_bins$counts))$p.value
			text(x_max, (max(max_counts) - min(min_counts)) * 0.45, pos = 4, 
				bquote("p ="~.(signif(pois_p_val, 3))),
				cex = 1.5, xpd = TRUE)
			}
		}
	if(i == median(chrm)){
		mtext(side = 2, line = 4.5, "Count", cex = 1.6)}

	if(i == max(chrm)){
		axis(1, at = round(seq(0, x_max, length.out = 10)))
		mtext(side = 1, line = 4, "Position", cex = 1.6)}
}
}






