# An R script for scoring the Long Island Regional High School Ethics Bowl
# (c) 2015 Christopher H. Eliot (@chreliot)
#  This code is commented, but see the README at https://github.com/chreliot/ethics-bowl-scoring

library(dplyr)
library(readr)
library(reshape2)
# IMPORT
# ------

# Import csv version of score sheet
ebtoy <- read_csv("EBToyData.csv")
# Ensure that names don't have 
names(ebtoy) <- make.names(names(ebtoy))

# Note: sum(ebtoy$wintieloss == "win")  returns 12, the number of wins overall

# DATA-QUALITY/SANITY CHECKS
# --------------------------



# CALCULATE RANKING CRITERIA
# --------------------------

# sapply(ebtoy[4:6], function(x) if(x>60){print("Warning: score over 60")}else{print("Fine: data range")})

# Count wins and losses:

# group the original dataframe by teams
gbteams <- group_by(ebtoy, team)
# create a data frame that's a count of wins for each team
rankedteams <- summarize(gbteams, wins = sum(wintieloss == "win"), 
                         losses = sum(wintieloss == "loss"))
# so rankedteams is now a dataframe with win counts but isn't ranked until RANKING FUNCTION


# Count judge votes:
#-------------------

# create a new data frame with just round, team, and 3 judge scores

votestemp <- select(ebtoy, round, team, judge1, judge2, judge3)

# for each match, caluclate a vote, lose, or tie outcome for each judge/team pair

votesbymatch <- melt(votestemp, id.vars = c("round", "team")) %>%
  group_by(group = rep(1:(nrow(.)/2), each = 2)) %>%
  arrange(desc(value)) %>%
  mutate(result = if(value[1] == value[2]){"ties"}else{
    c("vote", "lose")
  })
votesbyteam <- group_by(votesbymatch, team)
votesbyteam <- summarize(votesbyteam, votes = sum(result == "vote"))

# add a new column to rankedteams: judgevotes (vote, tie, lose)
rankedteams <- mutate(rankedteams, judgevotes = votesbyteam$votes)

# Compute total point differential over all matches:
#--------------------------------------------------

# create a new data frame from ebtoy with just round, team, and 3 judge scores
pointdifftemp <- select(ebtoy, round, team, judge1, judge2, judge3)

# calculate a totalpoints column summing judges' scores for each team-performance
pointdifftemp <- mutate(pointdifftemp, totalpoints = (judge1 + judge2 + judge3))

# select just round and team ID variables and total points data into a new object
matchtotals <- select(pointdifftemp, round, team, totalpoints)

pointdiffsbymatch <- group_by(pointdifftemp, round) %>% 
  mutate(roundpoints = sum(totalpoints)) %>%
  mutate(pointdiff = (totalpoints-(roundpoints-totalpoints)))

pointdiffsbyteam <- group_by(pointdiffsbymatch, team)
pointdiffsbyteam <- summarize(pointdiffsbyteam, totalpointdiff = sum(pointdiff))

# add a new column to rankedteams: judgevotes (vote, tie, lose)
rankedteams <- mutate(rankedteams, ptdiff = pointdiffsbyteam$totalpointdiff)

# pointdiffsbymatch <- melt(matchtotals, id.vars = c("round", "team")) %>%
#   group_by(group = rep(1:(nrow(.)/2), each = 2)) %>%
#   arrange(desc(value)) %>%
#   mutate(pointdiff = if(value[1] == value[2]){0}else{
#   c(value[1] - value[2], value[2] - value[1])
# })
# pointdiffsbyteam <- group_by(pointdiffsbymatch, team)
# pointdiffsbyteam <- summarize(pointdiffsbyteam, totalpointdiff = sum(pointdiff))
# pointdiffsbyteam

# I just removed:   arrange(desc(value)) %>%

# Coin toss?





# rankedbyvotes <- summarize()

# go back to the ebtoy data frame and count votes (2), novotes (1), ties (1.5)
# pending further instructions, I'm only going to count the votes (the 2s)
# in columns 4:6, which are the three judges' scores for each round

#votecount <- sapply(ebtoy[4:6], function(x) ave(x, gbrounds[1], FUN=rank))
#votecount <- as.data.frame(votecount)



# votecountlong <- melt(votecount)

#mutate(votecount, roundvotes = sum(function(x) (x==2)))
# rename(votecount, judge1votes = judge1, judge2votes = judge2, judge3votes = judge3)

# sapply(votecount, function(x) sum(x==2, na.rm=TRUE))
# mutate(votecount, roundvotes = sapply(value, function(x) sum(x==2, na.rm=TRUE)))

# mutate(votecount, roundvotes = sum(votecount=="2", na.rm=TRUE))  

# The problem with the previous line is that it sums ALL of the 2's in the df
# and so it returns 39 on every row.

# votecount$roundvotes <- rowSums(votecount == "2")


# RANKING FUNCTION
# ----------------

# an incomplete arrange task that arranges so far only by wins and losses
arrange(rankedteams, desc(wins), losses, desc(judgevotes), desc(ptdiff))

