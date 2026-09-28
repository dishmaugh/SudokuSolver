; Rich Lewis
; Sudoku Puzzle Solver
;
; Original solver: 2006
; Modernized/refactored: 2026

(print-vector-length #f)

(load "grid.ss")
(load "constraints.ss")
(load "level-one.ss")
(load "level-two.ss")
(load "level-three.ss")
(load "level-four.ss")
(load "display.ss")


; ------------------------------------------------------------
; Temporary regression puzzle
; Historical Version 3 grid-5.
; This will move into the puzzle/test system after the
; refactored solver has been verified.
; ------------------------------------------------------------

(define load-test-grid
  (lambda ()
    (reset-grid)

    (grid-set! 0 3 7)
    (grid-set! 0 6 8)

    (grid-set! 1 2 6)
    (grid-set! 1 7 3)
    (grid-set! 1 8 1)

    (grid-set! 2 1 4)
    (grid-set! 2 5 2)

    (grid-set! 3 1 2)
    (grid-set! 3 2 4)
    (grid-set! 3 4 7)

    (grid-set! 4 1 1)
    (grid-set! 4 4 3)
    (grid-set! 4 7 8)

    (grid-set! 5 4 6)
    (grid-set! 5 6 2)
    (grid-set! 5 7 9)

    (grid-set! 6 3 8)
    (grid-set! 6 7 7)

    (grid-set! 7 0 8)
    (grid-set! 7 1 6)
    (grid-set! 7 6 5)

    (grid-set! 8 2 2)
    (grid-set! 8 5 6)))


; ------------------------------------------------------------
; Solver
; ------------------------------------------------------------

(define sudoku-help
  (lambda (ignored)
    ; Level Zero: initialize candidates from known values.
    (grid-init)

    (let loop ()
      (cond
        ; Level One: naked singles.
        [(> (level-one-pass) 0)
         (loop)]

        ; Any cell with no candidates means this branch failed.
        [(invalid?)
         #f]

        ; Level Two: hidden singles.
        [(> (level-two-row-pass) 0)
         (loop)]

        [(> (level-two-col-pass) 0)
         (loop)]

        [(> (level-two-sub-pass) 0)
         (loop)]

        ; Level Three intentionally not enabled yet.
        ; First establish that the refactor behaves exactly like
        ; the historical Version 3 solver.

        [(done?)
         #t]

        ; Level Four: recursive search/backtracking.
        [else
         (level-four)]))))


(define sudoku
  (lambda ()
    (load-test-grid)

    (if (sudoku-help grid)
        (begin
          (print-sudoku)
          #t)
        (begin
          (printf "Puzzle could not be solved.~%")
          #f))))