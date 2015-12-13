# ethics-bowl-scoring

This is an R script for computing scores for Ethics Bowls, created for the 7th Annual Long Island High School Ethics Bowl. It implements the scoring criteria in the “2015-16 Rules, Procedures, and Guidelines” available from the [National High School Ethics Bowl  page](http://nhseb.unc.edu/nhseb-rules/).

The ranking script is complete, functional, and commented. I may add some data-quality checks to it, so that it will produce an error message if, for instance, any spreadsheet cell is blank. But it now works for scoring.

The sections below explain how to get data into place for the script to use it, and then briefly how it works.

This directory also includes a toy data `.csv` file for testing the script called `EBToyData.csv`.

## Prerequisites

[R](https://www.r-project.org) must be installed, and it's presumed you know how to run it, either from the command line, or from its GUI app, or in a development environment like [RStudio](https://www.rstudio.com/products/rstudio/).

The following R packages must be installed/available: `dplyr`, `readr`, `reshape2`.

## Data entry

Data can be entered in any application that will export a `.csv` (comma-separated value spreadsheet) file, including Excel, Numbers, and any text-editor among others. It should then be exported to the same folder/directory this script is run from.

The script looks for a CSV file called `EBToyData.csv` in the same folder/directory, and imports that into memory. I will change this name (and will note that here) as I switch over from using toy data for testing the script to using actual Ethics Bowl data. The toy data file `EBToyData.csv` is in this repository. 

To use the script with a `.csv` file that has a different name, find and replace "EBToyData" in the script with the name of your `.csv`  file.

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
 
The script should be able to handle any number of rounds of competition between pairs of teams. Cells should not be left blank.

## Scoring

The script calculates rankings according to number of wins and then according to the series of tie-breakers described in [the 2015-2016 rulebook](https://nhseb.unc.edu/files/2012/04/NHSEB-2015-16-Rules-Procedures-and-Guidelines.pdf). It sequentially evaluates:  

 1. most wins
 2. fewest losses
 3. most judge-votes
 4. highest point-differential
 5. highest total-points
 6. coin toss
 
The script simulates a coin-toss (which is unlikely to be required in scoring) by generating a random number between 0 and 1 for each team, and then ranking the team with the higher number higher. Or at least, it uses the random numbers to rank two teams if and only if their scores are completely tied after all factors up through highest total-points are considered.

## Results and output

The script:

 1. puts the results in an R object called `finalresults`
 2. prints `finalresults` to the local viewer
 3. writes `finalresults` to a `.csv` file to the local directory called `EBResults.csv`. This file, `EBResults.csv`, can be opened in any spreadsheet application or text editor.
 
For the toy data in `EBToyData.csv`, the script outputs the following results:
 
|  | team     | wins | losses | judgevotes | ptdiff | bowltotal | random                   |
|------|----------|--------|------------|--------|-----------|--------|--------------------|
| 1    | maple    | 3      | 0          | 9      | 50        | 493    | 0.225436616456136  |
| 2    | walnut   | 2      | 1          | 6      | 10        | 431    | 0.429671525489539  |
| 3    | dogwood  | 2      | 1          | 5      | 20        | 471    | 0.426907666493207  |
| 4    | spruce   | 2      | 1          | 5      | 10        | 347    | 0.615829307818785  |
| 5    | chestnut | 1      | 0          | 5      | 8         | 408    | 0.306768506066874  |
| 6    | elm      | 1      | 1          | 3      | -10       | 482    | 0.693102080840617  |
| 7    | oak      | 1      | 2          | 2      | -17       | 446    | 0.274530522990972  |
| 8    | holly    | 0      | 2          | 2      | 2         | 414    | 0.0851359688676894 |
| 9    | cedar    | 0      | 2          | 2      | -21       | 444    | 0.507478203158826  |
| 10   | poplar   | 0      | 2          | 0      | -52       | 366    | 0.272305066231638  | 