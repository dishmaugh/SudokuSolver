; Sudoku Solver
; level-one.ss
;
; Level One: Naked singles.
; If an unsolved cell has exactly one candidate remaining,
; that candidate must be the value of the cell.

(define one-possible?
  (lambda (vec)
    (= (vector-count vec) 1)))

(define replace-one
  (lambda (vec)
    (let loop ([i 0])
      (if (= (vector-ref vec i) 1)
          i
          (loop (+ i 1))))))

(define level-one-row
  (lambda (row)
    (let loop ([i 0] [count 0] [vec (row->vector row)])
      (if (= i 9)
          count
          (let ([x (vector-ref vec i)])
            (if (and (vector? x) (one-possible? x))
                (begin
                  (grid-set! row i (+ (replace-one x) 1))

                  ; Propagate the new solved value immediately.
                  (row-init row)
                  (col-init i)
                  (sub-grid-init (sub-grid-list2 row i))

                  (loop (+ i 1)
                        (+ count 1)
                        (row->vector row)))
                (loop (+ i 1) count vec)))))))

(define level-one-pass
  (lambda ()
    (let loop ([row 0] [count 0])
      (if (= row 9)
          count
          (loop (+ row 1)
                (+ count (level-one-row row)))))))

(define level-one
  (lambda ()
    (let loop ()
      (unless (= (level-one-pass) 0)
        (loop)))))