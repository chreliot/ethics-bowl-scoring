# An R script for scoring the Long Island Regional High School Ethics Bowl
# (c) 2015 Christopher H. Eliot (@chreliot)
#  This code is commented, but see the README at https://github.com/chreliot/ethics-bowl-scoring

# LOAD REQUIRED PACKAGES
# ----------------------

library(dplyr)
library(readr)
library(reshape2)

# IMPORT SPREADSHEET
# ------------------

# Import csv version of score sheet
ebtoy <- read_csv("EBToyData.csv")

# Ensure that names don't have lower-case
names(ebtoy) <- make.names(names(ebtoy))

# TODO: check why this is make.names rather than e.g. make.lower

# Note: sum(ebtoy$wintieloss == "win")  returns 12, the number of wins overall

# DATA-QUALITY/SANITY CHECKS
# --------------------------

# TODO: add data-quality checks

# sapply(ebtoy[4:6], function(x) if(x>60){print("Warning: score over 60")}else{print("Fine: data range")})

# CALCULATE RANKING CRITERIA
# --------------------------

# Calculate wins, losses (for first criterion and tie-breaker 1):
# --------------------------------------------------------------

# We currently skip counting wins and losses and rely on the 
# manually-entered winlosstie column. That is, we go with the moderators' decisions.

# group the original dataframe by teams
gbteams <- group_by(ebtoy, team)
# create a data frame that's a count of wins for each team
rankedteams <- summarize(gbteams, wins = sum(wintieloss == "win"), 
                         losses = sum(wintieloss == "loss"))

# rankedteams is now a dataframe with win counts but 
# the ranking isn't performed until the RANKING FUNCTION section below


# Count judge votes (tie-breaker 2):
#----------------------------------

# create a new data frame with just round, team, and 3 judge scores
votestemp <- select(ebtoy, round, team, judge1, judge2, judge3)

# for each match, calculate a vote, lose, or tie outcome for each judge/team pair
votesbymatch <- melt(votestemp, id.vars = c("round", "team")) %>%
  group_by(group = rep(1:(nrow(.)/2), each = 2)) %>%
  arrange(desc(value)) %>%
  mutate(result = if(value[1] == value[2]){"ties"}else{
    c("vote", "lose")
  })

# Summarize the count of judge votes by team instead of by match
votesbyteam <- group_by(votesbymatch, team)
votesbyteam <- summarize(votesbyteam, votes = sum(result == "vote"))

# add a new column to rankedteams: judgevotes (vote, tie, lose)
rankedteams <- mutate(rankedteams, judgevotes = votesbyteam$votes)

# Compute total point differential over all matches (tie-breaker 3):
# -----------------------------------------------------------------

# create a new data frame from ebtoy with just round, team, and 3 judge scores
pointdifftemp <- select(ebtoy, round, team, judge1, judge2, judge3)

# calculate a totalpoints column summing judges' scores for each team-performance
pointdifftemp <- mutate(pointdifftemp, totalpoints = (judge1 + judge2 + judge3))

# select just round and team ID variables and total points data into a new object
matchtotals <- select(pointdifftemp, round, team, totalpoints)

pointdiffsbymatch <- group_by(matchtotals, round) %>% 
  mutate(roundpoints = sum(totalpoints)) %>%
  mutate(pointdiff = (totalpoints-(roundpoints-totalpoints)))

pointdiffsbyteam <- group_by(pointdiffsbymatch, team)
pointdiffsbyteam <- summarize(pointdiffsbyteam, totalpointdiff = sum(pointdiff))

# add a new column to rankedteams: judgevotes (vote, tie, lose)
rankedteams <- mutate(rankedteams, ptdiff = pointdiffsbyteam$totalpointdiff)


# Count total points again (tie-breaker 4):
# --------------------------------------------

# # create a new data frame from ebtoy with just round, team, and 3 judge scores
# totalpointstemp <- select(ebtoy, round, team, judge1, judge2, judge3)
# 
# # calculate a totalpoints column summing judges' scores for each team-performance
# totalpointstemp <- mutate(totalpointstemp, totalpoints = (judge1 + judge2 + judge3))
# 
# # select just round and team ID variables and total points data into a new object
# matchtotals <- select(pointdifftemp, round, team, totalpoints)

# Use the matchtotals object again from point-diff section

totalsbyteam <- group_by(matchtotals, team)

bowltotalsbyteam <- summarize(totalsbyteam, bowlpoints = sum(totalpoints))

# add a new column to rankedteams: bowltotal (between 0, 720 for four rounds)
rankedteams <- mutate(rankedteams, bowltotal = bowltotalsbyteam$bowlpoints)


# Simulate a coin-toss by comparing random numbers between 0,1 (tie-breaker 5):
# ----------------------------------------------------------------------------

set.seed(length(rankedteams$team))
rankedteams <- mutate(rankedteams, random = runif(length(rankedteams$team), 0, 1))

# RANKING FUNCTION
# ----------------

# Rank teams by:
# 1. most wins
# 2. fewest losses
# 3. most judge-votes
# 4. highest point-differential
# 5. highest total-points
# 6. coin toss (simulated by random numbers)
arrange(rankedteams, desc(wins), losses, desc(judgevotes), desc(ptdiff), desc(bowltotal), desc(random))