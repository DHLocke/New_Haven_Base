# New_Haven_Base
## New start for all things New Haven

Zhanghao Chen, Yichen Yang, Colleen Murphy-Dunning and many others are working on several projects pertaining to urban forestry using [URI's](https://uri.yale.edu) vast datasets. URI is close to celebrating **25 years** of discovery, service and more with New Haven community member and [Yale School of Forestry and Environmental Studies](https://environment.yale.edu) students.

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

Click here to check out access_Census.R
