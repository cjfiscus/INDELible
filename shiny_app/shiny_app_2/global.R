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


library(ggplot2)


