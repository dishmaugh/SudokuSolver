; Sudoku Solver
; level-three.ss
;
; Level Three - work in progress from the original solver.
;
; The surviving implementation recognizes a pair of identical
; two-candidate vectors in a column. Those two candidates can then
; be eliminated from every other unsolved cell in that column.
;
; Row and subgroup versions will be added after the historical
; implementation has been tested and understood.

(define replace-2
  (lambda (vec loc1 loc2)
    (let loop1 ([i 0] [count1 0])
      (if (= i 9)
          (list count1 vec)
          (let ([x (vector-ref vec i)])
            (if (and (vector? x)
                     (not (= loc1 i))
                     (not (= loc2 i)))
                (let loop2 ([j 0] [count2 count1])
                  (if (= j 9)
                      (loop1 (+ i 1) count2)
                      (let ([pair
                             (vector-ref vec loc1)])
                        (if (and (= (vector-ref pair j) 1)
                                 (= (vector-ref x j) 1))
                            (begin
                              (vector-set!
                                (vector-ref vec i) j 0)
                              (loop2 (+ j 1)
                                     (+ count2 1)))
                            (loop2 (+ j 1) count2)))))
                (loop1 (+ i 1) count1)))))))

(define level-three-col
  (lambda (col)
    (let loop1 ([i 0]
                [count1 0]
                [vec (col->vector col)])
      (if (= i 9)
          count1
          (let ([x1 (vector-ref vec i)])
            (if (and (vector? x1)
                     (= (vector-count x1) 2))
                (let loop2 ([j (+ i 1)])
                  (if (= j 9)
                      (loop1 (+ i 1) count1 vec)
                      (let ([x2 (vector-ref vec j)])
                        (if (and (vector? x2)
                                 (= (vector-count x2) 2)
                                 (equal? x1 x2))
                            (let ([result
                                   (replace-2 vec i j)])
                              (if (= (car result) 0)
                                  (loop2 (+ j 1))
                                  (begin
                                    (vector->col
                                      (cadr result) col)
                                    (loop1
                                      (+ i 1)
                                      (+ count1
                                         (car result))
                                      (col->vector col)))))
                            (loop2 (+ j 1)))))
                (loop1 (+ i 1) count1 vec))))))))

(define level-three-col-pass
  (lambda ()
    (let loop ([col 0] [count 0])
      (if (= col 9)
          count
          (loop (+ col 1)
                (+ count (level-three-col col)))))))