; Sudoku Solver
; level-four.ss
;
; Level Four: recursive search.
;
; Choose a cell with two remaining candidates, save the grid,
; commit one candidate, and recursively run the solver.
; If that branch becomes invalid, restore the grid and try the
; other candidate.

(define level-four
  (lambda ()
    (let row-loop ([row 0])
      (if (= row 9)
          #f
          (let col-loop ([col 0])
            (if (= col 9)
                (row-loop (+ row 1))
                (let ([x (grid-ref row col)])
                  (if (and (vector? x)
                           (= (vector-count x) 2))
                      (let vector-loop ([loc 0])
                        (if (= loc 9)
                            (col-loop (+ col 1))
                            (let ([x2 (grid-ref row col)])
                              (if (= (vector-ref x2 loc) 1)
                                  (let ([grid-orig
                                         (copy-grid)])
                                    (grid-set! row col (+ loc 1))

                                    (if (sudoku-help grid)
                                        #t
                                        (begin
                                          (restore-grid grid-orig)
                                          (vector-loop (+ loc 1)))))
                                  (vector-loop (+ loc 1))))))
                      (col-loop (+ col 1))))))))))