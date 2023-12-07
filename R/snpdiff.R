# Determine SNP Differences

# --- load packages ---
library(tidyverse)
library(tidylog)


#---- read in full comparison table, subset ----
# table is available upon request - too large for github
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


# ---- Hierarchical clustering ----

snphclust <- hclust(dist(difference_matrix), method = "complete")
splittree <- as.data.frame(cutree(tree = as.dendrogram(snphclust), k = 6))

colnames(splittree)[1] <- c("cluster") # rename column

# Add meta
meta <- read.delim("tables/sampmeta.txt" , sep = "\t")

splittree$genome <- rownames(splittree)
splittree$genome <- str_remove_all(splittree$genome, "_contig")
splittree <- merge(splittree, meta, by = "genome")


# ----- Compare SNPs within cluster ----

# get list of samples by cluster - clusters 1 and 6 have 1 sample each
for (i in 1:6) {
  assign(paste0("clust", i), splittree %>%
           filter(`cluster` == i) %>%
           select(genome))
}

# first fix distance matrix to drop file extension
colnames(difference_matrix) <- str_remove_all(colnames(difference_matrix), "_contig")
rownames(difference_matrix) <- str_remove_all(rownames(difference_matrix), "_contig")


# subset distance matrix by cluster
#cluster2
diff2 <- as.data.frame(difference_matrix)[,which(names(as.data.frame(difference_matrix)) %in% clust2$genome)]
diff2 <- as.matrix(diff2[which(rownames(diff2) %in% clust2$genome),])

#cluster3
diff3 <- as.data.frame(difference_matrix)[,which(names(as.data.frame(difference_matrix)) %in% clust3$genome)]
diff3 <- as.matrix(diff3[which(rownames(diff3) %in% clust3$genome),])

#cluster4
diff4 <- as.data.frame(difference_matrix)[,which(names(as.data.frame(difference_matrix)) %in% clust4$genome)]
diff4 <- as.matrix(diff4[which(rownames(diff4) %in% clust4$genome),])

#cluster5
diff5 <- as.data.frame(difference_matrix)[,which(names(as.data.frame(difference_matrix)) %in% clust5$genome)]
diff5 <- as.matrix(diff5[which(rownames(diff5) %in% clust5$genome),])

# ---- Compare SNPs in dog vs human strains -----

library(data.table)
library(reshape2)

# make list of dog srrs and human srrs
dsr <- meta %>%
  filter(host_std == "dog") %>%
  select(genome)

hsr <- meta %>%
  filter(host_std == "human") %>%
  select(genome)

# add logical column for if the compared strains are from different hosts
zoo2 <- melt(diff2) %>% 
  filter(value <= 20) %>% # fewer than 20 SNP differences
  filter(value != 0) %>% # not the same strain comparison since melted from pairwise matrix
  mutate(zoo = case_when(
    Var1 %in% dsr$genome & Var2 %in% dsr$genome ~ FALSE,
    Var2 %in% dsr$genome & Var1 %in% dsr$genome ~ FALSE,
    Var1 %in% hsr$genome & Var2 %in% hsr$genome ~ FALSE,
    Var2 %in% hsr$genome & Var1 %in% hsr$genome ~ FALSE,
    Var1 %in% dsr$genome & Var2 %in% hsr$genome ~ TRUE,
    Var2 %in% dsr$genome & Var1 %in% hsr$genome ~ TRUE
  )) %>%
  filter(zoo == TRUE)  # keep only rows where hosts are different


zoo3 <- melt(diff3) %>% 
  filter(value <= 20) %>% # fewer than 20 SNP differences
  filter(value != 0) %>% # not the same strain comparison since melted from pairwise matrix
  mutate(zoo = case_when(
    Var1 %in% dsr$genome & Var2 %in% dsr$genome ~ FALSE,
    Var2 %in% dsr$genome & Var1 %in% dsr$genome ~ FALSE,
    Var1 %in% hsr$genome & Var2 %in% hsr$genome ~ FALSE,
    Var2 %in% hsr$genome & Var1 %in% hsr$genome ~ FALSE,
    Var1 %in% dsr$genome & Var2 %in% hsr$genome ~ TRUE,
    Var2 %in% dsr$genome & Var1 %in% hsr$genome ~ TRUE
  )) %>%
  filter(zoo == TRUE)  # keep only rows where hosts are different

zoo4 <-melt(diff4) %>% 
  filter(value <= 20) %>% # fewer than 20 SNP differences
  filter(value != 0) %>% # not the same strain comparison since melted from pairwise matrix
  mutate(zoo = case_when(
    Var1 %in% dsr$genome & Var2 %in% dsr$genome ~ FALSE,
    Var2 %in% dsr$genome & Var1 %in% dsr$genome ~ FALSE,
    Var1 %in% hsr$genome & Var2 %in% hsr$genome ~ FALSE,
    Var2 %in% hsr$genome & Var1 %in% hsr$genome ~ FALSE,
    Var1 %in% dsr$genome & Var2 %in% hsr$genome ~ TRUE,
    Var2 %in% dsr$genome & Var1 %in% hsr$genome ~ TRUE
  )) %>%
  filter(zoo == TRUE) # keep only rows where hosts are different

zoo5 <- melt(diff5) %>% 
  filter(value <= 20) %>% # fewer than 20 SNP differences
  filter(value != 0) %>% # not the same strain comparison since melted from pairwise matrix
  mutate(zoo = case_when(
    Var1 %in% dsr$tip.label & Var2 %in% dsr$tip.label ~ FALSE,
    Var2 %in% dsr$tip.label & Var1 %in% dsr$tip.label ~ FALSE,
    Var1 %in% hsr$tip.label & Var2 %in% hsr$tip.label ~ FALSE,
    Var2 %in% hsr$tip.label & Var1 %in% hsr$tip.label ~ FALSE,
    Var1 %in% dsr$tip.label & Var2 %in% hsr$tip.label ~ TRUE,
    Var2 %in% dsr$tip.label & Var1 %in% hsr$tip.label ~ TRUE
  )) %>%
  filter(zoo == TRUE)  # keep only rows where hosts are different

zooall <- rbind(zoo2, zoo5) # only cluster 2 and 5 had <20 SNP differences in strains from different hosts

#save these
#write.table(zooall, "tables/hd_snpdiff.txt", sep = "\t")

#read back in after removing (in excel) rows that duplicate strain combos
zooall <- read.delim("tables/hd_snpdiff.txt", sep = "\t")

#add host column
zooall <- zooall %>%
  mutate(hostVar1 = case_when(
    Var1 %in% dsr$genome ~ "dog",
    Var1 %in% hsr$genome ~ "human"
  )) %>%
  mutate(hostVar2 = case_when(
    Var2 %in% dsr$genome ~ "dog",
    Var2 %in% hsr$genome ~ "human"
  ))


# add metadata
zooall <- merge(zooall, meta %>%
                  filter(genome %in% zooall$Var1) %>%
                  mutate(Var1_sero = serovar) %>%
                  select(genome, Var1_sero), by = "genome")

zooall <- merge(zooall, meta %>%
                  filter(genome %in% zooall$Var2) %>%
                  mutate(Var2_sero = serovar) %>%
                  select(genome, Var2_sero), by = "genome")

# clean foramtting and save
# since serovars match, keep just one column, fix columns 
zooall <- zooall %>%
  mutate(`Dog Strain` = Var2) %>%
  mutate(`Human Strain` = Var1) %>%
  mutate(`SNP Differences` = value) %>%
  mutate(Serovar = Var1_sero) %>%
  select(`Dog Strain`, `Human Strain`, `SNP Differences`, Serovar )

write.table(zooall, "tables/snpcomparehost.txt", sep = "\t")
  








