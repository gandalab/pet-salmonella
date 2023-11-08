# Phylogeny Viz

# ---- load packages ----
library(ape)
library(tidyverse)
library(ggtree)
library(ggnewscale)

# ---- load phame output tree and ID meta ----
tree <- ape::read.tree(file = "trees/dog-allsnps_fastree")
meta <- read.delim("tables/meta.txt")

tree$tip.label<- str_replace(tree$tip.label, "_contig", "") #drop file extension


# ---- Plot Tree ----

#plot inner tree
p <- ggtree(tree, layout = "circular", branch.length = "none")  %<+% meta +
  geom_tippoint(size =2, aes(color = species)) +
  scale_color_viridis_d(name="Species") +
  theme(legend.position = "bottom") +
  guides(color = guide_legend(ncol = 1))

#add host ring
p2 <- gheatmap(p, meta %>%
           select(host_std), offset = 0.1 , width = 0.1,
         colnames = FALSE, legend_title = "Host") +
  scale_fill_manual(values = c(
    dog = "#BFD3E6",
    human = "#8C96C6"
  ), name = "Host", labels = c("Dog", "Human")) +
  theme(plot.title = element_text(hjust = 0.5))+
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(ncol = 1))

#add year ring : Figure 3
gheatmap(p2 + new_scale_fill(), meta %>%
           select(year_std) %>%
           mutate(year_std = as.factor(year_std)), offset = 3, width = 0.1,
         colnames = FALSE, legend_title = "Year") +
  scale_fill_brewer(palette = "YlOrRd", name = "Year") +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(ncol = 3)) +
  geom_tiplab(size = 2, hjust = -1.7)


