# Determine SNP Differences

# --- load packages ---
library(tidyverse)
library(tidylog)


#---- read in full comparison table, subset ----

df <- read.delim("tables/dogphylo_comparisons.txt", header = FALSE)

#correct formatting
df <- df[2:nrow(df), 2:ncol(df)]
colnames(df) <- df[1,1:165]
df <- df[2:nrow(df), 1:164]
rownames(df) <- 1:nrow(df)

#arbitrarily subset into based on first column

s1 <- df %>% filter(SRR10298819_contig == "A")
s2 <- df %>% filter(SRR10298819_contig == "G")
s3 <- df %>% filter(SRR10298819_contig == "T")
s4 <- df %>% filter(SRR10298819_contig == "C")

#split further - last df in list of dfs might be a little smaller
s1_split <- split(s1, rep(1:20, each = round(nrow(s1)/20))) 
s2_split <- split(s2, rep(1:20, each = round(nrow(s2)/20))) 
s3_split <- split(s3, rep(1:20, each = round(nrow(s3)/20))) 
s4_split <- split(s4, rep(1:20, each = round(nrow(s4)/20))) 

# ---- create logical variable for if each position has any mismatches ----
#subset 1
for (i in 1:length(s1_split)) {
  s1_split[[i]] <- as.data.frame(s1_split[[i]]) %>%
    rowwise %>%
    mutate(match = n_distinct(unlist(pick(everything()))) == 1) %>%
    ungroup()
}

#subset 2
for (i in 1:length(s2_split)) {
  s2_split[[i]] <- as.data.frame(s2_split[[i]]) %>%
    rowwise %>%
    mutate(match = n_distinct(unlist(pick(everything()))) == 1) %>%
    ungroup()
}

#subset 3
for (i in 1:length(s3_split)) {
  s3_split[[i]] <- as.data.frame(s3_split[[i]]) %>%
    rowwise %>%
    mutate(match = n_distinct(unlist(pick(everything()))) == 1) %>%
    ungroup()
}

#subset 4
for (i in 1:length(s4_split)) {
  s4_split[[i]] <- as.data.frame(s4_split[[i]]) %>%
    rowwise %>%
    mutate(match = n_distinct(unlist(pick(everything()))) == 1) %>%
    ungroup()
}

# ---- Filter for only rows that have mismatches ---- 

#Make empty df and keep only rows with mismatches
s1_mismatch <- data.frame()

for (i in 1:length(s1_split)) {
  s1_mismatch <- rbind(s1_mismatch, as.data.frame(s1_split[[1]]) %>%
                         filter(match == "FALSE"))
}

#Make empty df and keep only rows with mismatches
s2_mismatch <- data.frame()

for (i in 1:length(s2_split)) {
  s2_mismatch <- rbind(s2_mismatch, as.data.frame(s2_split[[i]]) %>%
                         filter(match == "FALSE"))
}

#Make empty df and keep only rows with mismatches
s3_mismatch <- data.frame()

for (i in 1:length(s3_split)) {
  s3_mismatch <- rbind(s3_mismatch, as.data.frame(s3_split[[i]]) %>%
                         filter(match == "FALSE"))
}

#Make empty df and keep only rows with mismatches
s4_mismatch <- data.frame()

for (i in 1:length(s4_split)) {
  s4_mismatch <- rbind(s4_mismatch, as.data.frame(s4_split[[1]]) %>%
                         filter(match == "FALSE"))
}

# ---- Get number of differences between samples -----

# Drop the logical column
s1_mismatch <- s1_mismatch %>%
  select(-c(match))
s2_mismatch <- s2_mismatch %>%
  select(-c(match))
s3_mismatch <- s3_mismatch %>%
  select(-c(match))
s4_mismatch <- s4_mismatch %>%
  select(-c(match))


# Initialize an empty matrix to store the differences
num_rows <- nrow(s1_mismatch)
num_cols <- ncol(s1_mismatch)
difference_matrix <- matrix(0, nrow = num_cols, ncol = num_cols)

mismatch <- rbind(s1_mismatch, s2_mismatch, s3_mismatch, s4_mismatch)


# Loop through columns
for (i in 1:num_cols) {
  for (j in 1:num_cols) {
    # Calculate the number of differences between columns i and j
    differences <- sum(mismatch[, i] != mismatch[, j])
    
    # Store the result in the difference_matrix
    difference_matrix[i, j] <- differences
  }
}

colnames(difference_matrix) <- colnames(s1_mismatch)
rownames(difference_matrix) <- colnames(s1_mismatch)




