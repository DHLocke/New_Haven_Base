# Script by Dexter H. Locke, PhD
# started on 
# Tue Sep 17 12:16:27 2019 ------------------------------
# for analyzing Census data and landcover summaries


# rm(list = ls())     # this 'says' remove, and the list of things to remove is everything 'ls()'

# load packages
library(tidyverse)
library(magrittr)
# library(tidycensus) # access to Census data in a tidy way
library(sf)     
library(mapview) # makes webmaps
library(psych)   # scatterplot matrix



# read in the data from the geodatabase
# your file path will be different, change this
# (there is probably a better way to do this)
nh_lc1 <- st_read('C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb',
                  layer = 'NH_2009_2013_5year_ACS')
nh_lc2 <- st_read('C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb',
                  layer = 'NH_2013_2017_5year_ACS')

# income map
# this does not take advantage of all of the new data we've added
# to the Census data
nh_lc1 %>% ggplot() +
  geom_sf(aes(fill = medncmE))

nh_lc1 %>% ggplot(aes(x = medncmE, y = Can_P)) +
  geom_point() + 
  geom_smooth()


dplyr::select(as.data.frame(nh_lc1), -Shape) %>% # pairs.panel() wont accept sf classes
  select(ends_with('E'), -NAME,                  # get the Estimates
         Can_P,                                  # tree canopy, as percent of area
         Grass_P,                                # grass/shrub, as percent of area
         Soil_P,                                 # bare soil, as percent of area
         Water_P,                                # water, as percent of area
         Build_P,                                # building, as percent of area
         Road_P,                                 # road, as percent of area
         Paved_P,                                # other impervious, as percent of area
         Perv_P,                                 # canopy + grass + soil + water as percent of area
         Imperv_P) %>%                           # building + road + other impervious as a percent of area

pairs.panels( 
             method = "pearson", # correlation method
             hist.col = "#00AFBB",
             density = TRUE,  # show density plots
             ellipses = TRUE # show correlation ellipses
)


nh_lc1 %>%                          
mutate(white_p = 100*(whiteE / totpopE),         # convert counts into percentages
       black_p = 100*(blackE / totpopE)) %>%     # other variables could be added..
  ggplot(aes(x = white_p, y = Can_P)) +
  geom_point() + 
  geom_smooth() +
  xlab('% White (years 2009 - 2013)') +
  ylab('% Tree Canopy Cover (year 2008)')


nh_lc1 %>%                           # building + road + other impervious as a percent of area
  mutate(white_p = 100*(whiteE / totpopE),         # convert counts into percentages
         black_p = 100*(blackE / totpopE)) %>%     # other variables could be added..
  ggplot(aes(x = black_p, y = Can_P)) +
  geom_point() + 
  geom_smooth() +
  xlab('% African American (years 2009 - 2013)') +
  ylab('% Tree Canopy Cover (year 2008)')


nh_lc2 %>%                           # building + road + other impervious as a percent of area
  mutate(white_p = 100*(whiteE / totpopE),         # convert counts into percentages
         black_p = 100*(blackE / totpopE)) %>%     # other variables could be added..
  ggplot(aes(x = black_p, y = Can_P)) +
  geom_errorbarh(aes(xmin = black_p - (blackM/totpopE), xmax = black_p + (blackM/totpopE))) +
  geom_point(color = 'red', alpha = .5) + 
  geom_smooth() +
  xlab('% African American (years 2013 - 2017)') +
  ylab('% Tree Canopy Cover (year 2016)')

