#buoy observations of air and water temperature in the southern Bering Sea.

library(tidyverse)
library(ggplot2)
library(lubridate)

## IMPORT/READ (readr)

# Retrieved data from NOAA Weather Station buoy 46035 at 57.026 N 177.738 W in the NOAA National Data Buoy Center
# http://www.ndbc.noaa.gov/station_history.php?station=46035

# WDIR 	
# Wind direction (the direction the wind is coming from in degrees clockwise from true N) during the same period used for WSPD. See Wind Averaging Methods
# 
# WSPD 	
# Wind speed (m/s) averaged over an eight-minute period for buoys and a two-minute period for land stations. Reported Hourly. See Wind Averaging Methods.
# 
# GST 	
# Peak 5 or 8 second gust speed (m/s) measured during the eight-minute or two-minute period. The 5 or 8 second period can be determined by payload, See the 	Sensor Reporting, Sampling, and Accuracy section.
# 
# WVHT 	
# Significant wave height (meters) is calculated as the average of the highest one-third of all of the wave heights during the 20-minute sampling period. 	See the Wave Measurements section.
# 
# DPD 	
# Dominant wave period (seconds) is the period with the maximum wave energy. See the Wave Measurements section.
# 
# APD 	
# Average wave period (seconds) of all waves during the 20-minute period. See the Wave Measurements section.
# 
# MWD 	
# The direction from which the waves at the dominant period (DPD) are coming. The units are degrees from true North, increasing clockwise, with North as 0 	(zero) degrees and East as 90 degrees. See the Wave Measurements section.
# 
# PRES 	
# Sea level pressure (hPa). For C-MAN sites and Great Lakes buoys, the recorded pressure is reduced to sea level using the method described in NWS 	Technical Procedures Bulletin 291 (11/14/80). ( labeled BAR in Historical files)
# 
# ATMP 	
# Air temperature (Celsius). For sensor heights on buoys, see Hull Descriptions. For sensor heights at C-MAN stations, see C-MAN Sensor Locations
# 
# WTMP 	
# Sea surface temperature (Celsius). For buoys the depth is referenced to the hull's waterline. For fixed platforms it varies with tide, but is referenced 	to, or near Mean Lower Low Water (MLLW).
# 
# DEWP 	
# Dewpoint temperature taken at the same height as the air temperature measurement.
# 
# VIS 	
# Station visibility (nautical miles). Note that buoy stations are limited to reports from 0 to 1.6 nmi.
# 
# PTDY 	
# Pressure Tendency is the direction (plus or minus) and the amount of pressure change (hPa)for a three hour period ending at the time of observation. (not 	in Historical files)
# 
# TIDE 	
# The water level in feet above or below Mean Lower Low Water (MLLW). 
# 


#adding column names now to make it easier if we ever wanted to come back for more analysis
names = c("Year", "Month", "Day", "Hour", "Minute", "WindDirection", "WindSpeed", "Gust",  "WaveHeight",   "DominantWavePeriod",   "AverageWavePeriod", "DominantWindDirection",   "SeaLevelPressure",  "AirTemperature",  "WaterTemperature",  "DewpointTemperature",  "Visibility", "Tide")

#early years did not have minute or tide measurements
yr1985 <- read_table2("46035 Data/46035h1985.txt", skip = 1, col_names = names[-5][-17])
yr1986 <- read_table2("46035 Data/46035h1986.txt", skip = 1, col_names = names[-5][-17])
yr1987 <- read_table2("46035 Data/46035h1987.txt", skip = 1, col_names = names[-5][-17])
yr1988 <- read_table2("46035 Data/46035h1988.txt", skip = 1, col_names = names[-5][-17])
yr1989 <- read_table2("46035 Data/46035h1989.txt", skip = 1, col_names = names[-5][-17])
yr1990 <- read_table2("46035 Data/46035h1990.txt", skip = 1, col_names = names[-5][-17])
yr1991 <- read_table2("46035 Data/46035h1991.txt", skip = 1, col_names = names[-5][-17])
yr1992 <- read_table2("46035 Data/46035h1992.txt", skip = 1, col_names = names[-5][-17])
yr1993 <- read_table2("46035 Data/46035h1993.txt", skip = 1, col_names = names[-5][-17])
yr1994 <- read_table2("46035 Data/46035h1994.txt", skip = 1, col_names = names[-5][-17])
yr1995 <- read_table2("46035 Data/46035h1995.txt", skip = 1, col_names = names[-5][-17])
yr1996 <- read_table2("46035 Data/46035h1996.txt", skip = 1, col_names = names[-5][-17])
yr1997 <- read_table2("46035 Data/46035h1997.txt", skip = 1, col_names = names[-5][-17])
yr1998 <- read_table2("46035 Data/46035h1998.txt", skip = 1, col_names = names[-5][-17])
yr1999 <- read_table2("46035 Data/46035h1999.txt", skip = 1, col_names = names[-5][-17])


#added tide measurement in 2000
yr2000 <- read_table2("46035 Data/46035h2000.txt", skip = 2, col_names = names[-5])[,-17]
    #this gives a warning message because there is no data for tide until part of the way through 2000, so the row length changes 
yr2001 <- read_table2("46035 Data/46035h2001.txt", skip = 1, col_names = names[-5])[,-17]
yr2002 <- read_table2("46035 Data/46035h2002.txt", skip = 1, col_names = names[-5])[,-17]
yr2003 <- read_table2("46035 Data/46035h2003.txt", skip = 1, col_names = names[-5])[,-17]
yr2004 <- read_table2("46035 Data/46035h2004.txt", skip = 1, col_names = names[-5])[,-17]


#added minute measurement in 2005
yr2005 <- read_table2("46035 Data/46035h2005.txt", skip = 1, col_names = names)[,-18][,-5]
yr2006 <- read_table2("46035 Data/46035h2006.txt", skip = 1, col_names = names)[,-18][,-5]
yr2007 <- read_table2("46035 Data/46035h2007.txt", skip = 2, col_names = names)[,-18][,-5]
yr2008 <- read_table2("46035 Data/46035h2008.txt", skip = 2, col_names = names)[,-18][,-5]
yr2009 <- read_table2("46035 Data/46035h2009.txt", skip = 2, col_names = names)[,-18][,-5]
yr2010 <- read_table2("46035 Data/46035h2010.txt", skip = 2, col_names = names)[,-18][,-5]
yr2011 <- read_table2("46035 Data/46035h2011.txt", skip = 2, col_names = names)[,-18][,-5]
yr2012 <- read_table2("46035 Data/46035h2012.txt", skip = 2, col_names = names)[,-18][,-5]
yr2014 <- read_table2("46035 Data/46035h2014.txt", skip = 2, col_names = names)[,-18][,-5]
yr2015 <- read_table2("46035 Data/46035h2015.txt", skip = 2, col_names = names)[,-18][,-5]
yr2016 <- read_table2("46035 Data/46035h2016.txt", skip = 2, col_names = names)[,-18][,-5]
yr2017 <- read_table2("46035 Data/46035h2017.txt", skip = 2, col_names = names)[,-18][,-5]

allyears <- rbind(yr1985,yr1986, yr1987, yr1988, yr1989, yr1990, yr1991, yr1992, yr1993, yr1994, yr1995, yr1996, yr1997, yr1998, yr1999, yr2000, yr2001, yr2002, yr2003, yr2004, yr2005, yr2006, yr2007, yr2008, yr2009, yr2010, yr2011, yr2012, yr2014, yr2015, yr2016, yr2017)
allyears$Year[allyears$Year < 100] <- allyears$Year[allyears$Year < 100] + 1900 #fixes the lack of century in first half of years

## TIDY/CLEAN (tidyr)

# The goal here is to make the dataset tidy so that we can then more easily work with it. In order to make it tidy, we need to make it so
# each variable has its own column, each observation has its own row, and each value has its own cell. 

#Fix column types
allyears <- allyears %>%
  mutate(Year = as.numeric(Year), 
         Day = as.numeric(Day),
         Month = as.numeric(Month),
         Hour = as.integer(Hour),
         WindDirection = as.integer(WindDirection),
         WindSpeed = as.numeric(WindSpeed),
         Gust = as.numeric(Gust),
         WaveHeight = as.numeric(WaveHeight),
         DominantWavePeriod = as.numeric(DominantWavePeriod),
         AverageWavePeriod = as.numeric(AverageWavePeriod),
         DominantWindDirection = as.integer(DominantWindDirection),
         SeaLevelPressure = as.numeric(SeaLevelPressure),
         AirTemperature = as.numeric(AirTemperature),
         WaterTemperature = as.numeric(WaterTemperature),
         DewpointTemperature = as.numeric(DewpointTemperature),
         Visibility = as.numeric(Visibility))

#Add Date
allyears <- allyears %>%
  mutate(Date = make_date(Year, Month, Day))

#######################################################

##Exploratory Visualization --- Are there outliers??##

#AIR TEMPERATURE
ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = AirTemperature))

#The histogram shows that there are values near 1000, when realistically there shouldn't be any 
#temperature measurement above 60 degrees Celsius. 

allyears$AirTemperature[allyears$AirTemperature > 60]

#looking at this, all the values above 60 are 999. It seems that this data set uses 999 as a replacement
#for NA values. 

allyears$AirTemperature[allyears$AirTemperature > 60] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = AirTemperature))

#WATER TEMPERATURE
ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = WaterTemperature))

#Again, the histogram shows that there are values near 1000, when realistically there shouldn't be any 
#temperature measurement above 60 degrees Celsius. 

allyears$WaterTemperature[allyears$WaterTemperature > 60]

#looking at this, all the values above 60 are 999. It seems that this data set uses 999 as a replacement
#for NA values.

allyears$WaterTemperature[allyears$WaterTemperature > 60] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = WaterTemperature))

#WIND DIRECTION

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = WindDirection))

#Yet again, the histogram shows values near 1000. These must be replaced with NA. 

allyears$WindDirection[allyears$WindDirection > 500] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = WindDirection))

#WIND SPEED

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = WindSpeed))

#Here, the histogram shows values near 100. Let's look at thee values...

allyears$WindSpeed[allyears$WindSpeed > 50]

#It's clear that these are just rare high wind speeds, because all of the values above 50 are 99. They
#must be NA. 

allyears$WindSpeed[allyears$WindSpeed > 50] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = WindSpeed))

#GUST

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = Gust))

#Would you look at that, more values near 100.

allyears$Gust[allyears$Gust > 50] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = Gust))

#WAVE HEIGHT

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = WaveHeight))

allyears$WaveHeight[allyears$WaveHeight > 50] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = WaveHeight))

#DOMINANT WAVE PERIOD

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = DominantWavePeriod))

allyears$DominantWavePeriod[allyears$DominantWavePeriod > 50] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = DominantWavePeriod))

#AVERAGE WAVE PERIOD

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = AverageWavePeriod))

allyears$AverageWavePeriod[allyears$AverageWavePeriod > 50] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = AverageWavePeriod))

#DOMINANT WIND DIRECTION

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = DominantWindDirection))

#Here, it's hard to tell if the values near 1000 are NA (and there are just a lot of them).

#Let's look at...

allyears$DominantWindDirection[allyears$DominantWindDirection > 750] 

#Definitely NA, all the values are 999

allyears$DominantWindDirection[allyears$DominantWindDirection > 750] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = DominantWindDirection))

#SEA LEVEL PRESSURE

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = SeaLevelPressure))

#Here there are values near 10,000...

allyears$SeaLevelPressure[allyears$SeaLevelPressure > 5000]

#Must be NA

allyears$SeaLevelPressure[allyears$SeaLevelPressure > 5000] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = SeaLevelPressure))

#DEWPOINT TEMPERATURE

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = DewpointTemperature))

#Again, there seems to be a lot of values around 1000...

allyears$DewpointTemperature[allyears$DewpointTemperature > 750] 

#They're all 999, so must be NA

allyears$DewpointTemperature[allyears$DewpointTemperature > 750] <- NA

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = DewpointTemperature))

#VISIBILITY

ggplot(data = allyears) +
  geom_histogram(mapping = aes(x = Visibility))

#Looks all the same...

max(allyears$Visibility)
min(allyears$Visibility)

#Yep, all the same. Does that mean they're all NA??

#Now all the data is tidy and the appropriate values have been removed.

#######################################################


## TRANSFORM/ORGANIZE (dplyr)

#Add day of year
allyears <- allyears %>%
  mutate(
    DayofYear = as.numeric(format(allyears$Date, "%j"))
  )

########################

#We're going to only be looking at the data at noon everyday.
allyears_noon <- allyears %>%
  filter(Hour == 12) 

########################

#Summary of Temperature Data(all times)
temperature_summary <- allyears %>%
  group_by(Year) %>%
  summarize(
    AirTempMean = mean(AirTemperature, na.rm = TRUE),
    WaterTempMean = mean(WaterTemperature, na.rm = TRUE),
    MaxAirTemp = max(AirTemperature, na.rm = TRUE),
    MinAirTemp = min(AirTemperature, na.rm = TRUE),
    MaxWaterTamp = max(WaterTemperature, na.rm = TRUE),
    MinWaterTemp = min(WaterTemperature, na.rm = TRUE)
    )

#2012 is funky. Why?

allyears %>%
  filter(Year == 2012) %>%
  filter(!is.na(AirTemperature))

#There is no AirTemperature or WaterTemperature data for 2012!

########################

#Summary of Temperature Data (noon)
temperature_summary_noon <- allyears_noon %>%
  group_by(Year) %>%
  summarize(
    AirTempMean = mean(AirTemperature, na.rm = TRUE),
    WaterTempMean = mean(WaterTemperature, na.rm = TRUE),
    MaxAirTemp = max(AirTemperature, na.rm = TRUE),
    MinAirTemp = min(AirTemperature, na.rm = TRUE),
    MaxWaterTamp = max(WaterTemperature, na.rm = TRUE),
    MinWaterTemp = min(WaterTemperature, na.rm = TRUE)
  )


## VISUALIZE/EXPLORE -- Questions, Variation, Missing Values, Covariation, Patterns and Models  (ggplot2)



#Distribution of Air Temperature and Water Temperature at noon
ggplot(data = allyears_noon) +
  geom_histogram(mapping = aes(x = AirTemperature), stat = "count")

ggplot(data = allyears_noon) +
  geom_histogram(mapping = aes(x = WaterTemperature), stat = "count")



#general trend over the year
ggplot(data = allyears_noon) +
  geom_point(mapping = aes(x = DayofYear, y = AirTemperature))

ggplot(data = allyears_noon) +
  geom_point(mapping = aes(x = DayofYear, y = WaterTemperature))



#Time Series
ggplot(data = allyears_noon) +
  geom_line(mapping = aes(x = Date, y = WaterTemperature))

ggplot(data = allyears_noon) +
  geom_line(mapping = aes(x = Date, y = AirTemperature))


ggplot(data = allyears_noon) +
  geom_line(mapping = aes(x = Date, y = AirTemperature, color = "Air Temperature")) +
  geom_line(mapping = aes(x = Date, y = WaterTemperature, color = "Water Temperature")) +
  xlab("Time") +
  ylab("Temperature")
      


     
#Relationship between air temperature and sea temperature

ggplot(data = allyears_noon) +
  geom_jitter(mapping = aes(x = WaterTemperature, y = AirTemperature))

ggplot(data = allyears_noon) +
  geom_bin2d(mapping = aes(x = WaterTemperature, y = AirTemperature)) +
  xlab("Water Temparature") +
  ylab("Air Temperature")


#Some data may be missing. What should you do about missing data? See “An introduction to data cleaning with R” by Edwin de Jonge and Mark van der Loo in the Contributed Documentation section at the bottom of the CRAN R page.

#Has the mean temperature changed over the past 30 years? 

ggplot(data = temperature_summary_noon) +
  geom_line(mapping = aes(x = Year, y = AirTempMean, color = "Air Temperature")) +
  geom_line(mapping = aes(x = Year, y = WaterTempMean, color = "Water Temperature")) +
  xlab("Year") +
  ylab("Mean Temperature (By Year)")

#What statistical methods can you use to test if the change is statistically significant? 

t.test(filter(allyears_noon, Year == 2017)$AirTemperature, filter(allyears_noon, Year == 2000)$AirTemperature)
t.test(filter(allyears_noon, Year == 2017)$WaterTemperature, filter(allyears_noon, Year == 2000)$WaterTemperature)




# You been instructed to use only one sample per day day out of 24 daily hourly temperature readings. 
# Has your sampling affected your evaluation of temperature change? In what way? 
# Explain and demonstrate.

#Conduct a ONE SAMPLE T-TEST. This compares the mean of a sample to a population with a known mean. 
#Here, the null hypothesis is that there is no significant difference between the mean in the population
#from which your sample was drawn and the mean of the known population. 

t.test(filter(allyears_noon, Year == 2017)$WaterTemperature, mu = 6.157119)
#cannot reject the null hypothesis (true mean is equal to 6.157119) here because p-value = 0.8808
#sample is a good representation of the overall data

#Check other years too
t.test(filter(allyears_noon, Year == 2000)$WaterTemperature, mu = 4.731988)
#cannot reject the null hypothesis (true mean is equal to 4.731988) here because p-value = 0.6539
#sample is a good representation of the overall data

#and check air temperature
t.test(filter(allyears_noon, Year == 2017)$AirTemperature, mu = 4.7145649)
#cannot reject the null hypothesis (true mean is equal to 4.7145649) here because p-value = 0.6633
#sample is a good representation of the overall data

t.test(filter(allyears_noon, Year == 2000)$AirTemperature, mu = 3.1507410)
#cannot reject the null hypothesis (true mean is equal to 3.150741) here because p-value = 0.2072
#sample is a good representation of the overall data



## SLIDES AND SHINY

    # Assemble your work on the Station 45035 data into an R-Driven slide presentation (no google slides or powerpoint, please). Also make a Shiny Dashboard that lets visitors to your dashboard explore what you have learned about 
    # buoy observations of air and water temperature in the southern Bering Sea.