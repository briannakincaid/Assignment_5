# The data was collected to gain insight about chemical treatments applied to food crops as fertilizer, insecticides, etc. 

library(tidyverse)
library(readxl)
library(stringr)

## READ
veg.1 <- read_xlsx("veg1.xlsx")
names <- colnames(veg.1)

## TIDY/CLEAN

# The goal here is to make the vegetable dataset tidy so that we can then more easily work with it. In order to make it tidy, we need to make it so
# each variable has its own column, each observation has its own row, and each value has its own cell. 

#First, get rid of the columns that only have NA values. 

uniquevals <- apply(veg.1, 2, n_distinct) #counts the number of unique values in EACH column 
names_1 <- names(uniquevals[uniquevals==1]) #gives a vector of strings that represent the columns that only have one unique value
names_gt1 <- names(uniquevals[uniquevals>1]) #gives a vector of strings that represent the columns that have more than one unique value

veg.1 <- veg.1 %>%
  select(names_gt1) %>%
  rename(
    Geo = `Geo Level`, 
    State = `State ANSI`,
    Data = `Data Item`,
    Category = `Domain Category`
  )

# DOMAIN COLUMN

unique(veg.1[,"Domain"])
#Unique Values for Domain:
# CHEMICAL, FUNGICIDE                 
# CHEMICAL, HERBICIDE                 
# CHEMICAL, INSECTICIDE               
# CHEMICAL, OTHER                     
# RESTRICTED USE CHEMICAL, HERBICIDE  
# RESTRICTED USE CHEMICAL, INSECTICIDE
# RESTRICTED USE CHEMICAL, OTHER      
# PRACTICE, AVOIDANCE                 
# PRACTICE, MONITORING                
# PRACTICE, PREVENTION                
# PRACTICE, SUPPRESSION               
# TOTAL                               
# FERTILIZER 

#The only two that don't have two values are TOTAL and FERTILIZER 

veg.3 <- veg.1 %>%
  filter(Domain == "TOTAL" | Domain == "FERTILIZER") %>% 
  mutate(DomainCategory = NA) %>%
  select(Year, Geo, State, Region, Commodity, Data, Domain, DomainCategory, Category, Value)

veg.1 <- veg.1 %>%
  filter(Domain != "TOTAL" & Domain != "FERTILIZER") %>%
  separate(Domain, into = c("Domain", "DomainCategory"), sep = ", ")

veg.1 <- rbind(veg.1, veg.3)
  
unique(veg.1[,"Domain"])
  
#Unique Values for Domain:
# CHEMICAL               
# RESTRICTED USE CHEMICAL
# PRACTICE               
# TOTAL                  
# FERTILIZER

unique(veg.1[,"DomainCategory"])

#Unique values for DomainCategory
# FUNGICIDE  
# HERBICIDE  
# INSECTICIDE
# OTHER      
# AVOIDANCE  
# MONITORING 
# PREVENTION 
# SUPPRESSION
# NA

       
# CATEGORY COLUMN
View(unique(veg.1[,"Category"]))

#Only one value does not have : -- NOT SPECIFIED

veg.3 <- veg.1 %>%
  filter(Category == "NOT SPECIFIED") %>%
  rename("Description" = "Category") %>%
  mutate(Description = NA)

veg.1 <- veg.1 %>%
  filter(Category != "NOT SPECIFIED") %>%
  separate(Category, into = c("Discard", "Description"), sep = ": ") %>%
  select(-Discard)

veg.1 <- rbind(veg.1, veg.3)

# NAME COLUMN
View(unique(veg.1[,"Name"]))

veg.4 <- veg.1 %>%
  filter(grepl("=",Description)) %>% #this keep only the rows that have the form NAME = CODE
  separate(Description, into = c("Description", "Description2"), sep = "=") %>%
  mutate(
    Description = trimws(Description, "b"),
    Description2 = trimws(Description2, "b")) %>%
  separate(Description, into = c("Discard", "Description"), sep = 1) %>%
  separate(Description2, into = c("Description2", "Discard2"), sep = -1) %>%
  select(-Discard, -Discard2)

veg.5 <- veg.1 %>%
  filter(!grepl("=",Description)) %>%
  mutate(
    Description = trimws(Description, "b")) %>%
  separate(Description, into = c("Discard", "Description"), sep = 1) %>%
  separate(Description, into = c("Description", "Discard2"), sep = -1) %>%
  select(-Discard, -Discard2) %>%
  mutate(Description2 = NA) %>%
  select(Year, Geo, State, Region, Commodity, Data, Domain, DomainCategory, Description, Description2, Value)

veg.6 <- veg.5 %>%
  filter(grepl("-",Description)) %>%
  select(-Description2) %>%
  filter(Description != "NO-TILL OR MINIMUM TILL USED") %>%
  separate(Description, into = c("Description", "Description2"), sep = "-") %>%
  mutate(Description = trimws(Description, "b")) 

veg.7 <- filter(veg.5, Description == "NO-TILL OR MINIMUM TILL USED")
veg.8 <- filter(veg.5, !grepl("-",Description))

veg.1 <- rbind(veg.6,veg.7,veg.8)

## DATA COLUMN

#R can't handle the entire dataset into spread.. let's break it down
unique(veg.1[,"Domain"])

veg.1.practice <- veg.1 %>%
  filter(Domain == "PRACTICE")
veg.1.chemical <- veg.1 %>% 
  filter(Domain == "CHEMICAL")
veg.1.fertilizer <- veg.1 %>%
  filter(Domain == "FERTILIZER")
veg.1.totals <- veg.1 %>%
  filter(Domain == "TOTAL")

unique(veg.1.practice[,"Data"])

spread(veg.1.practice, key = Data, value = Value)






unique(veg.1[,"Geo"])
unique(veg.1[,"Region"])
unique(veg.1[,"Value"])
unique(veg.1[,"Commodity"])
unique(veg.1[,"Data"]) %>% print(n=60)

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






