; Load one puzzle block into the current grid.
; A block consists of a puzzle identifier followed by
; nine strings containing digits 0-9, where 0 is blank.

#| (define input-block
  (lambda (block)
    (unless (= (length block) 10)
      (error 'input-block "invalid block"))

    (reset-grid)

    (let row-loop ([row 0]
                   [lines (cdr block)])
      (unless (= row 9)

        (let ([str (car lines)])
          (unless (and (string? str)
                       (= (string-length str) 9))
            (error 'input-block "invalid puzzle row ~s" str))

          (let col-loop ([col 0])
            (unless (= col 9)

              (let ([c (string-ref str col)])
                (case c
                  [(#\0)
                   ; Leave the candidate vector created by reset-grid.
                   #f]

                  [(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)
                   (grid-set!
                    row
                    col
                    (- (char->integer c)
                       (char->integer #\0)))]

                  [else
                   (error 'input-block
                          "invalid puzzle character ~s"
                          c)]))

              (col-loop (+ col 1)))))

        (row-loop (+ row 1)
                  (cdr lines)))))) |#

(define input-block
  (lambda (block)
    (printf "DEBUG input-block: starting~%")

    (unless (= (length block) 10)
      (error 'input-block "invalid block"))

    (reset-grid)
    (printf "DEBUG input-block: grid reset~%")

    (let row-loop ([row 0]
                   [lines (cdr block)])
      (unless (= row 9)

        (let ([str (car lines)])
          (printf "DEBUG input-block: row ~a = ~s~%" row str)

          (unless (and (string? str)
                       (= (string-length str) 9))
            (error 'input-block "invalid puzzle row ~s" str))

          (let col-loop ([col 0])
            (unless (= col 9)

              (let ([c (string-ref str col)])
                (case c
                  [(#\0)
                   #f]

                  [(#\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)
                   (let ([value
                          (- (char->integer c)
                             (char->integer #\0))])

                     (printf
                       "DEBUG input-block: setting row ~a col ~a = ~a~%"
                       row col value)

                     (grid-set! row col value))]

                  [else
                   (error 'input-block
                          "invalid puzzle character ~s"
                          c)]))

              (col-loop (+ col 1)))))

        (row-loop (+ row 1)
                  (cdr lines))))

    (printf "DEBUG input-block: finished loading grid~%")))