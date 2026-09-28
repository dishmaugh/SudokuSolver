# Sudoku Solver

A Sudoku solver written in Chez Scheme.

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
- **Level 3 — Candidate-set reduction:** Additional logical elimination
  techniques operating on related candidate vectors. This portion of the
  original solver is currently being reconstructed and completed.
- **Level 4 — Search/backtracking:** When logical reduction cannot complete
  the puzzle, choose a candidate, propagate its consequences, and backtrack
  if the choice produces an invalid state.

## Project Structure

- `grid.ss` — grid representation and manipulation
- `constraints.ss` — row, column, and subgroup constraint propagation
- `level-one.ss` — single-candidate solving
- `level-two.ss` — unique-candidate solving
- `level-three.ss` — candidate-set reduction
- `level-four.ss` — search/backtracking
- `display.ss` — console output
- `sudoku.ss` — solver entry point
- `puzzles/` — puzzle sets used for testing

## Requirements

- Chez Scheme

## Status

The original solver has been reconstructed into a modular project and is
running successfully under modern Chez Scheme. Level Three is currently
being completed before the solver is benchmarked against the included
hard-puzzle collection.