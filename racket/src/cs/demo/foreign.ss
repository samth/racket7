(import (core))

(define-syntax check
  (syntax-rules ()
    [(_ got expect)
     (let ([v got]
           [expect-v expect])
       (unless (equal? v expect-v)
         (error 'check (format "failed: ~s => ~s" 'got v))))]))

;; ----------------------------------------

(define m1 (malloc 24))

(check (ptr-set! m1 _int32 99) (void))
(check (ptr-ref m1 _int32) 99)

(define _idi (make-cstruct-type (list _int32 _double _int32)))

(check (ctype-alignof _idi) 8)
(check (ctype-sizeof _idi) 24) ; due to alignment

(define an-idi (malloc _idi))
(ptr-set! an-idi _int32 99)
(ptr-set! an-idi _double 1 99.9)

(check (ptr-ref an-idi _double 'abs 8) 99.9)

(define double-of-an-idi (ptr-add an-idi 8))
(check (ptr-ref double-of-an-idi _double) 99.9)

(define icell (malloc-immobile-cell cons))
(check (ptr-ref icell _scheme) cons)
(ptr-set! icell _scheme car)
(check (ptr-ref icell _scheme) car)
(free-immobile-cell icell)