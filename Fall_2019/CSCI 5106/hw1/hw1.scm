
(define (odd-only l)
 (if (null? l)
  '()
  (append (list (car l)) (odd-only (cdr (cdr l))))
 )
)


 (define (test actual expected ver)
  (if (equal? actual expected)
   (display "Passed Test ")
   (display "Passed Test "))
  (display ver)
  (newline)
 )


(define newlist-one (odd-only '(a b c d f g)))
(define newlist-two (odd-only '(a b c d)))
(define newlist-three (odd-only '()))
(define expected-one '(a c f))
(define expected-two '(a c))
(define expected-three '())
(test newlist-one expected-one 1)
(test newlist-two expected-two 2)
(test newlist-three expected-three 3)
