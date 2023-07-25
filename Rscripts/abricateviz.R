#AMR + VF Gene Profile Viz

# ---- load packages ----
library(stringr)
library(ggplot2)
library(dplyr)
library(data.table)

# ---- read in cleaned tables ----
vf <- read.delim("tables/vf_combined.txt", sep = "\t")
amr <- read.delim("tables/amr_combined.txt", sep = "\t")

# ---- set colors ----
amrcols <- c("Trimethoprim" = "#ac489b",
              "Fluoroquinolones" ="#6397d0",
              "Fosfomycin" = "#85caf1",
              "MLS" = "#892855",
              "Phenicol" = "#999a1e",
              "Multi-drug resistance" = "#3ea899",
              "Sulfonamides" = "#dece6d",
              "Tetracyclines" = "#ce6b75",
              "Bacitracin" = "#ac4a65",
              "betalactams" = "#03762e",
              "Aminoglycosides" = "#331e8c", 
              "Drug and metal resistance" = "lightgrey",
              "Drug and biocide resistance" = "grey", 
              "Drug and biocide and metal resistance" = "grey50")

vfcols <- c("Adherence" = "#B35806",
            "Colonization" = "#E08214", 
            "Extraintestinal Invasion" = "#FDB863",
            "Immune Modulation" = "#FEE0B6",
            "Invasion" = "#D8DAEB",
            "Iron Sequestration" = "#B2ABD2", 
            "Toxicity" = "#542788",
            "Other" = "#8073AC") 

#---- AMR plot : order axes and case of gene names ----
amrorder <- amr %>%
  filter(P_A != 0) %>%
  select(Gene, Class) %>%
  arrange(Class, Gene) %>%
  unique() %>%
  select(Gene)

idamrorder <- amr %>%
  select(pID, Host) %>%
  arrange(Host, pID) %>%
  unique() %>%
  select(pID)

# convert amrg to gene name (not uppercase etc)
amrglower <- c( "AAC3"= "aac(3)",     
                "AAC6-PRIME"= "aac(6')",
                "ANT3-DPRIME" = "ant(3'')",
                "APH3-DPRIME"= "aph(3'')", 
                "APH3-PRIME"= "aph(3')",  
                "APH4"= "aph(4)",       
                "APH6"= "aph(6)",       
                "KDPE" = "kdpE",      
                "BACA" = "bacA",       
                "AMPH"= "ampH",      
                "CARB" = "carB",      
                "CMY"= "cmy",        
                "CTX"= "ctx",         
                "PBP2" = "pbp2",      
                "TEM" = "tem",        
                "ACRD" = "acrD",      
                "BAER" = "baeR",       
                "BAES"= "baeS",       
                "GESA"= "gesA",      
                "GESB"= "gesB",       
                "GESC" = "gesC",       
                "MDTA" = "mdtA",       
                "MDTB" = "mdtB",       
                "MDTC" = "mdtC",      
                "ROBA" = "robA",       
                "SOXS"= "soxS",      
                "ACRA"= "acrA",       
                "ACRB"= "acrB",       
                "BCR"  = "bcr",      
                "CPXAR" = "cpxAR",     
                "CRP"  = "crp",      
                "EMRA" = "emrA",      
                "EMRB"= "emrB",       
                "EMRD" = "emrD",      
                "EMRR" = "emrR",      
                "MARA" = "marA",      
                "MARR" = "marR",      
                "MDTK" = "mdtK",      
                "YOGI" = "yogI",      
                "PMRG" = "pmrG",      
                "QNRB" = "qnrB",      
                "QNRS" = "qnrS",      
                "FOSA" = "fosA",      
                "ERMB" = "ermB",      
                "MPHA" = "mphA",       
                "HNS" = "hns",        
                "MSBA" = "msbA",      
                "RAMA" = "ramA",      
                "SDIA" = "sdiA",      
                "FLOR" = "floR",      
                "SULI" = "sulI",      
                "SULII" = "sulII",      
                "TETA" = "tetA",      
                "TETB"= "tetB",      
                "TETD" = "tetD",      
                "TETG" = "tetG",     
                "DFRA" = "dfrA")


#---- AMR plot : ggplot ----
ggplot(amr %>%
         filter(P_A != 0) , aes(y=pID, x=Gene, fill = Class)) +
  geom_tile(color = "black") +
  geom_hline(yintercept = 63.5)+
  theme_bw() +
  scale_fill_manual(values = amrcols ,breaks = c("Aminoglycosides",
                                                  "Bacitracin",
                                                  "betalactams",
                                                  "Drug and biocide and metal resistance",
                                                  "Drug and biocide resistance",
                                                  "Drug and metal resistance",
                                                  "Fluoroquinolones",
                                                  "Fosfomycin",
                                                  "MLS",
                                                  "Multi-drug resistance", 
                                                  "Phenicol", 
                                                  "Sulfonamides", 
                                                  "Tetracyclines",
                                                  "Trimethoprim"))+
  scale_x_discrete(limits = paste(amrorder$Gene), labels = amrglower)+
  scale_y_discrete(limits = paste(idamrorder$pID)) +
  coord_fixed() +
  theme(axis.text.x = element_text(angle = 90,  hjust = 1, size = 8, color = "black", face = "italic"),
        axis.text.y = element_text(size = 8, angle = 180, color = "black", hjust = 0),
        axis.title = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black"),
        legend.position = "right",
        legend.text = element_text(color = "black")) +
  guides(fill = guide_legend(title = "Drug Class"))

#---- VF plot : order axes ----
vforder <- vf %>%
  filter(P_A != 0) %>%
  select(Gene, Category) %>%
  arrange(Category, Gene) %>%
  unique() %>%
  select(Gene)

idvforder <- vf %>%
  select(pID, Host) %>%
  arrange(Host, pID) %>%
  unique() %>%
  select(pID)

# ---- VF plot: ggplot ----

ggplot(vf %>%
         filter(P_A != 0), aes(y=pID, x=Gene, fill = Category)) +
  geom_tile(color = "black") +
  geom_hline(yintercept = 63.5)+
  theme_bw() +
  scale_fill_manual(values = vfcols) +
  coord_fixed() +
  scale_x_discrete(limits = paste(vforder$Gene))+
  scale_y_discrete(limits = paste(idvforder$pID)) +
  theme(axis.text.x = element_text(angle = 90,  hjust = 1, size = 8, face = "italic", color = "black"),
        axis.text.y = element_text(angle = 180, size = 8, color = "black", hjust =0),
        axis.title = element_blank(),
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black"),
        legend.position = "right",
        legend.text = element_text(color = "black")) +
  guides(fill = guide_legend(title = "Virulence Association"))
