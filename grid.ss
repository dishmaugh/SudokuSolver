; Sudoku Solver
; grid.ss
;
; Grid representation and candidate-vector management.
;
; A solved cell contains an integer 1-9.
; An unsolved cell contains a nine-element vector.
; A 1 means the value is still possible; 0 means it has been eliminated.

(define make-table
  (lambda (nr nc init)
    (let ([tbl (make-vector nr)])
      (let insert-rows! ([i 0])
        (unless (= i nr)
          (vector-set! tbl i (make-vector nc init))
          (insert-rows! (+ i 1))))
      tbl)))

(define table-set!
  (lambda (tbl ri ci x)
    (vector-set! (vector-ref tbl ri) ci x)))

(define table-ref
  (lambda (tbl ri ci)
    (vector-ref (vector-ref tbl ri) ci)))

(define make-grid
  (lambda ()
    (let ([new-grid (make-table 9 9 #f)])
      (let row-loop ([row 0])
        (if (= row 9)
            new-grid
            (let col-loop ([col 0])
              (if (= col 9)
                  (row-loop (+ row 1))
                  (begin
                    (table-set! new-grid row col (make-vector 9 1))
                    (col-loop (+ col 1))))))))))

; The solver operates on this grid.
(define grid (make-grid))

(define grid-ref
  (lambda (row col)
    (table-ref grid row col)))

(define grid-set!
  (lambda (row col val)
    (table-set! grid row col val)))

(define reset-row
  (lambda (row)
    (let loop ([col 0])
      (unless (= col 9)
        (grid-set! row col (make-vector 9 1))
        (loop (+ col 1))))))

(define reset-grid
  (lambda ()
    (let row-loop ([row 0])
      (unless (= row 9)
        (let col-loop ([col 0])
          (if (= col 9)
              (row-loop (+ row 1))
              (begin
                (grid-set! row col (make-vector 9 1))
                (col-loop (+ col 1)))))))))

; Returns the inclusive row/column boundaries of a 3x3 subgroup:
; (row-start row-end col-start col-end)
(define sub-grid-list
  (lambda (sub)
    (case sub
      [(0) '(0 2 0 2)]
      [(1) '(0 2 3 5)]
      [(2) '(0 2 6 8)]
      [(3) '(3 5 0 2)]
      [(4) '(3 5 3 5)]
      [(5) '(3 5 6 8)]
      [(6) '(6 8 0 2)]
      [(7) '(6 8 3 5)]
      [(8) '(6 8 6 8)])))

; Returns the subgroup number containing a particular cell.
(define sub-grid-list2
  (lambda (row col)
    (case row
      [(0 1 2)
       (case col
         [(0 1 2) 0]
         [(3 4 5) 1]
         [(6 7 8) 2])]
      [(3 4 5)
       (case col
         [(0 1 2) 3]
         [(3 4 5) 4]
         [(6 7 8) 5])]
      [(6 7 8)
       (case col
         [(0 1 2) 6]
         [(3 4 5) 7]
         [(6 7 8) 8])])))

(define row->vector
  (lambda (row)
    (let ([vec (make-vector 9 #f)])
      (let loop ([i 0])
        (if (= i 9)
            vec
            (begin
              (vector-set! vec i (grid-ref row i))
              (loop (+ i 1))))))))

(define col->vector
  (lambda (col)
    (let ([vec (make-vector 9 #f)])
      (let loop ([i 0])
        (if (= i 9)
            vec
            (begin
              (vector-set! vec i (grid-ref i col))
              (loop (+ i 1))))))))

(define sub-grid->vector
  (lambda (sub-grid)
    (let* ([sub (sub-grid-list sub-grid)]
           [vec (make-vector 9 #f)]
           [row1 (car sub)]
           [row2 (cadr sub)]
           [col1 (caddr sub)]
           [col2 (cadddr sub)])
      (let loop1 ([row row1] [k 0])
        (if (= k 9)
            vec
            (let loop2 ([col col1] [k k])
              (if (= col (+ col2 1))
                  (loop1 (+ row 1) k)
                  (begin
                    (vector-set! vec k (grid-ref row col))
                    (loop2 (+ col 1) (+ k 1))))))))))

(define vector->row
  (lambda (vec row)
    (let loop ([i 0])
      (unless (= i 9)
        (grid-set! row i (vector-ref vec i))
        (loop (+ i 1))))))

(define vector->col
  (lambda (vec col)
    (let loop ([i 0])
      (unless (= i 9)
        (grid-set! i col (vector-ref vec i))
        (loop (+ i 1))))))

(define vector->sub-grid
  (lambda (vec sub-grid)
    (let* ([sub (sub-grid-list sub-grid)]
           [row1 (car sub)]
           [row2 (cadr sub)]
           [col1 (caddr sub)]
           [col2 (cadddr sub)])
      (let loop1 ([row row1] [k 0])
        (unless (= k 9)
          (let loop2 ([col col1] [k k])
            (if (= col (+ col2 1))
                (loop1 (+ row 1) k)
                (begin
                  (grid-set! row col (vector-ref vec k))
                  (loop2 (+ col 1) (+ k 1))))))))))

; Remove solved values in a unit from the candidate vectors
; of every unsolved cell in that unit.
(define vector-init
  (lambda (vec)
    (let main-loop ([i 0])
      (if (= i 9)
          vec
          (let ([x (vector-ref vec i)])
            (if (vector? x)
                (main-loop (+ i 1))
                (let sub-loop ([j 0])
                  (if (= j 9)
                      (main-loop (+ i 1))
                      (let ([y (vector-ref vec j)])
                        (if (vector? y)
                            (begin
                              (vector-set! y (- x 1) 0)
                              (sub-loop (+ j 1)))
                            (sub-loop (+ j 1))))))))))))

(define row-init
  (lambda (row)
    (vector->row (vector-init (row->vector row)) row)))

(define col-init
  (lambda (col)
    (vector->col (vector-init (col->vector col)) col)))

(define sub-grid-init
  (lambda (sub)
    (vector->sub-grid
      (vector-init (sub-grid->vector sub))
      sub)))

(define row-init-all
  (lambda ()
    (let loop ([i 0])
      (unless (= i 9)
        (row-init i)
        (loop (+ i 1))))))

(define col-init-all
  (lambda ()
    (let loop ([i 0])
      (unless (= i 9)
        (col-init i)
        (loop (+ i 1))))))

(define sub-grid-init-all
  (lambda ()
    (let loop ([i 0])
      (unless (= i 9)
        (sub-grid-init i)
        (loop (+ i 1))))))

(define grid-init
  (lambda ()
    (row-init-all)
    (col-init-all)
    (sub-grid-init-all)))

(define vector-count
  (lambda (vec)
    (let loop ([i 0] [count 0])
      (if (= i 9)
          count
          (loop (+ i 1)
                (if (= (vector-ref vec i) 1)
                    (+ count 1)
                    count))))))

(define copy-grid
  (lambda ()
    (let ([grid-orig (make-grid)])
      (let row-loop ([row 0])
        (if (= row 9)
            grid-orig
            (let col-loop ([col 0])
              (if (= col 9)
                  (row-loop (+ row 1))
                  (let ([x1 (table-ref grid row col)]
                        [y1 (table-ref grid-orig col row)])
                    (if (not (vector? x1))
                        (begin
                          (table-set! grid-orig col row x1)
                          (col-loop (+ col 1)))
                        (let vector-loop ([loc 0])
                          (if (= loc 9)
                              (col-loop (+ col 1))
                              (begin
                                (vector-set! y1 loc
                                             (vector-ref x1 loc))
                                (vector-loop (+ loc 1))))))))))))))

(define restore-grid
  (lambda (grid-orig)
    (reset-grid)
    (let row-loop ([row 0])
      (unless (= row 9)
        (let col-loop ([col 0])
          (if (= col 9)
              (row-loop (+ row 1))
              (let ([y1 (table-ref grid-orig row col)])
                (if (not (vector? y1))
                    (begin
                      (grid-set! row col y1)
                      (col-loop (+ col 1)))
                    (let vector-loop ([loc 0])
                      (if (= loc 9)
                          (col-loop (+ col 1))
                          (begin
                            (vector-set! (grid-ref row col)
                                         loc
                                         (vector-ref y1 loc))
                            (vector-loop (+ loc 1)))))))))))))