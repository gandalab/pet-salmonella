#Abricate Output to Dataframe for Viz

# ---- load packages ----
library(dplyr)
library(stringr)
library(reshape2)
library(tidylog)

# ---- load raw AMR data + metadata ----
dA <- read.delim("tables/abricateout/dog_amr_summary.txt", sep = "\t")
hA <- read.delim("tables/abricateout/human_amr_summary.txt", sep = "\t")
met <- read.delim("tables/meta_withsero.txt", sep = "\t")


# ---- clean formatting ----

#--remove file extension from sample name
dA$X.FILE <- str_remove(dA$X.FILE, "_contigs.fasta")
hA$X.FILE <- str_remove(hA$X.FILE, "_contigs.fasta")

#--convert to count matrix

#dog
dA[3:ncol(dA)] <- replace(dA[3:ncol(dA)], dA[3:ncol(dA)] !=".", 1 ) #replace presence as 1
dA[3:ncol(dA)] <- replace(dA[3:ncol(dA)], dA[3:ncol(dA)] ==".", 0 ) #replace absence as 0
dA[3:ncol(dA)] <- sapply(dA[3:ncol(dA)], as.numeric) #convert to numeric

#human
hA[3:ncol(hA)] <- replace(hA[3:ncol(hA)], hA[3:ncol(hA)] !=".", 1 ) #replace presence as 1
hA[3:ncol(hA)] <- replace(hA[3:ncol(hA)], hA[3:ncol(hA)] ==".", 0 ) #replace absence as 0
hA[3:ncol(hA)] <- sapply(hA[3:ncol(hA)], as.numeric) #convert to numeric

#--subset just count matrix
#dog
rownames(dA) <- dA$X.FILE
dA2 <- dA[3:ncol(dA)]

#human
rownames(hA) <- hA$X.FILE
hA2 <- hA[3:ncol(hA)]

# ---- combine + add gene and sample info ----
#melt into table
dmelt <- reshape2::melt(as.matrix(dA2))
hmelt <- reshape2::melt(as.matrix(hA2))

#combine
both <- rbind(dmelt, hmelt)
colnames(both) <- c("ID", "Gene", "P_A")

#add sample data
both <- merge(both, met, by = "ID")

#add AMR gene database info
geneinfo <- read.csv("tables/megares_full_annotations_v2.00.csv")
colnames(geneinfo)[2:5] <- c("Broadclass", "Class", "Mechanism", "Gene") #fix names 

#correct differences in punctuation
both$Gene <- str_replace_all(both$Gene, "\\.PRIME", "-PRIME")
both$Gene <- str_replace_all(both$Gene, "\\.DPRIME", "-DPRIME")

both <- merge(both, geneinfo %>%
                select(Broadclass, Class, Gene) %>%
                unique(), by = "Gene")
#save table
write.table(both, "tables/amr_combined.txt", sep = "\t")


# ---- load raw VF data ----
dV <- read.delim("abricateout/dog_vf_summary.txt", sep = "\t")
hV <- read.delim("abricateout/human_vf_summary.txt", sep = "\t")

# ---- clean formatting ----

#--remove file extension from sample name
dV$X.FILE <- str_remove(dV$X.FILE, "_contigs.fasta")
hV$X.FILE <- str_remove(hV$X.FILE, "_contigs.fasta")

#--convert to count matrix

#dog
dV[3:ncol(dV)] <- replace(dV[3:ncol(dV)], dV[3:ncol(dV)] !=".", 1 ) #replace presence as 1
dV[3:ncol(dV)] <- replace(dV[3:ncol(dV)], dV[3:ncol(dV)] ==".", 0 ) #replace absence as 0
dV[3:ncol(dV)] <- sapply(dV[3:ncol(dV)], as.numeric) #convert to numeric

#human
hV[3:ncol(hV)] <- replace(hV[3:ncol(hV)], hV[3:ncol(hV)] !=".", 1 ) #replace presence as 1
hV[3:ncol(hV)] <- replace(hV[3:ncol(hV)], hV[3:ncol(hV)] ==".", 0 ) #replace absence as 0
hV[3:ncol(hV)] <- sapply(hV[3:ncol(hV)], as.numeric) #convert to numeric

#--subset just count matrix
#dog
rownames(dV) <- dV$X.FILE
dV2 <- dV[3:ncol(dV)]

#human
rownames(hV) <- hV$X.FILE
hV2 <- hV[3:ncol(hV)]


# ---- combine + add gene and sample info ----
#melt into table
dmelt_VF <- reshape2::melt(as.matrix(dV2))
hmelt_VF <- reshape2::melt(as.matrix(hV2))

#combine
both_VF <- rbind(dmelt_VF, hmelt_VF)
colnames(both_VF) <- c("ID", "Gene", "P_A")

#add sample data
both_VF <- merge(both_VF, met, by = "ID")

#add AMR gene database info
vfinfo <- read.csv("tables/vfdb_annotated.csv")

#correct differences in punctuation
vfinfo$Gene <- str_replace_all(vfinfo$Gene, "\\/", "\\.")
vfinfo$Gene <- str_replace_all(vfinfo$Gene, "\\-", "\\.")

both_VF <- merge(both_VF, vfinfo[2:ncol(vfinfo)], by = "Gene")

#save table
write.table(both_VF, "tables/vf_combined.txt", sep = "\t")

