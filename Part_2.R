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
unique(veg.1[,"Category"])

#Only one value does not have ":" -- NOT SPECIFIED

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
unique(veg.1[,"Description"])


#this keep only the rows that have the form NAME = CODE
veg.4 <- veg.1 %>%
  filter(grepl("=",Description)) %>% 
  separate(Description, into = c("Description", "Description2"), sep = "=") %>%
  mutate(
    Description = trimws(Description, "b"),
    Description2 = trimws(Description2, "b")) %>%
  separate(Description, into = c("Discard", "Description"), sep = 1) %>%
  separate(Description2, into = c("Description2", "Discard2"), sep = -1) %>%
  select(-Discard, -Discard2)

  

#this keeps only the rows that DONT have the form NAME = CODE
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

veg.1 <- rbind(veg.6,veg.7,veg.8, veg.4)

## DATA COLUMN

unique(veg.1[,"Data"]) %>% print(n=28)
count(unique(veg.1[,"Data"]))

veg.1 <- veg.1 %>%
  separate(Data, into = c("Discard","Data"), sep = "-") %>%
  select(-Discard) %>%
  mutate(Data = trimws(Data, "b"))

#######################################################

BrusselsSprouts <- filter(veg.1, Commodity == "BRUSSELS SPROUTS")

count(unique(BrusselsSprouts[,"Data"]))

BrusselsSprouts <- BrusselsSprouts %>%
  select(-Commodity, -Region, -State) %>% 
  spread(key = Data, value = Value)

#######################################################

VegetablesTotals <- filter(veg.1, Commodity == "VEGETABLE TOTALS")
count(unique(VegetablesTotals[,"Data"]))

unique(VegetablesTotals[,"Year"])

############## 2006
VegetablesTotals.2006 <- VegetablesTotals %>%
  filter(Year == 2006)

count(unique(VegetablesTotals.2006[,"Data"]))

unique(VegetablesTotals.2006[,"DomainCategory"])

VegetablesTotals.2006.mon <- VegetablesTotals.2006 %>%
  filter(DomainCategory == "MONITORING")

VegetablesTotals.2006.pre <- VegetablesTotals.2006 %>%
  filter(DomainCategory == "PREVENTION") 

VegetablesTotals.2006.avo <- VegetablesTotals.2006 %>%
  filter(DomainCategory == "AVOIDANCE")
VegetablesTotals.2006.sup <- VegetablesTotals.2006 %>%
  filter(DomainCategory == "SUPPRESSION")

############## 2010
VegetablesTotals.2010 <- VegetablesTotals %>%
  filter(Year == 2010)

count(unique(VegetablesTotals.2010[,"Data"]))

############## 2014
VegetablesTotals.2014 <- VegetablesTotals %>%
  filter(Year == 2014)

count(unique(VegetablesTotals.2014[,"Data"]))

############## 2016
VegetablesTotals.2016 <- VegetablesTotals %>%
  filter(Year == 2016)

count(unique(VegetablesTotals.2016[,"Data"]))

#######################################################

VegetablesOther <- filter(veg.1, Commodity == "VEGETABLES, OTHER")

#######################################################

Broccoli <- filter(veg.1, Commodity == "BROCCOLI")

#######################################################

Cauliflower <- filter(veg.1, Commodity == "CAULIFLOWER")

#######################################################


unique(veg.1[,"Geo"])
unique(veg.1[,"Region"])
unique(veg.1[,"Value"])
unique(veg.1[,"Commodity"])
unique(veg.1[,"Data"]) %>% print(n=60)




## TRANSFORM/ORGANIZE (dplyr)

#In class, we noted that some of the chemicals used on our food are classified RESTRICTED USE CHEMICALS. We isolated these chemicals in the veg1 dataset and found technical information about their toxicity in ECOTOX, the Beta version of ECOTOX, and the EPA Chenical Dashboard.

RestrictedUseChemicals <- veg.1 %>%
  filter(Domain == "RESTRICTED USE CHEMICAL")

unique(RestrictedUseChemicals[,"Description"]) %>% print(n=60)
#There are 28 restricted use chemicals
# PARAQUAT
# ABAMECTIN
# BETA-CYFLUTHRIN
# BIFENTHRIN
# CHLORANTRANILIPROLE
# CHLORPYRIFOS
# CYFLUTHRIN
# EMAMECTIN BENZOATE
# ESFENVALERATE
# IMIDACLOPRID
# LAMBDA-CYHALOTHRIN
# METHOMYL
# NALED
# OXYDEMETON-METHYL
# PERMETHRIN
# THIAMETHOXAM
# ZETA-CYPERMETHRIN
# DICHLOROPROPENE
# DIAZINON
# DIMETHOATE
# DISULFOTON
# FENPROPATHRIN
# CYPERMETHRIN
# PRONAMIDE
# DIFLUBENZURON
# GAMMA-CYHALOTHRIN
# METHAMIDOPHOS
# THIODICARB

unique(RestrictedUseChemicals[,"Year"])

############## 2006
RestrictedUseChemicals.2006 <- RestrictedUseChemicals %>%
  filter(Year == 2006) %>%
  spread(key = Data, value = Value)

############## 2010
RestrictedUseChemicals.2010 <- RestrictedUseChemicals %>%
  filter(Year == 2010) %>%
  spread(key = Data, value = Value)

############## 2014
RestrictedUseChemicals.2014 <- RestrictedUseChemicals %>%
  filter(Year == 2014) %>%
  spread(key = Data, value = Value)

############## 2016
RestrictedUseChemicals.2016 <- RestrictedUseChemicals %>%
  filter(Year == 2016) %>%
  spread(key = Data, value = Value)

RestrictedUseChemicals <- rbind(
  RestrictedUseChemicals.2006, 
  RestrictedUseChemicals.2010, 
  RestrictedUseChemicals.2014, 
  RestrictedUseChemicals.2016)

RestrictedUseChemicals <- RestrictedUseChemicals %>%
  select(-State)

colnames(RestrictedUseChemicals)[9:13]
# "APPLICATIONS, MEASURED IN LB"
# "APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, AVG"
# "APPLICATIONS, MEASURED IN LB / ACRE / YEAR, AVG"
# "APPLICATIONS, MEASURED IN NUMBER, AVG"
# "TREATED, MEASURED IN PCT OF AREA PLANTED, AVG"

colnames(RestrictedUseChemicals) <- c(
  "Year",                                                 
  "Geo",                                                  
  "Region",                                               
  "Commodity",                                            
  "Domain",                                                
  "DomainCategory",                                       
  "Description",                                          
  "Description2",
  "Applications (lb)", 
  "Average Applications(lb/acre/application)", 
  "Average Applications(lb/acre/year)", 
  "Average Number of Applications", 
  "Percent Treated")

RestrictedUseChemicals <- RestrictedUseChemicals %>%
  mutate(
    Year = as.numeric(Year),                                                 
    `Applications (lb)` = as.numeric(`Applications (lb)`), 
    `Average Applications(lb/acre/application)` = as.numeric(`Average Applications(lb/acre/application)`), 
    `Average Applications(lb/acre/year)` = as.numeric(`Average Applications(lb/acre/year)`),
    `Average Number of Applications` = as.numeric(`Average Number of Applications`),
    `Percent Treated` = as.numeric(`Percent Treated`))

#Make a table of toxicity measurements (at least LD50 for a single experimental animal). 
#Use this table and what you know about dplyr joins to augment your evaluation of 
#chemical treatments applied to vegetables.


toxicity <- read_xlsx("toxicity.xlsx")

toxicity <- toxicity %>%
  rename(Description = Name)

RestrictedUseChemicals.tox <- left_join(RestrictedUseChemicals, toxicity, by = "Description")

## VISUALIZE/EXPLORE -- Questions, Variation, Missing Values, Covariation, Patterns and Models  (ggplot2)

## SLIDES AND SHINY






