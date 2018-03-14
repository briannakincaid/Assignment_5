
## IMPORT/READ (readr)

# Retrieved data from NOAA Weather Station buoy 46035 at 57.026 N 177.738 W in the NOAA National Data Buoy Center
# http://www.ndbc.noaa.gov/station_history.php?station=46035

yr1985 <- read_tsv("46035 Data/46035h1985.txt")
yr1986 <- read_tsv("46035 Data/46035h1986.txt")
yr1987 <- read_tsv("46035 Data/46035h1987.txt")
yr1988 <- read_tsv("46035 Data/46035h1988.txt")
yr1989 <- read_tsv("46035 Data/46035h1989.txt")
yr1990 <- read_tsv("46035 Data/46035h1990.txt")
yr1991 <- read_tsv("46035 Data/46035h1991.txt")
yr1992 <- read_tsv("46035 Data/46035h1992.txt")
yr1993 <- read_tsv("46035 Data/46035h1993.txt")
yr1994 <- read_tsv("46035 Data/46035h1994.txt")
yr1995 <- read_tsv("46035 Data/46035h1995.txt")
yr1996 <- read_tsv("46035 Data/46035h1996.txt")
yr1997 <- read_tsv("46035 Data/46035h1997.txt")
yr1998 <- read_tsv("46035 Data/46035h1998.txt")
yr1999 <- read_tsv("46035 Data/46035h1999.txt")
yr2000 <- read_tsv("46035 Data/46035h2000.txt")
yr2001 <- read_tsv("46035 Data/46035h2001.txt")
yr2002 <- read_tsv("46035 Data/46035h2002.txt")
yr2003 <- read_tsv("46035 Data/46035h2003.txt")
yr2004 <- read_tsv("46035 Data/46035h2004.txt")
yr2005 <- read_tsv("46035 Data/46035h2005.txt")
yr2006 <- read_tsv("46035 Data/46035h2006.txt")
yr2007 <- read_tsv("46035 Data/46035h2007.txt")
yr2008 <- read_tsv("46035 Data/46035h2008.txt")
yr2009 <- read_tsv("46035 Data/46035h2009.txt")
yr2010 <- read_tsv("46035 Data/46035h2010.txt")
yr2011 <- read_tsv("46035 Data/46035h2011.txt")
yr2012 <- read_tsv("46035 Data/46035h2012.txt")
yr2014 <- read_tsv("46035 Data/46035h2014.txt")
yr2015 <- read_tsv("46035 Data/46035h2015.txt")
yr2016 <- read_tsv("46035 Data/46035h2016.txt")
yr2017 <- read_tsv("46035 Data/46035h2017.txt")

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