# ethics-bowl-scoring

`EBScoring.R` is an [R](https://www.r-project.org/about.html) script for computing scores for Ethics Bowls, created for the 7th Annual Long Island High School Ethics Bowl. It implements the scoring criteria in the “2015-16 Rules, Procedures, and Guidelines” available from the [National High School Ethics Bowl  page](http://nhseb.unc.edu/nhseb-rules/).

The ranking script is complete, functional, and commented, however I may add some data-quality checks to it, so that it will produce an error message if, for instance, any spreadsheet cell is blank. And I might clean up a few things. But it works for scoring, and that shouldn't change.

The sections below explain how to get data into place for the script to use it, and then briefly what the script does.

## Prerequisites

[R](https://www.r-project.org) must be installed, and it's presumed you know how to run it, either from the command line, or from its GUI app, or inside a development environment like [RStudio](https://www.rstudio.com/products/rstudio/).

The following R packages must be installed/available: `dplyr`, `readr`, `reshape2`. The script loads them.

## Data entry

Scores for individual rounds can be entered in any application that will export a `.csv` (comma-separated value spreadsheet) file, including Excel, Numbers, and any text-editor among others. Save the `.csv` file to the same folder/directory you're running this script in.

The script looks for a CSV file called `EBToyData.csv` in the same folder/directory, and imports that into memory. I will change this name (and will note that here) as I switch over from using toy data for testing the script to using actual Ethics Bowl data. The toy data file `EBToyData.csv` is also in this repository. It depicts 10 teams participating in three rounds each, competing against a different team in each round.

To use the script with a `.csv` file that has a different name, either find and replace "EBToyData" in the script with the name of your `.csv`  file, or (even easier) change the name of your file to `EBToyData.csv`.

The input `.csv` file should be formatted like this example. Each row is a performance by a particular team in a particular round, as they should appear on moderators' score sheets. Each column is variable describing that performance:

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
 
The script should be able to handle any number of rounds of competition between pairs of teams. Cells should not be left blank.

## Scoring

The script calculates rankings according to number of wins and then according to the series of tie-breakers described in [the 2015-2016 rulebook](https://nhseb.unc.edu/files/2012/04/NHSEB-2015-16-Rules-Procedures-and-Guidelines.pdf). It sequentially evaluates:  

 1. most wins
 2. fewest losses
 3. most judge-votes
 4. highest point-differential
 5. highest total points
 6. coin toss
 
The script simulates a coin-toss (which is unlikely to be required in scoring) by generating a random number between 0 and 1 for each team, and then ranking the team with the higher number higher.

## Results and output

The script:

 1. puts the results in an R object called `finalresults`
 2. prints `finalresults` to the local viewer
 3. writes `finalresults` to a `.csv` file to the local directory called `EBResults.csv`. This file, `EBResults.csv`, can be opened in any spreadsheet application or text editor.
 
For the matches in `EBToyData.csv`, the script outputs the following results. Teams are ranked by performance, best at the top:
 
|  | team     | wins | losses | judgevotes | ptdiff | bowltotal | random                   |
|------|----------|--------|------------|--------|-----------|--------|--------------------|
| 1    | maple    | 3      | 0          | 9      | 50        | 493    | 0.22543  |
| 2    | walnut   | 2      | 1          | 6      | 10        | 431    | 0.42967  |
| 3    | dogwood  | 2      | 1          | 5      | 20        | 471    | 0.42690  |
| 4    | spruce   | 2      | 1          | 5      | 10        | 347    | 0.61582  |
| 5    | chestnut | 1      | 0          | 5      | 8         | 408    | 0.30676  |
| 6    | elm      | 1      | 1          | 3      | -10       | 482    | 0.69310  |
| 7    | oak      | 1      | 2          | 2      | -17       | 446    | 0.27453  |
| 8    | holly    | 0      | 2          | 2      | 3         | 415    | 0.08513  |
| 9    | cedar    | 0      | 2          | 2      | -23       | 444    | 0.50747  |
| 10   | poplar   | 0      | 2          | 0      | -52       | 366    | 0.27230  | 