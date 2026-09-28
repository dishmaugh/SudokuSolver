# Sudoku Solver

A modular Sudoku solver written in Chez Scheme.

This project is a continuation of a solver I originally developed in 2006
as an independent project while studying Cognitive Science. The algorithm
began as a paper-and-pencil approach to Sudoku, was prototyped in Excel,
and was then implemented in Scheme.

The current project revisits that original solver, separates the algorithm
into modules, completes unfinished portions of the solving logic, and
provides puzzle sets for testing and benchmarking.

## Solving Strategy

The solver represents each unsolved cell as a vector of possible values
and progressively eliminates candidates using Sudoku constraints.

The solving process is organized into levels:

- **Level 0 — Constraint propagation:** Remove known values from candidate
  vectors in the corresponding rows, columns, and 3x3 subgroups.
- **Level 1 — Single candidates:** When only one candidate remains in a
  cell, promote it to a known value and propagate the resulting constraints.
- **Level 2 — Unique candidates:** When a candidate occurs in only one
  cell within a row, column, or subgroup, that cell must contain the value.
- **Level 3 — Candidate-set reduction:** Find groups of N unresolved cells
  within a row, column, or subgroup whose combined candidates contain
  exactly N values. Those values must occur within those cells and can
  therefore be eliminated from the other cells in the unit.
- **Level 4 — Search/backtracking:** Choose a candidate when logical
  reduction cannot complete the puzzle, propagate its consequences, and
  backtrack if the choice produces an invalid state.

Level 4 is intentionally disabled while development and testing of the
logical Level 3 solver continues.

## Level 3

Level 3 is the central idea behind the original solver.

The 2006 Scheme implementation contained a partial version of this logic
that recognized matching two-candidate vectors. The current implementation
generalizes the original idea: candidate sets of different sizes can be
identified whenever N cells collectively contain exactly N possible values.

This allows the same reduction algorithm to recognize pairs, triples,
quads, and larger constrained candidate sets without implementing each as
a separate Sudoku rule.

## Current Results

Two puzzle collections are included for regression testing.

| Puzzle Set | Solved | Failed | Total |
|---|---:|---:|---:|
| `puzzles/sudoku.txt` | 46 | 4 | 50 |
| `puzzles/sudoku-hard.txt` | 15 | 80 | 95 |

These results use logical solving through Level 3 only. Search/backtracking
is not currently enabled.

For comparison, the earlier partial Level 3 implementation solved 44 of
the 50 standard puzzles and none of the 95 hard puzzles.

## Project Structure

- `grid.ss` — grid representation and manipulation
- `constraints.ss` — row, column, and subgroup constraint propagation
- `level-one.ss` — single-candidate solving
- `level-two.ss` — unique-candidate solving
- `level-three.ss` — generalized candidate-set reduction
- `level-four.ss` — search and backtracking
- `input.ss` — puzzle-file loading and test execution
- `display.ss` — grid and puzzle display
- `sudoku.ss` — solver orchestration and public entry point
- `puzzles/` — regression and benchmark puzzle sets

## Running

Load the solver in Chez Scheme:

    (load "sudoku.ss")

Run the built-in regression puzzle:

    (sudoku)

Run a puzzle collection:

    (sudoku "puzzles/sudoku.txt")

Or run the harder test collection:

    (sudoku "puzzles/sudoku-hard.txt")

Puzzle-file runs report the number of puzzles solved and failed rather
than printing every completed grid.

## Status

Active development.

The original 2006 solver has been recovered and refactored into a modular
project. Levels 0 through 2 are operational, and the previously unfinished
Level 3 candidate-reduction concept has now been generalized and implemented.

Current development is focused on determining how far the logical solver
can progress before Level 4 search/backtracking is required.