# Reformat Abricate Output

#load packages
library(tidyverse)
library(tidylog)
library(reshape2)


# ---- read in raw output and metadata ----
amr <- read.delim("tables/abricateout/amr_summary.txt")
vf <- read.delim("tables/abricateout/vf_summary.txt")
met <- read.delim("tables/meta.txt", sep = "\t")

# ---- clean formatting ----

#remove file extension from sample name
amr$X.FILE <- str_remove(amr$X.FILE, "_assembly.fasta")
vf$X.FILE <- str_remove(vf$X.FILE, "_assembly.fasta")


# ---- convert to count matrix ----

#amr
amr[3:ncol(amr)] <- replace(amr[3:ncol(amr)], amr[3:ncol(amr)] !=".", 1 ) #replace presence as 1
amr[3:ncol(amr)] <- replace(amr[3:ncol(amr)], amr[3:ncol(amr)] ==".", 0 ) #replace absence as 0
amr[3:ncol(amr)] <- sapply(amr[3:ncol(amr)], as.numeric) #convert to numeric

#vf
vf[3:ncol(vf)] <- replace(vf[3:ncol(vf)], vf[3:ncol(vf)] !=".", 1 ) #replace presence as 1
vf[3:ncol(vf)] <- replace(vf[3:ncol(vf)], vf[3:ncol(vf)] ==".", 0 ) #replace absence as 0
vf[3:ncol(vf)] <- sapply(vf[3:ncol(vf)], as.numeric) #convert to numeric

# ---- subset just count matrix ----
#amr
rownames(amr) <- amr$X.FILE
amr2 <- amr[3:ncol(amr)]

#vf 
rownames(vf) <- vf$X.FILE
vf2 <- vf[3:ncol(vf)]


# ---- AMR: add gene and sample info ----

amrmelt <- reshape2::melt((as.matrix(amr2)))
colnames(amrmelt) <- c("genome", "Gene", "P_A")

amrmelt <- merge(amrmelt, met, by = "genome")

#add AMR gene database info
geneinfo <- read.csv("tables/megares_full_annotations_v2.00.csv")
colnames(geneinfo)[2:5] <- c("Broadclass", "Class", "Mechanism", "Gene") #fix names 

#correct differences in punctuation
amrmelt$Gene <- str_replace_all(amrmelt$Gene, "\\.PRIME", "-PRIME")
amrmelt$Gene <- str_replace_all(amrmelt$Gene, "\\.DPRIME", "-DPRIME")

amrmelt <- merge(amrmelt, geneinfo %>%
                   select(Broadclass, Class, Gene) %>%
                   unique(), by = "Gene")
#save table
write.table(amrmelt, "tables/amr_combined.txt", sep = "\t")

# ---- VF: add gene and sample info ----

vfmelt <- reshape2::melt((as.matrix(vf2)))
colnames(vfmelt) <- c("genome", "Gene", "P_A")

vfmelt <- merge(vfmelt, met, by = "genome")


#add VF gene database info
vfinfo <- read.csv("tables/vfdb_annotated.csv")

#correct differences in punctuation
vfinfo$Gene <- str_replace_all(vfinfo$Gene, "\\/", "\\.")
vfinfo$Gene <- str_replace_all(vfinfo$Gene, "\\-", "\\.")

vfmelt <- merge(vfmelt, vfinfo[2:ncol(vfinfo)], by = "Gene")

#save table
write.table(vfmelt, "tables/vf_combined.txt", sep = "\t")

#save work
save.image("cleanabricate.RData")

