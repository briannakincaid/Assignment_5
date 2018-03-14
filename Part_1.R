
## IMPORT/READ (readr)

    # Find the webside for NOAA Weather Station buoy 46035 at 57.026 N 177.738 W in the NOAA National Data Buoy Center.

yr1985 <- read_fwf(file = "46035 Data/46035h1985.txt",fwf_widths(c(2,2,2,2,3,4,4,5,5,5,3,6,4,5,5,4),c("YY","MM","DD","hh","WD", "WSPD","GST","WVHT","DPD","APD","MWD","BAR","ATMP","WTMP","DEWP", "VIS")), skip = 1)
#this is WRONG

## TIDY/CLEAN (tidyr)

## TRANSFORM/ORGANIZE (dplyr)

## VISUALIZE/EXPLORE -- Questions, Variation, Missing Values, Covariation, Patterns and Models  (ggplot2)

    # time series composed of 30 years of daily Air Temperature and Sea Temperature readings recorded at noon for the time zone of Station 46035.
    # look at relationship between air temperature and sea temperature. are they related?
    # Some data may be missing. What should you do about missing data? See “An introduction to data cleaning with R” by Edwin de Jonge and Mark van der Loo in the Contributed Documentation section at the bottom of the CRAN R page.
    # Has the mean temperature changed over the past 30 years? What statistical methods can you use to test if the change is statistically significant?
    # You been instructed to use only one sample per day day out of 24 daily hourly temperature readings. Has your sampling affected your evaluation of temperature change? In what way? Explain and demonstrate.

## SLIDES AND SHINY

    # Assemble your work on the Station 45035 data into an R-Driven slide presentation (no google slides or powerpoint, please). Also make a Shiny Dashboard that lets visitors to your dashboard explore what you have learned about 
    # buoy observations of air and water temperature in the southern Bering Sea.