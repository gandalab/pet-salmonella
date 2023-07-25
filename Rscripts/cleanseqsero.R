#Clean and combine SeqSero output 

# ---- load packages ----
library(dplyr)
library(tidylog)
library(stringr)
library(readr)

# ---- load raw SeqSero output ----
d <- read_tsv("tables/ssout/d_serosum.tsv")
h <- read_tsv("tables/ssout/h_serosum.tsv")

# ---- clean formatting from raw output and combine ----

# clean formatting 

d <- d %>%
  filter(`Sample name` != "Sample name") #remove redunant header rows

d <- d %>%
  mutate(Host = rep("Dog", nrow(d))) #add column for host assoc

h <- h %>%
  filter(`Sample name` != "Sample name") #remove redunant header rows

h <- h %>%
  mutate(Host = rep("Human", nrow(h))) #add column for host assoc

#combine

ssall <- rbind(h, d)

#remove output directory column and remove file extenstion where present 

ssall <- ssall %>%
  select(-c(`Output directory`, `Input files`))

ssall$`Sample name` <- str_remove_all(ssall$`Sample name`, "_contigs.fasta")

#save 
write.table(ssall, "tables/sero_combined.txt")

