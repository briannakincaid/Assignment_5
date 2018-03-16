
## IMPORT/READ (readr)

# Retrieved data from NOAA Weather Station buoy 46035 at 57.026 N 177.738 W in the NOAA National Data Buoy Center
# http://www.ndbc.noaa.gov/station_history.php?station=46035

yr1985 <- read_table2("46035 Data/46035h1985.txt")
yr1986 <- read_table2("46035 Data/46035h1986.txt")
yr1987 <- read_table2("46035 Data/46035h1987.txt")
yr1988 <- read_table2("46035 Data/46035h1988.txt")
yr1989 <- read_table2("46035 Data/46035h1989.txt")
yr1990 <- read_table2("46035 Data/46035h1990.txt")
yr1991 <- read_table2("46035 Data/46035h1991.txt")
yr1992 <- read_table2("46035 Data/46035h1992.txt")
yr1993 <- read_table2("46035 Data/46035h1993.txt")
yr1994 <- read_table2("46035 Data/46035h1994.txt")
yr1995 <- read_table2("46035 Data/46035h1995.txt")
yr1996 <- read_table2("46035 Data/46035h1996.txt")
yr1997 <- read_table2("46035 Data/46035h1997.txt")
yr1998 <- read_table2("46035 Data/46035h1998.txt")
yr1999 <- read_table2("46035 Data/46035h1999.txt")
yr2000 <- read_table2("46035 Data/46035h2000.txt")
yr2001 <- read_table2("46035 Data/46035h2001.txt")
yr2002 <- read_table2("46035 Data/46035h2002.txt")
yr2003 <- read_table2("46035 Data/46035h2003.txt")
yr2004 <- read_table2("46035 Data/46035h2004.txt")
yr2005 <- read_table2("46035 Data/46035h2005.txt")
yr2006 <- read_table2("46035 Data/46035h2006.txt")
yr2007 <- read_table2("46035 Data/46035h2007.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2008 <- read_table2("46035 Data/46035h2008.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2009 <- read_table2("46035 Data/46035h2009.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2010 <- read_table2("46035 Data/46035h2010.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2011 <- read_table2("46035 Data/46035h2011.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2012 <- read_table2("46035 Data/46035h2012.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2014 <- read_table2("46035 Data/46035h2014.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2015 <- read_table2("46035 Data/46035h2015.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2016 <- read_table2("46035 Data/46035h2016.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))
yr2017 <- read_table2("46035 Data/46035h2017.txt", skip = 2, col_names = c("YY", "MM", "DD", "hh", "mm", "WDIR", "WSPD", "GST",  "WVHT",   "DPD",   "APD", "MWD",   "PRES",  "ATMP",  "WTMP",  "DEWP",  "VIS", "TIDE"))


## TIDY/CLEAN (tidyr)

# The goal here is to make the vegetable dataset tidy so that we can then more easily work with it. In order to make it tidy, we need to make it so
# each variable has its own column, each observation has its own row, and each value has its own cell. 


## TRANSFORM/ORGANIZE (dplyr)

simple_85 <- yr1985 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP) %>%
  filter(WTMP != 999)

simple_86 <- yr1986 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_87 <- yr1987 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_88 <- yr1988 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_89 <- yr1989 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_90 <- yr1990 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_91 <- yr1991 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_92 <- yr1992 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_93 <- yr1993 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_94 <- yr1994 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_95 <- yr1995 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_96 <- yr1996 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_97 <- yr1997 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_98 <- yr1998 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_99 <- yr1999 %>%
  filter(hh == 12) %>%
  separate(YYYY, into = c("CC", "YY"), sep = 2) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_00 <- yr2000 %>%
  filter(hh == 12) %>%
  separate(YYYY, into = c("CC", "YY"), sep = 2) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_01 <- yr2001 %>%
  filter(hh == 12) %>%
  separate(YYYY, into = c("CC", "YY"), sep = 2) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_02 <- yr2002 %>%
  filter(hh == 12) %>%
  separate(YYYY, into = c("CC", "YY"), sep = 2) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_03 <- yr2003 %>%
  filter(hh == 12) %>%
  separate(YYYY, into = c("CC", "YY"), sep = 2) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_04 <- yr2004 %>%
  filter(hh == 12) %>%
  separate(YYYY, into = c("CC", "YY"), sep = 2) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_05 <- yr2005 %>%
  filter(hh == 12) %>%
  separate(YYYY, into = c("CC", "YY"), sep = 2) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_06 <- yr2006 %>%
  filter(hh == 12) %>%
  separate(YYYY, into = c("CC", "YY"), sep = 2) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_07 <- yr2007 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_08 <- yr2008 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_09 <- yr2009 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_10 <- yr2010 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_11 <- yr2011 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_12 <- yr2012 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_14 <- yr2014 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_15 <- yr2015 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_16 <- yr2016 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

simple_17 <- yr2017 %>%
  filter(hh == 12) %>%
  select(YY, MM, DD, ATMP, WTMP)

all_awtmp <- rbind(simple_85, simple_86, simple_87, simple_88, simple_89, simple_90, simple_91, simple_92, simple_93, simple_94, simple_95, simple_96, simple_97, simple_98, simple_99, simple_00, simple_01, simple_02, simple_03, simple_04, simple_05, simple_06, simple_07, simple_08, simple_09, simple_10, simple_11, simple_12, simple_14, simple_15, simple_16, simple_17)
all_awtmp <- all_awtmp %>%
  unite(day, MM, DD, YY, sep = "/")

all_awtmp$ATMP <- as.numeric(all_awtmp$ATMP)
all_awtmp$ATMP <- as.numeric(all_awtmp$WTMP)

all_awtmp2 <- all_awtmp %>%
  filter(ATMP != 999.0 & WTMP != 999.0)

## VISUALIZE/EXPLORE -- Questions, Variation, Missing Values, Covariation, Patterns and Models  (ggplot2)

# time series composed of 30 years of daily Air Temperature and Sea Temperature readings recorded at noon for the time zone of Station 46035.

ggplot(data = all_awtmp2) +
  geom_point(mapping = aes(ATMP, WTMP))

ggplot(data = all_awtmp) +
  geom_histogram(mapping = aes(x = ATMP), stat = "count", binwidth = 100)

ggplot(data = all_awtmp2) + 
  geom_line(mapping = aes(x = ATMP, y = day))
                 
# look at relationship between air temperature and sea temperature. are they related?



# Some data may be missing. What should you do about missing data? See “An introduction to data cleaning with R” by Edwin de Jonge and Mark van der Loo in the Contributed Documentation section at the bottom of the CRAN R page.

# Has the mean temperature changed over the past 30 years? What statistical methods can you use to test if the change is statistically significant?

# You been instructed to use only one sample per day day out of 24 daily hourly temperature readings. Has your sampling affected your evaluation of temperature change? In what way? Explain and demonstrate.



## SLIDES AND SHINY

    # Assemble your work on the Station 45035 data into an R-Driven slide presentation (no google slides or powerpoint, please). Also make a Shiny Dashboard that lets visitors to your dashboard explore what you have learned about 
    # buoy observations of air and water temperature in the southern Bering Sea.