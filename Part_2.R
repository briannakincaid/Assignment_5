# The data was collected to gain insight about chemical treatments applied to food crops as fertilizer, insecticides, etc. 

library(tidyverse)
library(readxl)
library(stringr)

## IMPORT/READ (readr/readxl) 

veg.1 <- read_xlsx("veg1.xlsx")
cnames.1 <- colnames(veg.1)

## TIDY/CLEAN (tidyr)

# The goal here is to make the vegetable dataset tidy so that we can then more easily work with it. In order to make it tidy, we need to make it so
# each variable has its own column, each observation has its own row, and each value has its own cell. 

#First, get rid of the columns that only have NA values. 

c <- apply(veg.1, 2, n_distinct) #counts the number of unique values in EACH column 
d <- names(c[c==1]) #gives a vector of strings that represent the columns that only have one unique value
e <- names(c[c>1]) #gives a vector of strings that represent the columns that have more than one unique value

veg.2 <- select(veg.1, e) #veg.2 is now a new tibble with only columns that have more than one unique value
apply(veg.2, 2, n_distinct) #counts the number of unique values in EACH column

veg.3 <- rename(veg.2, 
              Geo = `Geo Level`, 
              State = `State ANSI`,
              Data = `Data Item`,
              Category = `Domain Category`)

unique(veg.3[,"Commodity"])
unique(veg.3[,"Data"]) %>% print(n=60)
unique(veg.3[,"Domain"])
unique(veg.3[,"Category"])
unique(veg.3[,"Value"])

veg.4 <- veg.3 %>%
  separate(Domain, into = c("Type1", "Type2"), sep = ", ") %>%
  separate(Category, into = c("Discard", "Name"), sep = ": ") %>%
  select(-Discard) %>%
  separate(Name, into = c("Name", "Code"), sep = "=") %>% 
  separate(Name, into = c("Discard", "Name"), sep = 1) %>%
  select(-Discard) %>%
  separate(Code, into = c("Code", "Discard"), sep = -1) %>%
  select(-Discard)

unique(veg.4[,"Type1"])
unique(veg.4[,"Type2"])

## TRANSFORM/ORGANIZE (dplyr)

#In class, we noted that some of the chemicals used on our food are classified RESTRICTED USE CHEMICALS. We isolated these chemicals in the veg1 dataset and found technical information about their toxicity in ECOTOX, the Beta version of ECOTOX, and the EPA Chenical Dashboard.

veg.4 %>%
  filter(Type1 == "RESTRICTED USE CHEMICAL") %>%
  group_by(Type2) %>%
  summarize(n = n())

veg.4 %>%
  group_by(Type1, Type2) %>%
  summarize(n = n())

#What is total??

View(veg.4 %>% 
  filter(Type1 == "RESTRICTED USE CHEMICAL") %>%
  group_by(Name) %>%
  summarize(n = n()))

#ABAMECTIN, BETA-CYFLUTHRIN, BIFENTHRIN, CHLORANTRANILIPROLE, CHLORPYRIFOS, CYFLUTHRIN, CYPERMETHRIN, DIAZINON, DICHLOROPROPENE, DIFLUBENZURON, DIMETHOATE, DISULFOTON, EMAMECTIN BENZOATE, ESFENVALERATE, FENPROPATHRIN, GAMMA-CYHALOTHRIN, IMIDACLOPRID, LAMBDA-CYHALOTHRIN, METHAMIDOPHOS, METHOMYL, NALED, OXYDEMETON-METHYL, PARAQUAT, PERMETHRIN, PRONAMIDE, THIAMETHOXAM, THIODICARB, ZETA-CYPERMETHRIN


  #Make a table of toxicity measurements (at least LD50 for a single experimental animal). Use this table and what you know about dplyr joins to augment your evaluation of chemical treatments applied to vegetables.

## VISUALIZE/EXPLORE -- Questions, Variation, Missing Values, Covariation, Patterns and Models  (ggplot2)

## SLIDES AND SHINY






