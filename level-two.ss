; Sudoku Solver
; level-two.ss
;
; Level Two: Hidden singles.
; If a candidate value occurs in only one unsolved cell of a
; row, column, or subgroup, that cell must contain the value.

(define level-two-row
  (lambda (row)
    (let loop1 ([candidate 0]
                [count1 0]
                [vec (row->vector row)])
      (if (= candidate 9)
          count1
          (let loop2 ([col 0] [matches 0] [location 0])
            (if (= col 9)
                (if (= matches 1)
                    (begin
                      (grid-set! row location (+ candidate 1))
                      (row-init row)
                      (col-init location)
                      (sub-grid-init
                        (sub-grid-list2 row location))
                      (loop1 (+ candidate 1)
                             (+ count1 1)
                             (row->vector row)))
                    (loop1 (+ candidate 1) count1 vec))
                (let ([x (vector-ref vec col)])
                  (if (and (vector? x)
                           (= (vector-ref x candidate) 1))
                      (loop2 (+ col 1)
                             (+ matches 1)
                             col)
                      (loop2 (+ col 1)
                             matches
                             location)))))))))

(define level-two-row-pass
  (lambda ()
    (let loop ([row 0] [count 0])
      (if (= row 9)
          count
          (loop (+ row 1)
                (+ count (level-two-row row)))))))

(define level-two-col
  (lambda (col)
    (let loop1 ([candidate 0]
                [count1 0]
                [vec (col->vector col)])
      (if (= candidate 9)
          count1
          (let loop2 ([row 0] [matches 0] [location 0])
            (if (= row 9)
                (if (= matches 1)
                    (begin
                      (grid-set! location col (+ candidate 1))
                      (row-init location)
                      (col-init col)
                      (sub-grid-init
                        (sub-grid-list2 location col))
                      (loop1 (+ candidate 1)
                             (+ count1 1)
                             (col->vector col)))
                    (loop1 (+ candidate 1) count1 vec))
                (let ([x (vector-ref vec row)])
                  (if (and (vector? x)
                           (= (vector-ref x candidate) 1))
                      (loop2 (+ row 1)
                             (+ matches 1)
                             row)
                      (loop2 (+ row 1)
                             matches
                             location)))))))))

(define level-two-col-pass
  (lambda ()
    (let loop ([col 0] [count 0])
      (if (= col 9)
          count
          (loop (+ col 1)
                (+ count (level-two-col col)))))))

(define level-two-sub
  (lambda (sub)
    (let loop1 ([candidate 0]
                [count1 0]
                [vec (sub-grid->vector sub)])
      (if (= candidate 9)
          count1
          (let loop2 ([i 0] [matches 0] [location 0])
            (if (= i 9)
                (if (= matches 1)
                    (let* ([bounds (sub-grid-list sub)]
                           [row (+ (car bounds)
                                   (quotient location 3))]
                           [col (+ (caddr bounds)
                                   (modulo location 3))])
                      (grid-set! row col (+ candidate 1))
                      (row-init row)
                      (col-init col)
                      (sub-grid-init sub)

                      (loop1 (+ candidate 1)
                             (+ count1 1)
                             (sub-grid->vector sub)))
                    (loop1 (+ candidate 1) count1 vec))
                (let ([x (vector-ref vec i)])
                  (if (and (vector? x)
                           (= (vector-ref x candidate) 1))
                      (loop2 (+ i 1)
                             (+ matches 1)
                             i)
                      (loop2 (+ i 1)
                             matches
                             location)))))))))

(define level-two-sub-pass
  (lambda ()
    (let loop ([sub 0] [count 0])
      (if (= sub 9)
          count
          (loop (+ sub 1)
                (+ count (level-two-sub sub)))))))