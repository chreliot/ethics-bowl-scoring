# An R script for scoring the Long Island Regional High School Ethics Bowl
# (c) 2015 Christopher H. Eliot (@chreliot)
#  This code is commented, but see the README at https://github.com/chreliot/ethics-bowl-scoring

library(dplyr)
library(readr)

# Import csv version of score sheet
ebtoy <- read_csv("EBToyData.csv")
# Ensure that names don't have 
names(ebtoy) <- make.names(names(ebtoy))

# sum(ebtoy$wintieloss == "win")  returns 12, the number of wins overall; I want it to be per teammea


# cgroup by teams
gbteams <- group_by(ebtoy, team)
# create a data frame that's a count of wins for each team
rankedteams <- summarize(gbteams, wins = sum(wintieloss == "win"))

# an incomplete arrange task that arranges so far only by wins
arrange(rankedteams, desc(wins))



# arrange(df)

