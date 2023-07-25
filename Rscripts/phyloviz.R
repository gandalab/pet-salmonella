# Phylogeny Viz

# ---- load packages ----
library(ape)
library(stringr)
library(dplyr)
library(ggtree)

# ---- load phame output tree and ID meta ----
tree <- ape::read.tree(file = "trees/RAxML_bipartitions.phame_both_best")
salids <- read.delim("tables/meta_tree.txt", sep = "")

# ---- clean tip labels ----

tree$tip.label<- str_replace(tree$tip.label, "_contig", "") #drop file extension
tree$tip.label<- str_replace(tree$tip.label, "h_", "") #drop file extension
tree$tip.label<- str_replace(tree$tip.label, "d_", "") #drop file extension

tiplabs <- as.data.frame(tree$tip.label) #tip labels from tree

colnames(tiplabs)[1] <- "ID" #rename column header

tipidx <- match(tiplabs$ID, salids$ID) #get ordering

salids_ordered <- salids[tipidx, ] #reorder

# keep just pID

tiplabs_ord <- salids_ordered$pID

tiplabs_ord <- str_replace(tiplabs_ord, "_", " ") %>%
  str_replace("Salmonella 4__5__12_i__", "Salmonella I 4,[5],12:i:-" ) %>% #clean named strains
  str_replace("Salmonella", "S. ")

# assign back to tree

tree$tip.label <- tiplabs_ord

# ---- plot tree ----

rotate_tree(ggtree(tree, layout = "circular", branch.length = "none") + 
              geom_tiplab(size = 4) +#add tip labels
              geom_nodepoint() +
              geom_hilight(node=148, fill="darkblue") +
              geom_cladelabel(node = 148, label = "subspecies III", angle = 20, hjust = "left", offset = 4, align = T, color = "darkblue") +
              geom_hilight(node=149, fill="red") +
              geom_cladelabel(node = 149, label = "subspecies IV", angle = 30, hjust = "left", offset = 4, align = T, color = "red"), 90)


