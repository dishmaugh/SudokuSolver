; Sudoku Solver
; level-three.ss
;
; Level Three -- candidate set reduction.
;
; If N unresolved cells in a row, column, or subgroup contain
; exactly N possible values between them, those values must occur
; in those cells.  The values can therefore be removed from every
; other unresolved cell in the unit.
;
; This generalizes the replace-2 logic from the original solver.
; The same algorithm handles pairs, triples, quads, and larger
; candidate sets.


; ------------------------------------------------------------
; Copy a candidate vector.
; ------------------------------------------------------------

(define copy-candidate-vector
  (lambda (vec)
    (let ([newvec (make-vector 9 0)])
      (let loop ([i 0])
        (unless (= i 9)
          (vector-set! newvec i (vector-ref vec i))
          (loop (+ i 1))))
      newvec)))


; ------------------------------------------------------------
; Add the candidates in vec to union.
;
; Both vectors use the original solver representation:
;
;     #(0 1 0 1 0 0 0 0 0)
;
; means that values 2 and 4 are possible.
; ------------------------------------------------------------

(define candidate-union!
  (lambda (union vec)
    (let loop ([i 0])
      (unless (= i 9)
        (when (= (vector-ref vec i) 1)
          (vector-set! union i 1))
        (loop (+ i 1))))))


; ------------------------------------------------------------
; Count the candidates contained in a candidate vector.
; ------------------------------------------------------------

(define candidate-count
  (lambda (vec)
    (let loop ([i 0] [count 0])
      (if (= i 9)
          count
          (loop (+ i 1)
                (+ count (vector-ref vec i)))))))


; ------------------------------------------------------------
; Determine whether a position occurs in a list of positions.
; ------------------------------------------------------------

(define position-member?
  (lambda (position positions)
    (cond
      [(null? positions)
       #f]

      [(= position (car positions))
       #t]

      [else
       (position-member? position (cdr positions))])))


; ------------------------------------------------------------
; Remove all candidates contained in union from every unresolved
; cell not belonging to the selected candidate set.
;
; Returns the number of candidates removed.
; ------------------------------------------------------------

(define remove-candidate-union
  (lambda (vec selected union)
    (let cell-loop ([i 0] [count 0])
      (if (= i 9)
          count

          (let ([x (vector-ref vec i)])
            (if (and (vector? x)
                     (not (position-member? i selected)))

                (let candidate-loop ([j 0] [removed 0])
                  (if (= j 9)
                      (cell-loop (+ i 1)
                                 (+ count removed))

                      (if (and (= (vector-ref union j) 1)
                               (= (vector-ref x j) 1))
                          (begin
                            (vector-set! x j 0)
                            (candidate-loop (+ j 1)
                                            (+ removed 1)))

                          (candidate-loop (+ j 1)
                                          removed))))

                (cell-loop (+ i 1) count)))))))


; ------------------------------------------------------------
; Test one selected collection of cells.
;
; If N selected cells contain exactly N candidates between them,
; remove those candidates from the remaining cells in the unit.
;
; Returns the number of candidates removed.
; ------------------------------------------------------------

(define level-three-reduce
  (lambda (vec selected)
    (let ([union (make-vector 9 0)])

      (let union-loop ([positions selected])
        (unless (null? positions)
          (candidate-union!
            union
            (vector-ref vec (car positions)))

          (union-loop (cdr positions))))

      (if (= (length selected)
             (candidate-count union))

          (remove-candidate-union
            vec
            selected
            union)

          0))))


; ------------------------------------------------------------
; Search combinations of size n within one nine-cell unit.
;
; Only unresolved cells participate in a candidate set.
;
; Returns the total number of candidate eliminations.
; ------------------------------------------------------------

(define level-three-combinations
  (lambda (vec n)

    (let search ([start 0]
                 [remaining n]
                 [selected '()]
                 [count 0])

      (cond
        [(= remaining 0)
         (+ count
            (level-three-reduce
              vec
              (reverse selected)))]

        [(= start 9)
         count]

        [else
         (let ([x (vector-ref vec start)])

           (if (vector? x)

               (let ([with-current
                       (search
                         (+ start 1)
                         (- remaining 1)
                         (cons start selected)
                         count)])

                 (search
                   (+ start 1)
                   remaining
                   selected
                   with-current))

               (search
                 (+ start 1)
                 remaining
                 selected
                 count)))]))))


; ------------------------------------------------------------
; Process one complete row/column/subgroup vector.
;
; Start with pairs and work upward.  Eight is the largest useful
; candidate set: if all nine cells were selected there would be
; no other cell from which to remove candidates.
;
; Returns the number of candidates removed.
; ------------------------------------------------------------

(define level-three-vector
  (lambda (vec)
    (let loop ([n 2] [count 0])
      (if (= n 9)
          count

          (loop
            (+ n 1)
            (+ count
               (level-three-combinations vec n)))))))


; ------------------------------------------------------------
; Row reduction.
; ------------------------------------------------------------

(define level-three-row
  (lambda (row)
    (let ([vec (row->vector row)])
      (let ([count (level-three-vector vec)])
        (when (> count 0)
          (vector->row vec row))
        count))))


; ------------------------------------------------------------
; Column reduction.
; ------------------------------------------------------------

(define level-three-col
  (lambda (col)
    (let ([vec (col->vector col)])
      (let ([count (level-three-vector vec)])
        (when (> count 0)
          (vector->col vec col))
        count))))


; ------------------------------------------------------------
; Subgroup reduction.
; ------------------------------------------------------------

(define level-three-sub
  (lambda (sub)
    (let ([vec (sub-grid->vector sub)])
      (let ([count (level-three-vector vec)])
        (when (> count 0)
          (vector->sub-grid vec sub))
        count))))


; ------------------------------------------------------------
; Run Level Three across all rows.
; ------------------------------------------------------------

(define level-three-row-pass
  (lambda ()
    (let loop ([row 0] [count 0])
      (if (= row 9)
          count
          (loop
            (+ row 1)
            (+ count
               (level-three-row row)))))))


; ------------------------------------------------------------
; Run Level Three across all columns.
; ------------------------------------------------------------

(define level-three-col-pass
  (lambda ()
    (let loop ([col 0] [count 0])
      (if (= col 9)
          count
          (loop
            (+ col 1)
            (+ count
               (level-three-col col)))))))


; ------------------------------------------------------------
; Run Level Three across all 3x3 subgroups.
; ------------------------------------------------------------

(define level-three-sub-pass
  (lambda ()
    (let loop ([sub 0] [count 0])
      (if (= sub 9)
          count
          (loop
            (+ sub 1)
            (+ count
               (level-three-sub sub)))))))