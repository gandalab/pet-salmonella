#AMR + VF Gene Profile Viz

# ---- load packages ----
library(tidyverse)
library(ggplot2)
library(data.table)

# ---- read in cleaned tables ----
vf <- read.delim("tables/vf_combined.txt", sep = "\t")
amr <- read.delim("tables/amr_combined.txt", sep = "\t")


# ---- set colors ----
dogamrcols <- c("Aminoglycosides" = "#331e8c",
                "Bacitracin" = "#ac4a65",
                "betalactams" = "#03762e",
                "Drug and metal resistance" = "lightgrey",
                "Drug and biocide resistance" = "grey", 
                "Drug and biocide and metal resistance" = "grey50",
                "Fluoroquinolones" ="#6397d0",
                "Fosfomycin" = "#85caf1",
                "Glycopeptides" = "#FDB863",
                "MLS" = "#892855",
                "Multi-drug resistance" = "#3ea899",
                "Phenicol" = "#999a1e",
                "Sulfonamides" = "#dece6d",
                "Tetracyclines" = "#ce6b75",
                "Trimethoprim" = "#ac489b")

humamrcols <- c("Aminoglycosides" = "#331e8c",
                "Bacitracin" = "#ac4a65",
                "betalactams" = "#03762e",
                "Drug and metal resistance" = "lightgrey",
                "Drug and biocide resistance" = "grey", 
                "Drug and biocide and metal resistance" = "grey50",
                "Fluoroquinolones" ="#6397d0",
                "MLS" = "#892855",
                "Multi-drug resistance" = "#3ea899",
                "Phenicol" = "#999a1e",
                "Sulfonamides" = "#dece6d",
                "Tetracyclines" = "#ce6b75",
                "Trimethoprim" = "#ac489b")

vfcols <- c("Adherence" = "#B35806",
            "Colonization" = "#E08214", 
            "Extraintestinal Invasion" = "#FDB863",
            "Immune Modulation" = "#FEE0B6",
            "Invasion" = "#D8DAEB",
            "Iron Sequestration" = "#B2ABD2", 
            "Toxicity" = "#542788",
            "Other" = "#8073AC") 

#---- AMR plot : order axes and case of gene names ----
amrdogorder <- amr %>%
  filter(P_A != 0) %>%
  filter(host_std =="dog")%>%
  select(Gene, Class) %>%
  arrange(Class, Gene) %>%
  unique() %>%
  select(Gene)

amrhumorder <- amr %>%
  filter(P_A != 0) %>%
  filter(host_std =="human")%>%
  select(Gene, Class) %>%
  arrange(Class, Gene) %>%
  unique() %>%
  select(Gene)

idamrorder <- amr %>%
  select(genome, host_std) %>%
  arrange(host_std, genome) %>%
  unique() %>%
  select(genome)

# convert amrg to gene name (not uppercase etc)

dogamrlower <- c("AAC3"= "aac(3)",     
                 "AAC6-PRIME"= "aac(6')",
                 "ACRA"= "acrA",       
                 "ACRB"= "acrB",  
                 "ACRD" = "acrD",    
                 "AMPH"= "ampH",    
                 "ANT3-DPRIME" = "ant(3'')",
                 "APH3-DPRIME"= "aph(3'')", 
                 "APH3-PRIME"= "aph(3')",  
                 "APH4"= "aph(4)",       
                 "APH6"= "aph(6)", 
                 "BACA" = "bacA",     
                 "BAER" = "baeR",       
                 "BAES"= "baeS",       
                 "BCR"  = "bcr",  
                 "BLE" = "ble",
                 "CARB" = "carB",      
                 "CMY"= "cmy",  
                 "CPXAR" = "cpxAR",     
                 "CRP"  = "crp",   
                 "CTX"= "ctx",     
                 "DFRA" = "dfrA",
                 "EMRA" = "emrA",      
                 "EMRB"= "emrB",       
                 "EMRD" = "emrD",      
                 "EMRR" = "emrR",   
                 "ERMB" = "ermB",     
                 "FLOR" = "floR",     
                 "FOSA" = "fosA",
                 "GESA"= "gesA",      
                 "GESB"= "gesB",       
                 "GESC" = "gesC",  
                 "HNS" = "hns",  
                 "KDPE" = "kdpE",   
                 "MARA" = "marA",      
                 "MARR" = "marR", 
                 "MDTA" = "mdtA",       
                 "MDTB" = "mdtB",       
                 "MDTC" = "mdtC",      
                 "MDTK" = "mdtK",      
                 "MPHA" = "mphA",   
                 "MSBA" = "msbA",    
                 "PBP2" = "pbp2",  
                 "PMRG" = "pmrG",  
                 "QNRA" = "qnrA",
                 "RAMA" = "ramA", 
                 "ROBA" = "robA", 
                 "SDIA" = "sdiA",
                 "SOXS"= "soxS",      
                 "SULI" = "sulI",      
                 "SULII" = "sulII",    
                 "TEM" = "tem", 
                 "TETA" = "tetA",      
                 "TETB"= "tetB",    
                 "YOGI" = "yogI")

humanamrlower <- c("AAC3"= "aac(3)",     
                   "AAC6-PRIME"= "aac(6')",
                   "ACRA"= "acrA",       
                   "ACRB"= "acrB",  
                   "ACRD" = "acrD",    
                   "AMPH"= "ampH",    
                   "ANT3-DPRIME" = "ant(3'')",
                   "APH3-DPRIME"= "aph(3'')", 
                   "APH6"= "aph(6)", 
                   "BACA" = "bacA",     
                   "BAER" = "baeR",       
                   "BAES"= "baeS",       
                   "BCR"  = "bcr",  
                   "CARB" = "carB",      
                   "CMLA"= "cmlA",  
                   "CPXAR" = "cpxAR",     
                   "CRP"  = "crp",   
                   "CTX"= "ctx",     
                   "DFRA" = "dfrA",
                   "EMRA" = "emrA",      
                   "EMRB"= "emrB",       
                   "EMRD" = "emrD",      
                   "EMRR" = "emrR",   
                   "FLOR" = "floR",     
                   "GESA"= "gesA",      
                   "GESB"= "gesB",       
                   "GESC" = "gesC",  
                   "HNS" = "hns",  
                   "KDPE" = "kdpE",   
                   "MARA" = "marA",      
                   "MARR" = "marR", 
                   "MDTA" = "mdtA",       
                   "MDTB" = "mdtB",       
                   "MDTC" = "mdtC",      
                   "MDTK" = "mdtK",      
                   "MPHA" = "mphA",   
                   "MSBA" = "msbA",    
                   "PBP2" = "pbp2",  
                   "PMRG" = "pmrG", 
                   "QACL" = "qacL",
                   "QNRA" = "qnrA",
                   "QNRB" = "qnrB",
                   "RAMA" = "ramA", 
                   "ROBA" = "robA", 
                   "SDIA" = "sdiA",
                   "SOXS"= "soxS",      
                   "SULI" = "sulI",      
                   "SULII" = "sulII",    
                   "TEM" = "tem", 
                   "TETA" = "tetA",      
                   "TETB"= "tetB",
                   "TETM"= "tetM",   
                   "YOGI" = "yogI")

#---- AMR plot : ggplot ----

# plot dog AMR genes: Figure 1A
ggplot(amr %>%
         filter(P_A != 0) %>%
         filter(host_std == "dog"), aes(x=genome, y=Gene, fill = Class)) +
  geom_tile(color = "black") +
  geom_vline(xintercept = 87.5)+
  theme_bw() +
  scale_fill_manual(values = dogamrcols ,breaks = c("Aminoglycosides",
                                                    "Bacitracin",
                                                    "betalactams",
                                                    "Drug and biocide and metal resistance",
                                                    "Drug and biocide resistance",
                                                    "Drug and metal resistance",
                                                    "Fluoroquinolones",
                                                    "Fosfomycin",
                                                    "Glycopeptides",
                                                    "MLS",
                                                    "Multi-drug resistance", 
                                                    "Phenicol", 
                                                    "Sulfonamides", 
                                                    "Tetracyclines",
                                                    "Trimethoprim"))+
  scale_y_discrete(limits = paste(rev(amrdogorder$Gene)), labels = dogamrlower)+
  coord_fixed() +
  theme(axis.text.y = element_text(angle = 0,  hjust = 1, size = 10, color = "black", face = "italic"),
        axis.text.x = element_text(size = 10, angle = 90, color = "black", vjust = 0.5, hjust = 1),
        axis.title = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black"),
        legend.position = "bottom",
        legend.text = element_text(color = "black")) +
  guides(fill = guide_legend(title = "Drug Class"))


# plot human AMR genes: Figure 1B
ggplot(amr %>%
         filter(P_A != 0) %>%
         filter(host_std == "human"), aes(x=genome, y=Gene, fill = Class)) +
  geom_tile(color = "black") +
  geom_vline(xintercept = 87.5)+
  theme_bw() +
  scale_fill_manual(values = humamrcols ,breaks = c("Aminoglycosides",
                                                    "Bacitracin",
                                                    "betalactams",
                                                    "Drug and biocide and metal resistance",
                                                    "Drug and biocide resistance",
                                                    "Drug and metal resistance",
                                                    "Fluoroquinolones",
                                                    "Fosfomycin",
                                                    "Glycopeptides",
                                                    "MLS",
                                                    "Multi-drug resistance", 
                                                    "Phenicol", 
                                                    "Sulfonamides", 
                                                    "Tetracyclines",
                                                    "Trimethoprim"))+
  scale_y_discrete(limits = paste(rev(amrhumorder$Gene)), labels = humanamrlower)+
  coord_fixed() +
  theme(axis.text.y = element_text(angle = 0,  hjust = 1, size = 10, color = "black", face = "italic"),
        axis.text.x = element_text(size = 10, angle = 90, color = "black", vjust = 0.5, hjust = 1),
        axis.title = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black"),
        legend.position = "bottom",
        legend.text = element_text(color = "black")) +
  guides(fill = guide_legend(title = "Drug Class"))

#---- VF plot : order axes ----

dogvforder <- vf %>%
  filter(host_std == "dog") %>%
  filter(P_A != 0) %>%
  select(Gene, Category) %>%
  arrange(Category, Gene) %>%
  unique() %>%
  select(Gene)

humvforder <- vf %>%
  filter(host_std == "human") %>%
  filter(P_A != 0) %>%
  select(Gene, Category) %>%
  arrange(Category, Gene) %>%
  unique() %>%
  select(Gene)

#---- VF plot : ggplot ----

# plot dog VF genes: Figure 2A
ggplot(vf %>%
         filter(P_A != 0) %>%
         filter(host_std == "dog"), aes(y=genome, x=Gene, fill = Category)) +
  geom_tile(color = "black") +
  theme_bw() +
  scale_fill_manual(values = vfcols) +
  coord_fixed() +
  scale_x_discrete(limits = paste(dogvforder$Gene))+
  theme(axis.text.x = element_text(angle = 90,  hjust = 1, size = 7, face = "italic", color = "black"),
        axis.text.y = element_text(size = 7, color = "black", hjust =0),
        axis.title = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black"),
        legend.position = "bottom",
        legend.text = element_text(color = "black")) +
  guides(fill = guide_legend(title = "Virulence Association"))

# plot human VF genes: Figure 2B
ggplot(vf %>%
         filter(P_A != 0) %>%
         filter(host_std == "human"), aes(y=genome, x=Gene, fill = Category)) +
  geom_tile(color = "black") +
  theme_bw() +
  scale_fill_manual(values = vfcols) +
  coord_fixed() +
  scale_x_discrete(limits = paste(humvforder$Gene))+
  theme(axis.text.x = element_text(angle = 90,  hjust = 1, size = 7, face = "italic", color = "black"),
        axis.text.y = element_text(size = 7, color = "black", hjust =1),
        axis.title = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black"),
        legend.position = "bottom",
        legend.text = element_text(color = "black")) +
  guides(fill = guide_legend(title = "Virulence Association"))
