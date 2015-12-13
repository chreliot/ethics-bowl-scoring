# ethics-bowl-scoring

This is an R script for computing scores for Ethics Bowls, created for the 7th Annual Long Island High School Ethics Bowl. It implements the scoring criteria in the “2015-16 Rules, Procedures, and Guidelines” available from the [National High School Ethics Bowl  page](http://nhseb.unc.edu/nhseb-rules/).

The ranking script is complete, functional, and commented. I may add some data-quality checks to it, so that it will produce an error message if, for instance, any spreadsheet cell is blank. But it now works for scoring.

The sections below explain how to get data into the script, and then briefly how it works.

This directory also includes a toy data .csv file for testing the script called `EBToyData.csv.`

## Data entry

Data can be entered in any application that will export a `.csv` file, including Excel, Numbers, and any text-editor among others. It should then be exported to the same folder/directory this script is run from.

The script looks for a CSV file called `EBToyData.csv` in the same folder/directory, and imports that into memory. I will change this name (and will note that here) as I switch over from using toy data for testing the script to using actual Ethics Bowl data. To use the script with a `.csv` file that has a different name, just find and replace "EBToyData" in the script with the name of your `.csv` (comma-separated value spreadsheet) file.

The input `.csv` file should be formatted like this:

| round | team   | wintieloss | judge1 | judge2 | judge3 |
|-------|--------|------------|--------|--------|--------|
| a1    | maple  | win        | 58     | 57     | 58     |
| a1    | poplar | loss       | 45     | 49     | 52     |
| a2    | oak    | win        | 48     | 46     | 45     |
| a2    | walnut | loss       | 49     | 44     | 42     |

 * **round** lists unique designators for each match between two teams. It doesn't matter what they are, so long as teams competing with each other in a particular round have exactly the same code. Obviously, it's a good idea to use some consistent scheme;
 * **team** lists unique team names, which must be consistent, and shouldn't include punctuation, to be safe;
 * **wintieloss** takes one of the three values "win," "tie," or "loss." It lists the round-moderator's assessment of which team won. Though it is also possible to calculate the winner from the numbers, the script counts wins and losses from this manually-entered column.
 * **judge1**, **judge2**, and **judge3** take values between 0 and 60, each representing the total scores given by each judge to a particular team at the end of the round.

The script should be able to handle any number of rounds of competition between pairs of teams.

## Scoring

The script calculates rankings according to number of wins and then according to the series of tie-breakers described in [the 2015-2016 rulebook](https://nhseb.unc.edu/files/2012/04/NHSEB-2015-16-Rules-Procedures-and-Guidelines.pdf). It sequentially evaluates:  

 1. most wins
 2. fewest losses
 3. most judge-votes
 4. highest point-differential
 5. highest total-points
 6. coin toss
 
The script simulates a coin-toss (which is unlikely to be required in scoring) by generating a random number between 0 and 1 for each team, and then ranking the team with the higher number higher. Or at least, it uses the random numbers to rank two teams if and only if their scores are completely tied after all factors up through highest total-points are considered.