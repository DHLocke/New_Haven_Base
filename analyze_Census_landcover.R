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
library(mapview)      # makes webmaps
library(psych)        # scatterplot matrix
library(cowplot)      # helps with multi-pane figures
#library(sjlabelled)   # aliases field names

# read in the data from the geodatabase
# your file path will be different, change this
# (there is probably a better way to do this)
# nh_lc1 <- st_read('C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb',
#                   layer = 'NH_2009_2013_5year_ACS')
# nh_lc2 <- st_read('C:/Users/dexterlocke/Box/_DHLocke/New_Haven/New_Haven_Base/tree_canopy_gdb.gdb',
#                   layer = 'NH_2013_2017_5year_ACS')
nh_lc1 <- st_read('/Users/dlocke/URI_data/New_Haven_Base/tree_canopy_gdb.gdb',
                  layer = 'NH_2009_2013_5year_ACS')
nh_lc2 <- st_read('/Users/dlocke/URI_data/New_Haven_Base/tree_canopy_gdb.gdb',
                  layer = 'NH_2013_2017_5year_ACS')

# one of the better studied relationships in Urban Forestry is tree canopy and household income
# Gerrish, E., & Watkins, S. L. (2018). 
# The relationship between urban forests and income: A meta-analysis.
# Landscape and Urban Planning, 170(April 2017), 293–308. 
# https://doi.org/10.1016/j.landurbplan.2017.09.005


# income map
# this does not take advantage of all of the new data we've added
# to the Census data
nh_lc1 %>% ggplot() + geom_sf(aes(fill = medncmE)) # initial first map, prettier below

inc_map1 <- nh_lc1 %>% # we are 'saving' the map object so we can compare side by side
  rename('Median\nHousehold\nIncome\n($, 2009 to 2013)' = medncmE) %>% # prettier name for legend
  ggplot() +
  geom_sf(aes(fill = `Median\nHousehold\nIncome\n($, 2009 to 2013)`)) + 
  scale_fill_viridis_c(option = 'plasma') # median household income map

# you can see the map by just typeing "inc_map1"

can_map1 <- nh_lc1 %>% 
  rename('2008\nTree Canopy\n(% cover)' = Can_P) %>% 
  ggplot() + 
  geom_sf(aes(fill = `2008\nTree Canopy\n(% cover)`)) +
  scale_fill_viridis_c(option = 'plasma')   # tree canopy cover map

inc_map2 <- nh_lc2 %>% # we are 'saving' the map object so we can compare side by side
  rename('Median\nHousehold\nIncome\n($, 2013 to 2017)' = medncmE) %>% # prettier name for legend
  ggplot() +
  geom_sf(aes(fill = `Median\nHousehold\nIncome\n($, 2013 to 2017)`)) + 
  scale_fill_viridis_c(option = 'plasma') # median household income map

can_map2 <- nh_lc2 %>% 
  rename('2016\nTree Canopy\n(% cover)' = Can_P) %>% 
  ggplot() + 
  geom_sf(aes(fill = `2016\nTree Canopy\n(% cover)`)) +
  scale_fill_viridis_c(option = 'plasma')   # tree canopy cover map

# lays our four maps
# a little slow
plot_grid(inc_map1, # the first map, income for time 1
          can_map1, # the second map, tree canopy for time 1
          inc_map2, # third map...
          can_map2, # fourth..
          nrow = 2, # the layout is going to be 2 rows "n" as in "number", rows..
          ncol = 2, # by two columns
          labels = 'AUTO') # adds letters for easy reference 

# lets take a look at income and conapy graphically,
# for the first time period
nh_lc1 %>% ggplot(aes(x = medncmE, y = Can_P)) + # tells ggplot which data to use for which axes
  geom_point() + # tells ggplot we want a scatterplot
  geom_smooth()  # tells ggplot we want a best fit line

# note the differences here are just cosmetic
inc_plot1 <- nh_lc1 %>% ggplot(aes(x = medncmE, y = Can_P)) + # this is the same as above
  geom_point() +                                              # this is the same as above
  geom_smooth(method = 'lm', color = 'dark green') +          # force a linear model with "lm"
  xlab('Median Household Income, USD (years 2009 - 2013)') +  # nicer x-axis label
  ylab('% Tree Canopy Cover (year 2008)') +                   # nicer y-axis label
  ggtitle('Tree Canopy vs Household Income') +                # adds a title
  theme_bw() +                                                # makes graph background/axes black and white for a simple, clean look 
  ylim(0, 100) +                                              # forces the y axis to be the entire hypothetical domain of the variable
  annotate('text',                                            # adds the text
           x = 1e5, # same as 10000
           y = 20,  # placement of the text we add in the y direction
           label = paste0(cor.test(nh_lc1$medncmE, nh_lc1$Can_P)$method, ' = ',
                          round(cor.test(nh_lc1$medncmE, nh_lc1$Can_P)$estimate, 2), '\n 95% CI [',
                          round(cor.test(nh_lc1$medncmE, nh_lc1$Can_P)$conf.int[1], 2), ', ',
                          round(cor.test(nh_lc1$medncmE, nh_lc1$Can_P)$conf.int[2], 2), ']\np-value = ',
                          round(cor.test(nh_lc1$medncmE, nh_lc1$Can_P)$p.value, 5)))
# that label is complex!
# take it once piece at a time
# using 'cor.test' the correlation is computed
# the estiamte and 95% confidence interval (CI) is extracted and the pvalue is reported
# below we store the correlation and pull out the needed elments

# Second time period income
sigFig <- 2 # that's how many places to round
cor_ex <- cor.test(nh_lc2$medncmE, nh_lc2$Can_P) # now we can pull out the relevant pieces below

inc_plot2 <- nh_lc2 %>% ggplot(aes(x = medncmE, y = Can_P)) +
  geom_point() + 
  geom_smooth(method = 'lm', color = 'dark green') + 
  xlab('Median Household Income, USD (years 2013 - 2017)') + 
  ylab('% Tree Canopy Cover (year 2016)') + 
  ggtitle('Tree Canopy vs Household Income') + 
  theme_bw() + 
  ylim(0, 100) + 
  annotate('text',
           x = 1e5, # same as 10000
           y = 80,
           label = paste0(cor_ex$method, ' = ',
                          round(cor_ex$estimate, 2), '\n 95% CI [',
                          round(cor_ex$conf.int[1], 2), ', ',
                          round(cor_ex$conf.int[2], 2), ']\np-value = ',
                          round(cor_ex$p.value, 5)))

plot_grid(inc_plot1, inc_plot2, ncol = 1)

# here we look at all of the continuous variables and how they vary
dplyr::select(as.data.frame(nh_lc1), -Shape) %>% # pairs.panel() wont accept sf classes
  select(ends_with('E'), -NAME,                  # get the Estimates, they all end with "E"
         Can_P,                                  # tree canopy, as percent of area, from the land cover data
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


# race shapes so much of what happens in American Cities. 
# Watkins, S. L., & Gerrish, E. (2018).
# The relationship between urban forests and race:
# A meta-analysis. Journal of Environmental Management,
# 209(April 2017), 152–168. https://doi.org/10.1016/j.jenvman.2017.12.021
nh_race1 <- nh_lc1 %>%                          
mutate(white_p = 100*(whiteE / totpopE),     # convert counts into percentages, see "access_census.R" for definitions
       black_p = 100*(blackE / totpopE))     # other variables could be added..

race1_graph_w <- nh_race1 %>% 
  ggplot(aes(x = white_p, y = Can_P)) +
  geom_point() + 
  # geom_smooth() +
  geom_smooth(method = 'lm', color = 'red') +
  labs(x = '% White (years 2009 - 2013)', y = '% Tree Canopy Cover (year 2008)') + # note labs() instead of xlab(), ylab()
  ggtitle('Tree Canopy vs Race') + 
  theme_bw() + 
  ylim(0, 100) + 
  geom_label(aes(x = 20, y = 85,
           label = paste0(cor.test(nh_race1$white_p, nh_race1$Can_P)$method, ' = ',
                          round(cor.test(nh_race1$white_p, nh_race1$Can_P)$estimate, 2), '\n 95% CI [',
                          round(cor.test(nh_race1$white_p, nh_race1$Can_P)$conf.int[1], 2), ', ',
                          round(cor.test(nh_race1$white_p, nh_race1$Can_P)$conf.int[2], 2), ']\np-value = ',
                          round(cor.test(nh_race1$white_p, nh_race1$Can_P)$p.value, 5))))

# repeat for African American
race1_graph_b <- nh_race1 %>% 
  ggplot(aes(x = black_p, y = Can_P)) +
  geom_point() + 
  #geom_smooth() +
  geom_smooth(method = 'lm', color = 'red') +
  xlab('% African American (years 2009 - 2013)') + # see, you can do labs() or xlab()
  ylab('% Tree Canopy Cover (year 2008)') + 
  ggtitle('Tree Canopy vs Race') + 
  theme_bw() + 
  ylim(0, 100) + 
  geom_label(aes(x = 70, y = 85,
                 label = paste0(cor.test(nh_race1$black_p, nh_race1$Can_P)$method, ' = ',
                                round(cor.test(nh_race1$black_p, nh_race1$Can_P)$estimate, 2), '\n 95% CI [',
                                round(cor.test(nh_race1$black_p, nh_race1$Can_P)$conf.int[1], 2), ', ',
                                round(cor.test(nh_race1$black_p, nh_race1$Can_P)$conf.int[2], 2), ']\np-value = ',
                                round(cor.test(nh_race1$black_p, nh_race1$Can_P)$p.value, 5))))

plot_grid(race1_graph_w, race1_graph_b, ncol = 1)

# second time period race and canopy
nh_race2 <- nh_lc2 %>%                          
  mutate(white_p = 100*(whiteE / totpopE),     # convert counts into percentages
         black_p = 100*(blackE / totpopE))     # other variables could be added..

race2_graph_w <- nh_race2 %>% 
  ggplot(aes(x = white_p, y = Can_P)) +
  geom_point() + 
  # geom_smooth() +
  geom_smooth(method = 'lm', color = 'red') +
  labs(x = '% White (years 2013 - 2017)', y = '% Tree Canopy Cover (year 2016)') + # note labs() instead of xlab(), ylab()
  ggtitle('Tree Canopy vs Race') + 
  theme_bw() + 
  ylim(0, 100) + 
  geom_label(aes(x = 20, y = 85,
                 label = paste0(cor.test(nh_race2$white_p, nh_race2$Can_P)$method, ' = ',
                                round(cor.test(nh_race2$white_p, nh_race2$Can_P)$estimate, 2), '\n 95% CI [',
                                round(cor.test(nh_race2$white_p, nh_race2$Can_P)$conf.int[1], 2), ', ',
                                round(cor.test(nh_race2$white_p, nh_race2$Can_P)$conf.int[2], 2), ']\np-value = ',
                                round(cor.test(nh_race2$white_p, nh_race2$Can_P)$p.value, 5))))

# repeat for African American
race2_graph_b <- nh_race2 %>% 
  ggplot(aes(x = black_p, y = Can_P)) +
  geom_point() + 
  #geom_smooth() +
  geom_smooth(method = 'lm', color = 'red') +
  xlab('% African American (years 2013 - 2017)') + # see, you can do labs() or xlab()
  ylab('% Tree Canopy Cover (year 2016)') + 
  ggtitle('Tree Canopy vs Race') + 
  theme_bw() + 
  ylim(0, 100) + 
  geom_label(aes(x = 70, y = 85,
                 label = paste0(cor.test(nh_race2$black_p, nh_race2$Can_P)$method, ' = ',
                                round(cor.test(nh_race2$black_p, nh_race2$Can_P)$estimate, 2), '\n 95% CI [',
                                round(cor.test(nh_race2$black_p, nh_race2$Can_P)$conf.int[1], 2), ', ',
                                round(cor.test(nh_race2$black_p, nh_race2$Can_P)$conf.int[2], 2), ']\np-value = ',
                                round(cor.test(nh_race2$black_p, nh_race2$Can_P)$p.value, 5))))

plot_grid(race2_graph_w, race2_graph_b, ncol = 1)

# old below
# nh_lc2 %>%                           # building + road + other impervious as a percent of area
#   mutate(white_p = 100*(whiteE / totpopE),         # convert counts into percentages
#          black_p = 100*(blackE / totpopE)) %>%     # other variables could be added..
#   ggplot(aes(x = black_p, y = Can_P)) +
#   geom_errorbarh(aes(xmin = black_p - (blackM/totpopE), xmax = black_p + (blackM/totpopE))) +
#   geom_point(color = 'red', alpha = .5) + 
#   geom_smooth() +
#   xlab('% African American (years 2013 - 2017)') +
#   ylab('% Tree Canopy Cover (year 2016)')

# done
# Wed Sep 18 20:25:09 2019 ------------------------------