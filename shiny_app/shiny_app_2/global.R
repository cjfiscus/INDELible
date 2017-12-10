dat <- read.csv("indels.csv")
dat <- dat[dat$chromosome %in% levels(dat$chromosome)[1:5], ]
dat$chromosome <- as.character(dat$chromosome)
dat$chromosome <- as.factor(dat$chromosome)
dat$ref <- as.character(dat$ref)
dat$alt <- as.character(dat$alt)
dat$length <- (nchar(dat$alt) - 2) - nchar(dat$ref)

colnames(dat) <- c("X", "alt", "Chromosome", "Position", "ref", "Length")

library(ggplot2)


