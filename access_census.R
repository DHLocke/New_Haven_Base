# Script by Dexter H. Locke, PhD
# started on 
# Thu Sep  5 08:29:56 2019 ------------------------------
# for showing how to access Census data, calculate racial composition, map it
# clear everything
rm(list = ls())     # this 'says' remove, and the list of things to remove is everything 'ls()'

# load packages, in R there are user-generated sets of funcations called 'packages',
# 'library()' loads these specialty libraries
library(tidyverse)  # this is actually a series of packages for data visualization and data management
                    # additional information and examples
                    # https://walkerke.github.io/tidycensus/articles/basic-usage.html#searching-for-variables
                    # https://walkerke.github.io/tidycensus/articles/spatial-data.html
library(magrittr)   # gives access to "the pipe" %>% which can be read as "and then"
library(tidycensus) # access to Census data in a tidy way
library(sf)         # Spatial Features, spatial data support and management
library(mapview)    # makes web maps, not actually using this yet

# use Census API key
# mine came from here: http://api.census.gov/data/key_signup.html
# you can get your own by entering an email address. This is unique per user
census_api_key('db9b3481879b9e79eb8c86608656c3c8a8640bbb', install = TRUE)

# view available variables
# the 'load_variables' function gets metadat for different Census data products
# the years "2013" and "2017" are the end year
# end of the 5-year period as specified by the "acs5"
# 'asc5' is shorthand for American Community Survey 5-year estimate
# this will open a window in RStudio with a table that can be sorted, searched and filtered
# then you can find the variable codes of interest and use in the "variables" argument
# in the "get_acs" function below.
acs_2013 <- load_variables(2013, 'acs5', cache = FALSE); View(acs_2013)
acs_2017 <- load_variables(2017, 'acs5', cache = FALSE); View(acs_2017)

# set mapping options
# this makes loading the data faster on the second/subsquent version.
options(tigris_use_cache = TRUE)

# read in year 2009 - 2013 5-year ACS
nh_1 <- get_acs(state = 'CT',                # Connecticut
                county = 'New Haven County', # larger than we want, hence filter below
                geography = 'block group',   # blocks are within block groups, block groups are within tracts. Not all of the data we want are available in blocks
                year = 2013,                 # matches line 26
                survey = 'acs5',             # matches line 26
                moe_level = 95,              # margin of error level, default is 90 I prefer the tighter 95
                summary_var = 'B02001_001',  # see help(get_acs) and the tidycensus links above, this is total population
                variables = c(medincome = 'B19013_001', # median household income, $
                              white = 'B02001_002',     # Caucasian, counts
                              black = 'B02001_003',     # African American, counts
                              am_ind = 'B02001_004',    # Native American, counts
                              asian = 'B02001_005',     # Asian, counts
                              pac_is = 'B02001_006',    # Pacific Islander, counts
                              other_race ='B02001_007'),# Other, counts
                #output = 'wide',
                geometry = TRUE) %>% # this creates the spatial data
  filter(str_detect(GEOID, '0900914') | str_detect(GEOID, '090093614')) # so above 'county' was set to New Haven County,
# the city of New Haven is smaller and this filter gets just the block groups of interest.
# I looked up these codes from another project. There are better ways to do this, but with 
# my familiarity of the study area this was a quick and accurate method, but bad for teaching

# double check
head(nh_1) # this give the first six rows of the tabular data, a good check

nh_1 %>%                              # take this data, and then
  filter(variable != 'medincome') %>% # filter out income (its on a different scale than population), and then
  mutate(pct = 100*(estimate / summary_est)) %>% # create a new variable called "pct" short for "percent"
                                                 # by taking the estimate / dividing it by total population, see line 46,
                                                 # and multiply by 100 so that we are left of the decimal point
  ggplot() +                  # initialize a graph
  geom_sf(aes(fill = pct)) +  # "_sf" is for spatial features,
                              # "aes()" is short for "aesthetic" were we want to fill by our new percentage varaible "pct"
  facet_wrap(~variable) +     # we are going to make one map for each variable
  theme_bw() +                # changes background color and axes labels
  scale_fill_viridis_c()      # sets the color pallette


# read in year 2009 - 2013 5-year ACS. "nh_1" was for New Haven 1 (as in first time period)
# basically just repeat line 39 to 74 but for the second time period
nh_2 <- get_acs(state = 'CT',
                county = 'New Haven County',
                geography = 'block group',
                year = 2017,
                survey = 'acs5',
                moe_level = 95,
                summary_var = 'B02001_001',
                variables = c(medincome = 'B19013_001', # much slower than c('B19013_001', 'B01003_001')
                              white = 'B02001_002',
                              black = 'B02001_003',
                              am_ind = 'B02001_004',
                              asian = 'B02001_005',
                              pac_is = 'B02001_006',
                              other_race = 'B02001_007'),
                #output = 'wide',
                geometry = TRUE) %>% 
  filter(str_detect(GEOID, '0900914') | str_detect(GEOID, '090093614'))

# double check 
head(nh_2)

nh_2 %>% 
  filter(variable != 'medincome') %>% 
  mutate(pct = 100*(estimate / summary_est)) %>% 
  ggplot() + 
  geom_sf(aes(fill = pct)) +
  facet_wrap(~variable) + 
  theme_bw() +
  scale_fill_viridis_c()

# todo: consider other Census variables like vacancy, ownership, etc
# todo: write into a format that ArcGIS can read, summarize tree data
# todo: read back in to R, visualize, run statistics

# end
# Fri Sep  6 14:35:29 2019 ------------------------------