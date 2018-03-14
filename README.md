# Assignment 5 
Kevin Chan, Brianna Kincaid, Lauren Vanvalkenburg

## Part 1

### Import/Read (readr)

- Find the webside for NOAA Weather Station buoy 46035 at 57.026 N 177.738 W in the NOAA National Data Buoy Center.

### Tidy/Clean (tidyr)

### Transform/Organize (dplyr)

### Visualize/Explore -- Questions, Variation, Missing Values, Covariation, Patterns and Models  (ggplot2)

- time series composed of 30 years of daily Air Temperature and Sea Temperature readings recorded at noon for the time zone of Station 46035.
- look at relationship between air temperature and sea temperature. are they related?
- Some data may be missing. What should you do about missing data? See “An introduction to data cleaning with R” by Edwin de Jonge and Mark van der Loo in the Contributed Documentation section at the bottom of the CRAN R page.
- Has the mean temperature changed over the past 30 years? What statistical methods can you use to test if the change is statistically significant?
- You been instructed to use only one sample per day day out of 24 daily hourly temperature readings. Has your sampling affected your evaluation of temperature change? In what way? Explain and demonstrate.

### Slides and Shiny

- Assemble your work on the Station 45035 data into an R-Driven slide presentation (no google slides or powerpoint, please). Also make a Shiny Dashboard that lets visitors to your dashboard explore what you have learned about buoy observations of air and water temperature in the southern Bering Sea.

## Part 2

The attached file veg1.xlsx was created using the USDA QuickStats system using the following parameters

- Program: Survey
- Sector: Environmental
- Group: Vegetables
- Commodity: Vegetables Totals, Vegetables Other, Broccoli, Brussels Sprouts, Cauliflower 

All other parameters were left open.

The data was collected to gain insight about chemical treatments applied to food crops as fertilizer, insecticides, etc. 

### Import/Read (readr)

### Tidy/Clean (tidyr)

### Transform/Organize (dplyr)

In class, we noted that some of the chemicals used on our food are classified RESTRICTED USE CHEMICALS. We isolated these chemicals in the veg1 dataset and found technical information about their toxicity in ECOTOX, the Beta version of ECOTOX, and the EPA Chenical Dashboard.

Make a table of toxicity measurements (at least LD50 for a single experimental animal). Use this table and what you know about dplyr joins to augment your evaluation of chemical treatments applied to vegetables.

### Visualize/Explore -- Questions, Variation, Missing Values, Covariation, Patterns and Models  (ggplot2)

### Slides and Shiny





