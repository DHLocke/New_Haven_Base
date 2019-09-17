# New_Haven_Base
## New start for all things New Haven

Zhanghao Chen, Yichen Yang, Colleen Murphy-Dunning and many others are working on several projects pertaining to urban forestry using [URI's](https://uri.yale.edu) vast datasets. URI is close to celebrating **25 years** of discovery, service and more with New Haven community members and [Yale School of Forestry and Environmental Studies](https://environment.yale.edu) students.

The purose of this repository is to share data, code, and other digital resources in support of extracting insights, publishing papers, producing actionable-analytics, and teaching and learning some parts of data science.

This repository can also be thought of as a collaborative corrispondence course. Below are the first two installments, migrated from email to this repo.

# New Haven projects installment 1:
## R/ R-Studio/ git/ Census data
Although I've used Census data for [New Haven before](http://dexterlocke.com/publications/category/new-haven/), I'm on a new computer and those files are all on old hard drives at home. I am at work. And I thought it would be a nice example for Zhanghao to see how I work though a project like this. 

[This webpage](https://github.com/DHLocke/New_Haven_Base) is where I'll keep any code written for this project with lots and lots of notes. Far more than I normally give myself in the hopes that they are helpful for following along. The [*.R](https://www.r-project.org) files can be downloaded (or copy/paste) into R and it will replicate all of the analyses on your computer. It doesn't matter if you are on Mac or PC. All of the changes will be logged throughout the project, so we'll never have to guess which version is correct. _[edit: subsequent stages will use git more directly via R Studio, that material will appear below]_

These files can also be accessed via [RStudio](https://www.rstudio.com/), which is also free and has lots of great features that make data analysis fun. I'd be happy to demonstrate that, too.

### A few notes on R syntax:

* "%>%" means "and then" or "next", it is used for linking together several steps. [More info here.](https://r4ds.had.co.nz/pipes.html)  
* ";" treats what comes next as if its on the next line even though its on the same line
help('function_name') accesses the help file for "function_name". Any function can be given.  
* "<-" is the assign operator. The results of functions like new data or new columns, or graphs, really anything can be assigned and stored in memory. It works backwards too, like '->' assigns whats on the left to what's on the right.   

The first piece of code for this project is [access_Census.R](https://github.com/DHLocke/New_Haven_Base/blob/master/access_census.R) which accesses Census data, and calculates percent of people in different racial groups. I've also included median household income but do not display it. The code will create the two attached maps, which are just quick double checks and far from publication quality. New Haven, like many American Cities is very racially segregated. There are not a lot of pacific islanders. Note that the boundaries of block groups are slightly different in each time period, and we will take that into account in subsequent analyses. 

[Click here to check out access_Census.R](https://github.com/DHLocke/New_Haven_Base/blob/master/access_census.R) as the *R file.

# New Haven projects installment 2:
## more R/ ArcGIS/ python/ Landcover summaries
Take a [look at the base page](https://github.com/DHLocke/New_Haven_Base), you'll notice several new files. [access_Census.R](https://github.com/DHLocke/New_Haven_Base/blob/master/access_census.R) has been extended to show the differences between variable-wide and variable-tall formats of the American Community survey data for two periods of time. The coding difference is subtle, but the output is really different. At the end I used the variable-wide format to write out the data as shapefiles to read in to ArcGIS.

Then I opened up ArcMap (do you have access?), created a file geodatabase, and projected the shapefiles to match the land cover data mentioned in message to the larger group "LandCover_NewHaven_2008.img". When you get access to that (not included in the online bundle due to size), you'll see there are seven mutually exclusive land cover classes:

*Tree canopy (suggest mapping as dark green)  
*Grass/ shrub (suggest light green)  
*Bare soil (brown or tan)  
*Water (blue)  
*Buildings (red)  
*Roads / rail roads (black)  
*Other impervious surfaces like sidewalks, parking lots, etc (light gray)  

[UTC_summary.py](https://github.com/DHLocke/New_Haven_Base/blob/master/UTC_summary.py) is a python version of what was done in ArcMap. The pathways will need to be changed to match your computer. You can use the results tab in ArcMap to see these steps as well: they mirror eachother. After projecting, I used the toolbox linked to next (that's what's being referenced around line 31). That will not be reproducible from python because there is a lot of customization built into [Tree Canopy Assessment Tools (with TC Change).tbx](https://github.com/DHLocke/New_Haven_Base/blob/master/Tree%20Canopy%20Assessment%20Tools%20(with%20TC%20Change).tbx). Find the Metrics tool in the ArcGIS (ie not Arc Pro) folder. Double click to launch that tool. You will see there are five parameters (the help file on the right is pretty good):

1. Input polygons (these are the block groups here, but could be any polygons where you want land cover summarized)  
2. The land cover data "LandCover_NewHaven_2008.img" and soon we can re-run with the new land cover data  
3. Set this to "TC_ID" always. That stands for Tree Canopy Identifier.  
4. The name of the tree canopy table (this takes a little more explanation, but is used to see how much tree canopy there is in a an area both in area and % area formats. It also estimates where tree canopy could be based on other land cover classes.)
5. The name of the land cover summary table. This table has area and % area of each land cover class. 

You can see in both [UTC_summary.py](https://github.com/DHLocke/New_Haven_Base/blob/master/UTC_summary.py) and in the results tab of the *.mxd that these tables were then permanently joined back to the block group polygons. We can repeat all of this again with the new land cover data. And soon we can associate the requested and volunteer planted trees to these data.

In summary, using R the Census data were obtained in a GIS-friendly format. Shapefiles were written so that ArcMap could create geodatabase feature classes. Then using ArcMap/ python land cover summaries were created and joined back to the original data.