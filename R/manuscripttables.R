# Descriptive Tables for Manuscript
# Sophia Kenney - 11 March 2024 

# ---- Load Packages ----
library(tidyverse)
library(tidylog)
library(rempsyc)
library(gtsummary)
library(gt)

# ----- Load Tables -----
met <- read.delim("tables/sampmeta.txt", sep = "\t")
amr <- read.delim("tables/amr_combined.txt", sep = "\t")
vf <- read.delim("tables/vf_combined.txt", sep = "\t") 


# ---- Create Tables -----
tab1 <- met %>%
  select(host_std, type_std, locale_std, year_std) %>%
  mutate(host_std = str_to_title(host_std)) %>%
  mutate(type_std = str_to_title(type_std)) %>%
  mutate(type_std = str_replace(type_std, "Csf", "Cerebrospinal Fluid")) %>%
  mutate(locale_std = str_split_fixed(locale_std, "\\:", 2)[,2]) %>%
  tbl_summary(by = host_std,
              label = list(
                type_std ~ "Specimen Type",
                locale_std ~ "Location (State)",
                year_std ~ "Collection Year"),
              statistic = all_categorical() ~ "{n}") %>%
  add_overall(last=TRUE) %>%
  bold_labels() %>%
  as_gt() %>%
  gt::tab_options(table.font.names = "Times New Roman")

tab2 <- met %>%
  select(host_std,serovar, species) %>%
  mutate(host_std = str_to_title(host_std)) %>%
  tbl_summary(by = host_std,
              label = list(
                serovar ~ "Serotype",
                species ~ "Species"),
              statistic = all_categorical() ~ "{n}") %>%
  add_overall(last=TRUE) %>%
  bold_labels() %>%
  as_gt() %>%
  gt::tab_options(table.font.names = "Times New Roman")

tab3 <- amr %>%
  filter(P_A != 0)%>%
  select(Class, host_std, Gene) %>%
  unique() %>%
  select(Class, host_std) %>%
  mutate(host_std = str_to_title(host_std)) %>%
  tbl_summary(by = host_std,
              statistic = all_categorical() ~ "{n}",
              label = list(
                Class ~ "Drug Class")) %>%
  bold_labels() %>%
  as_gt() %>%
  gt::tab_options(table.font.names = "Times New Roman")

tab4 <- vf %>%
  filter(P_A != 0)%>%
  select(Category, host_std, Gene) %>%
  unique() %>%
  select(Category, host_std) %>%
  mutate(host_std = str_to_title(host_std)) %>%
  tbl_summary(by = host_std,
              statistic = all_categorical() ~ "{n}",
              label = list(
                Category ~ "Virulence Category")) %>%
  bold_labels() %>%
  as_gt() %>%
  gt::tab_options(table.font.names = "Times New Roman")
