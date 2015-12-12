# ethics-bowl-scoring

This will be an R script for computing scores for Ethics Bowls, created for the 7th Annual Long Island High School Ethics Bowl. It implements the scoring criteria in the “2015-16 Rules, Procedures, and Guidelines” available from the [National High School Ethics Bowl  page](http://nhseb.unc.edu/nhseb-rules/).

**THIS IS CURRENTLY VERY MUCH A WORK IN PROGRESS.**

## Data entry

The script looks for a CSV file called xxxxxxx.csv, and imports it. The CSV file should be formatted like this:

| round | team   | wintieloss | judge1 | judge2 | judge3 |
|-------|--------|------------|--------|--------|--------|
| a1    | maple  | win        | 58     | 57     | 58     |
| a1    | poplar | loss       | 45     | 49     | 52     |
| a2    | oak    | win        | 48     | 46     | 45     |
| a2    | walnut | loss       | 49     | 44     | 42     |

 * **round** lists unique designators for each match between two teams;
 * **team** lists unique team names, which must be consistent, and without punctuation;
 * **wintieloss** takes one of the three values "win," "tie," or "loss." It lists the round-moderator's assessment of the winner. Though it is also possible to calculate the winner from the numbers, the script counts wins and losses from this column.
 * **judge1**, **judge2**, and **judge3** take values between 0 and 60, each representing the total scores given by each judge to a particular team at the end of the round.

The script should be able to handle any number of rounds of competition between pairs of teams.
