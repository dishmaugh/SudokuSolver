; Sudoku Solver
; constraints.ss
;
; General grid-state tests.

(define done?
  (lambda ()
    (let row-loop ([row 0] [count 0])
      (if (= row 9)
          (= count 0)
          (let col-loop ([col 0] [count count])
            (if (= col 9)
                (row-loop (+ row 1) count)
                (if (vector? (grid-ref row col))
                    (col-loop (+ col 1) (+ count 1))
                    (col-loop (+ col 1) count))))))))

; A candidate vector containing no possibilities represents
; a contradiction and therefore an invalid branch.
(define invalid?
  (lambda ()
    (let row-loop ([row 0] [count 0])
      (if (= row 9)
          (> count 0)
          (let col-loop ([col 0] [count count])
            (if (= col 9)
                (row-loop (+ row 1) count)
                (let ([x (grid-ref row col)])
                  (if (and (vector? x)
                           (= (vector-count x) 0))
                      (col-loop (+ col 1) (+ count 1))
                      (col-loop (+ col 1) count)))))))))