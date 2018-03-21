# The data was collected to gain insight about chemical treatments applied to food crops as fertilizer, insecticides, etc. 

library(tidyverse)
library(readxl)
library(stringr)

## READ
veg.1 <- read_xlsx("veg1.xlsx", na = "(D)")
#D = Withheld to avoid  disclosing data for individual  operations. = NA 
names <- colnames(veg.1)


## TIDY/CLEAN

# The goal here is to make the vegetable dataset tidy so that we can then more easily work with it. In order to make it tidy, we need to make it so
# each variable has its own column, each observation has its own row, and each value has its own cell. 

##### First, get rid of the columns that only have NA values. 

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

View(veg.1)
colnames(veg.1)

##### Then, clean (separate) the columns one at a time 

########## DOMAIN COLUMN

unique(veg.1[,"Domain"])

# The only two that don't have two values are TOTAL and FERTILIZER 
# The rest are obviously broken up into Domain and SubDomain

# Let's filter out the TOTAL and FERTILIZER rows for now. 

veg.2 <- veg.1 %>%
  filter(Domain == "TOTAL" | Domain == "FERTILIZER") %>% 
  mutate(SubDomain = NA) %>%
  select(Year, Geo, State, Region, Commodity, Data, Domain, SubDomain, Category, Value)

# veg.2 now holds the rows that have TOTAL or FERTILIZER in the Domain column and NA in the SubDomain column.
# We'll bind this back with the whole data set later. 

# Let's look at all the other rows now. 

veg.1 <- veg.1 %>%
  filter(Domain != "TOTAL" & Domain != "FERTILIZER") %>%
  separate(Domain, into = c("Domain", "SubDomain"), sep = ", ")

# veg.1 now just holds the rows that don't have TOTAL or FERTILIZER in the Domain column and 
# the Domain column has been separated into Domain and SubDomain

#Now, let's bind veg.2 back on. 

veg.1 <- rbind(veg.1, veg.2)

unique(veg.1[,"Domain"])

#Unique Values for Domain:
# CHEMICAL               
# RESTRICTED USE CHEMICAL
# PRACTICE               
# TOTAL                  
# FERTILIZER

unique(veg.1[,"SubDomain"])

#Unique values for SubDomain
# FUNGICIDE  
# HERBICIDE  
# INSECTICIDE
# OTHER      
# AVOIDANCE  
# MONITORING 
# PREVENTION 
# SUPPRESSION
# NA


########## CATEGORY COLUMN
unique(veg.1[,"Category"])

# Most of the rows are in the form DOMAIN, SUBDOMAIN: (Description)
# The only rows that are not in this form have the value "NOT SPECIFIED" in the Category column

#Let's filter so we just have the rows with "NOT SPECIFIED" in the Category column

veg.3 <- veg.1 %>%
  filter(Category == "NOT SPECIFIED") %>%
  rename("Description" = "Category") %>%
  mutate(Description = NA)

# veg.3 now just holds the rows that now have NA in the Description column. We'll bind these back onto
# the whole data set later. 

unique(veg.3[,"Domain"])
#These rows are all just TOTALS

veg.1 <- veg.1 %>%
  filter(Category != "NOT SPECIFIED") %>%
  separate(Category, into = c("Discard", "Description"), sep = ": ") %>%
  select(-Discard)

# veg.1 now holds the rows that were of the form DOMAIN, SUBDOMAIN: (Description) in the Category column.
# We separted DOMAIN, SUBDOMAIN and (Description) and renamed the column with (Description) to "Description"

#Let's bind them back together
veg.1 <- rbind(veg.1, veg.3)

########## NAME COLUMN (CATEGORY COLUMN, PT. 2)
unique(veg.1[,"Description"])

# We want to keep only the rows that have the form NAME = NUMBER and separate it into two separate 
# description files 

veg.4 <- veg.1 %>%
  filter(grepl("=",Description)) %>% 
  separate(Description, into = c("Description", "Description2"), sep = "=") %>%
  mutate(
    Description = trimws(Description, "b"),
    Description2 = trimws(Description2, "b")) %>%
  separate(Description, into = c("Discard", "Description"), sep = 1) %>%
  separate(Description2, into = c("Description2", "Discard2"), sep = -1) %>%
  select(-Discard, -Discard2)

#veg.4 now holds all the rows that had the form NAME = NUMBER, now separated into two Description columns

#Now let's work with all the other rows
veg.5 <- veg.1 %>%
  filter(!grepl("=",Description)) %>%
  mutate(
    Description = trimws(Description, "b")) %>%
  separate(Description, into = c("Discard", "Description"), sep = 1) %>% 
  separate(Description, into = c("Description", "Discard2"), sep = -1) %>%
  select(-Discard, -Discard2) %>%
  mutate(Description2 = NA) %>%
  select(Year, Geo, State, Region, Commodity, Data, Domain, SubDomain, Description, Description2, Value)

veg.6 <- veg.5 %>%
  filter(grepl("-",Description)) %>%
  select(-Description2) %>%
  filter(Description != "NO-TILL OR MINIMUM TILL USED") %>%
  separate(Description, into = c("Description", "Description2"), sep = "-") %>%
  mutate(Description = trimws(Description, "b")) 

veg.7 <- filter(veg.5, Description == "NO-TILL OR MINIMUM TILL USED")
veg.8 <- filter(veg.5, !grepl("-",Description))

veg.1 <- rbind(veg.6,veg.7,veg.8, veg.4)

########## DATA COLUMN

veg.1 <- veg.1 %>%
  separate(Data, into = c("Discard","Data"), sep = "-") %>%
  select(-Discard) %>%
  mutate(Data = trimws(Data, "l"))

#Before we go on, there are (Z) values in the Value column

#Z = Less than half the rounding unit. = 0

veg.1.z <- veg.1 %>%
  filter(Value == "(Z)") %>%
  mutate(Value = 0)

veg.1 <- rbind(veg.1.z, filter(veg.1, Value != "(Z)"))

veg.1 <- veg.1 %>%
  mutate(Value = as.numeric(Value))

unique_data <- unique(veg.1[,"Data"])

#veg.1 <- spread(veg.1, key = Data, value = Value)

#The spread is not working on the whole data set (R crashes). Let's try breaking it down by Commodity. 

################## Brussel Sprouts

BrusselsSprouts <- filter(veg.1, Commodity == "BRUSSELS SPROUTS")

count(unique(BrusselsSprouts[,"Data"]))

BrusselsSprouts <- BrusselsSprouts %>%
  select(-Commodity, -Region, -State) %>% 
  spread(key = Data, value = Value)

#Works for Brussel Sprouts!!


################## VEGETABLE TOTALS

VegetablesTotals <- filter(veg.1, Commodity == "VEGETABLE TOTALS")
count(unique(VegetablesTotals[,"Data"]))

#VegetablesTotals <- Vegetables %>% 
  #spread(key = Data, value = Value)

#Does not work for Vegetable Totals.

#It seems that the data is too large for spread to handle, and there is some sort of memory problem.
#We could break it down into tibbles of similar size to BrusselsSprouts, but that may be too tedius.
#We can get the same result as spread() by the doing the following (which is still tedius, and I would
#still much rather use spread to do this, but again, it's not working...):

####################### DIY spread()

veg.1.1 <- veg.1 %>%
  filter(Data == "PEST MGMT, MEASURED IN PCT OF AREA PLANTED") %>%
  select(-Data) %>%
  rename("PEST MGMT, MEASURED IN PCT OF AREA PLANTED" = Value)

veg.1.2 <- veg.1 %>%
  filter(Data == "PEST MGMT, MEASURED IN PCT OF OPERATIONS") %>%
  select(-Data) %>%
  rename("PEST MGMT, MEASURED IN PCT OF OPERATIONS" = Value)

veg.1.3 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB" = Value)

veg.1.4 <- veg.1 %>%
  filter(Data == "TREATED, MEASURED IN PCT OF AREA PLANTED, AVG") %>%
  select(-Data) %>%
  rename("TREATED, MEASURED IN PCT OF AREA PLANTED, AVG" = Value)

veg.1.5 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, AVG") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, AVG" = Value)

veg.1.6 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / YEAR, AVG ") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / YEAR, AVG " = Value)

veg.1.7 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN NUMBER, AVG") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN NUMBER, AVG" = Value)

veg.1.8 <- veg.1 %>%
  filter(Data == "ACRES POLLINATED, PAID BASIS") %>%
  select(-Data) %>%
  rename("ACRES POLLINATED, PAID BASIS" = Value)

veg.1.9 <- veg.1 %>%
  filter(Data == "POLLINATION, MEASURED IN $ / ACRE") %>%
  select(-Data) %>%
  rename("POLLINATION, MEASURED IN $ / ACRE" = Value)

veg.1.10 <- veg.1 %>%
  filter(Data == "POLLINATION, MEASURED IN $ / COLONY") %>%
  select(-Data) %>%
  rename("POLLINATION, MEASURED IN $ / COLONY" = Value)

veg.1.11 <- veg.1 %>%
  filter(Data == "POLLINATION, MEASURED IN COLONIES") %>%
  select(-Data) %>%
  rename("POLLINATION, MEASURED IN COLONIES" = Value)

veg.1.12 <- veg.1 %>%
  filter(Data == "VALUE OF POLLINATION, MEASURED IN $") %>%
  select(-Data) %>%
  rename("VALUE OF POLLINATION, MEASURED IN $" = Value)

veg.1.13 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, 10TH PERCENTILE") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, 10TH PERCENTILE" = Value)

veg.1.14 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, 90TH PERCENTILE") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, 90TH PERCENTILE" = Value)

veg.1.15 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, CV PCT") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, CV PCT" = Value)

veg.1.16 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, MEDIAN") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, MEDIAN" = Value)

veg.1.17 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / YEAR, 10TH PERCENTILE") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / YEAR, 10TH PERCENTILE" = Value)

veg.1.18 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / YEAR, 90TH PERCENTILE") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / YEAR, 90TH PERCENTILE" = Value)

veg.1.19 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / YEAR, CV PCT") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / YEAR, CV PCT" = Value)

veg.1.20 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN LB / ACRE / YEAR, MEDIAN") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN LB / ACRE / YEAR, MEDIAN" = Value)

veg.1.21 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN NUMBER, 10TH PERCENTILE") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN NUMBER, 10TH PERCENTILE" = Value)

veg.1.22 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN NUMBER, 90TH PERCENTILE") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN NUMBER, 90TH PERCENTILED" = Value)

veg.1.23 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN NUMBER, CV PCT") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN NUMBER, CV PCT" = Value)

veg.1.24 <- veg.1 %>%
  filter(Data == "APPLICATIONS, MEASURED IN NUMBER, MEDIAN") %>%
  select(-Data) %>%
  rename("APPLICATIONS, MEASURED IN NUMBER, MEDIAN" = Value)

veg.1.25 <- veg.1 %>%
  filter(Data == "TREATED, MEASURED IN PCT OF AREA PLANTED, 10TH PERCENTILE") %>%
  select(-Data) %>%
  rename("TREATED, MEASURED IN PCT OF AREA PLANTED, 10TH PERCENTILE" = Value)

veg.1.26 <- veg.1 %>%
  filter(Data == "TREATED, MEASURED IN PCT OF AREA PLANTED, 90TH PERCENTILE") %>%
  select(-Data) %>%
  rename("TREATED, MEASURED IN PCT OF AREA PLANTED, 90TH PERCENTILE" = Value)

veg.1.27 <- veg.1 %>%
  filter(Data == "TREATED, MEASURED IN PCT OF AREA PLANTED, CV PCT") %>%
  select(-Data) %>%
  rename("TREATED, MEASURED IN PCT OF AREA PLANTED, CV PCT" = Value)

veg.1.28 <- veg.1 %>%
  filter(Data == "TREATED, MEASURED IN PCT OF AREA PLANTED, MEDIAN") %>%
  select(-Data) %>%
  rename("TREATED, MEASURED IN PCT OF AREA PLANTED, MEDIAN" = Value)

veg.1 <- full_join(veg.1.1,veg.1.2)
veg.1 <- full_join(veg.1, veg.1.3)
veg.1 <- full_join(veg.1, veg.1.4)
veg.1 <- full_join(veg.1, veg.1.5)
veg.1 <- full_join(veg.1, veg.1.6)
veg.1 <- full_join(veg.1, veg.1.7)
veg.1 <- full_join(veg.1, veg.1.8)
veg.1 <- full_join(veg.1, veg.1.9)
veg.1 <- full_join(veg.1, veg.1.10)
veg.1 <- full_join(veg.1, veg.1.11)
veg.1 <- full_join(veg.1, veg.1.12)
veg.1 <- full_join(veg.1, veg.1.13)
veg.1 <- full_join(veg.1, veg.1.14)
veg.1 <- full_join(veg.1, veg.1.15)
veg.1 <- full_join(veg.1, veg.1.16)
veg.1 <- full_join(veg.1, veg.1.17)
veg.1 <- full_join(veg.1, veg.1.18)
veg.1 <- full_join(veg.1, veg.1.19)
veg.1 <- full_join(veg.1, veg.1.20)
veg.1 <- full_join(veg.1, veg.1.21)
veg.1 <- full_join(veg.1, veg.1.22)
veg.1 <- full_join(veg.1, veg.1.23)
veg.1 <- full_join(veg.1, veg.1.24)
veg.1 <- full_join(veg.1, veg.1.25)
veg.1 <- full_join(veg.1, veg.1.26)
veg.1 <- full_join(veg.1, veg.1.27)
veg.1 <- full_join(veg.1, veg.1.28)

#veg.1 is now TIDY!!!

## TRANSFORM/ORGANIZE

#In class, we noted that some of the chemicals used on our food are classified RESTRICTED USE CHEMICALS. We isolated these chemicals in the veg1 dataset and found technical information about their toxicity in ECOTOX, the Beta version of ECOTOX, and the EPA Chenical Dashboard.

RestrictedUseChemicals <- veg.1 %>%
  filter(Domain == "RESTRICTED USE CHEMICAL") %>%
  select(-State, -Geo, -Region) #They're all the same

unique(RestrictedUseChemicals[,"Description"])

uniquevals2 <- apply(RestrictedUseChemicals, 2, n_distinct) #counts the number of unique values in EACH column 
names2_1 <- names(uniquevals2[uniquevals2==1]) #gives a vector of strings that represent the columns that only have one unique value
names2_gt1 <- names(uniquevals2[uniquevals2>1]) #gives a vector of strings that represent the columns that have more than one unique value

RestrictedUseChemicals <- RestrictedUseChemicals %>%
  select(names2_gt1) %>%
  rename(
    `Applications (lb)` = `APPLICATIONS, MEASURED IN LB`,                        
    `Percent Treated` =`TREATED, MEASURED IN PCT OF AREA PLANTED, AVG`,        
    `Average Applications (lb/acre)` =`APPLICATIONS, MEASURED IN LB / ACRE / APPLICATION, AVG`,
    `Average Number of Applications` =`APPLICATIONS, MEASURED IN NUMBER, AVG`
  )

RestrictedUseChemicals$Year <- as.character(RestrictedUseChemicals$Year)

#Make a table of toxicity measurements (at least LD50 for a single experimental animal). 
#Use this table and what you know about dplyr joins to augment your evaluation of 
#chemical treatments applied to vegetables.

#Experimental Info From ECOTOX

toxicity <- read_xlsx("toxicity.xlsx")
toxicity <- toxicity %>%
  rename(Description = Name)

#RfD values from EPA Dashboard

#RfD is an estimate (with uncertainty spanning perhaps an order of magnitude) of
#a daily exposure to the human population (including sensitive subgroups) that
#is likely to be without an appreciable risk of deleterious effects during a
#lifetime. We joined the average RfD values onto the RestrictedUseChemicals data set.

toxval <- read_xlsx("toxval.xlsx")
RestrictedUseChemicals <- RestrictedUseChemicals %>%
  left_join( toxval, by = "Description") %>%
  select(-Units)

## VISUALIZE/EXPLORE

####### RESTRICTED USE CHEMICALS -- GENERAL VISUALIZATION

ggplot(data = RestrictedUseChemicals) + 
  geom_bar(mapping = aes(x = Commodity, y = `Percent Treated`), fill = "red", stat = "summary") +
  labs(title = "Percent Treated by Commodity (for Restricted Use Chemicals)",
       subtitle = "Average percent of area planted that was treated was greater for cauliflower")
      
ggplot(data = RestrictedUseChemicals) + 
  geom_bar(
    mapping = aes(x = Commodity, y = `Percent Treated`, fill = Description), 
    stat = "summary",
    position = "dodge") +
  labs(title = "Percent Treated by Commodity (for Restricted Use Chemicals)",
       subtitle = "Average percent of area planted that was treated, broken down by the chemical it was treated with")

ggplot(data = RestrictedUseChemicals) + 
  geom_bar(
    mapping = aes(x = Commodity, y = `Applications (lb)`, fill = Description), 
    stat = "summary",
    position = "dodge") +
  labs(title = "Amount of Applications by Commodity (for Restricted Use Chemicals)",
        subtitle = "Amount of applications was greater for Broccoli, and Diazinon, Disulfoton, and Chlorpyrifos were used the most")

ggplot(data = RestrictedUseChemicals) + 
  geom_bar(
    mapping = aes(x = Commodity, y = `Average Applications (lb/acre)`, fill = Description), 
    stat = "summary",
    position = "dodge") + 
  labs(title = "Amount of Applications by Commodity (for Restricted Use Chemicals)",
       subtitle = "Amount of applications was greater for Broccoli, and Diazinon, Disulfoton, and Chlorpyrifos were used the most")

ggplot(data = RestrictedUseChemicals) + 
  geom_bar(
    mapping = aes(x = Commodity, y = `Average Number of Applications`, fill = Description), 
    stat = "summary",
    position = "dodge") +
  ggtitle("Average Number of Applications by Commidity (for Restricted Use Chemicals)")

ggplot(data = RestrictedUseChemicals) + 
  geom_bar(
    mapping = aes(x = Year, y = `Applications (lb)`), 
    stat = "summary",
    position = "dodge") +
  ggtitle("Applications Per Year (for Restricted Use Chemicals)")

ggplot(data = RestrictedUseChemicals) + 
  geom_bar(
    mapping = aes(x = Year, y = `Applications (lb)`, fill = Description), 
    stat = "summary",
    position = "dodge") +
  ggtitle("Applications Per Year (for Restricted Use Chemicals)") +
  labs(subtitle = "Broken down by the chemical applied")

ggplot(data = RestrictedUseChemicals) + 
  geom_bar(
    mapping = aes(x = Commodity, y = `Applications (lb)`, fill = Year), 
    stat = "summary",
    position = "dodge") + 
  ggtitle("Applications by Commodity (for Restricted Use Chemicals)")

####### RESTRICTED USE CHEMICALS -- WITH TOXICITY

RestrictedUseChemicals.no <- filter(RestrictedUseChemicals, `Average RfD` < 1)
#CHLORANTRANILIPROLE has an abnormally high RfD value (which means it's less dangerous/toxic, and doesn't affect our analysis)

ggplot(data = RestrictedUseChemicals.no) +
  geom_jitter(mapping = aes(x = `Applications (lb)`, y = `Average RfD`, color = Commodity)) +
  ggtitle("Average RfD vs. Applications (lb) (for Restricted Use Chemicals)")


ggplot(data = RestrictedUseChemicals.no) +
  geom_bar(mapping = aes(x = Description, y = `Average RfD`), stat = "identity") +
  coord_flip() +
  ggtitle("Average RfD for each Restricted Use Chemical (for Restricted Use Chemicals)") 

#EMAMECTIN BENZOATE has the lowest RfD value 

ggplot(data = RestrictedUseChemicals.no) + 
  geom_bar(
    mapping = aes(x = Commodity, y = `Average RfD`, fill = Description), 
    stat = "summary",
    position = "dodge") + 
  ggtitle("Average RfD by Commodity (for Restricted Use Chemicals)")

ggplot(data = RestrictedUseChemicals.no) +
  geom_histogram(mapping = aes(x = `Average RfD`, fill = Commodity),  
    position = "dodge",
    binwidth = 0.005) + 
  ggtitle("Average RfD Count (for Restricted Use Chemicals)")

#Use chemicals that have low RfD values MORE, especially with broccoli.
