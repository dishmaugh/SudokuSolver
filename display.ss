; Sudoku Solver
; display.ss
;
; Console display routines.

(define print-sudoku
  (lambda ()
    (printf "         column      ~%")
    (printf "    1 2 3 4 5 6 7 8 9~&")
    (newline)

    (let row-loop ([row 0])
      (unless (= row 9)
        (printf "~a   " (+ row 1))

        (let col-loop ([col 0])
          (if (= col 9)
              (begin
                (newline)
                (row-loop (+ row 1)))
              (begin
                (if (vector? (grid-ref row col))
                    (printf "  ")
                    (printf "~a " (grid-ref row col)))

                (col-loop (+ col 1)))))))))

; Diagnostic display showing candidate vectors.
(define print-grid
  (lambda ()
    (let row-loop ([row 0])
      (unless (= row 9)
        (printf "~%~%ROW: ~a~%~%" (+ row 1))

        (let col-loop ([col 0])
          (if (= col 9)
              (row-loop (+ row 1))
              (begin
                (printf "~a " (grid-ref row col))

                (if (= (modulo col 3) 2)
                    (newline))

                (col-loop (+ col 1)))))))))