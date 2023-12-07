# Advent of Code

My Swift solutions for Advent of Code 2023.

[Project Template](https://github.com/apple/swift-aoc-starter-example)

## Advent Day Setup
In order to streamline project setup for each new Advent Day, `AdventDaySetupService` can be used to fetch the input file and generate source and test files for the specified day. The functionality can be invoked from the command line.

- The flag `--setup-day <Day>` specifies which day to set up. If part one has been answered, the test and source files will set up part two as well. 
- The flag `--session-token` is also required in order to have page fetching work correctly. 
	- To get the session token, load any Advent of Code puzzle page, right-click and select *Inspect*. Under the *Network* section, *Cookie* will have the value "session=\<token\>".

### Example Usage

```shell
$ swift run AdventOfCode --setup-day 1 --session-token abc123
```
