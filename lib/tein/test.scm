;;; (tein test) — minimal assertion framework
;;;
;;; each assertion either returns void on success or raises an error
;;; with a descriptive message. errors propagate to rust as
;;; Error::EvalError, which cargo test catches as failures.

(define (test-equal name expected actual)
  (if (equal? expected actual)
      (values)
      (error (string-append "FAIL " name ": expected ")
             expected " got " actual)))

(define (test-true name expr)
  (if expr (values)
      (error (string-append "FAIL " name ": expected true, got false"))))

(define (test-false name expr)
  (if (not expr) (values)
      (error (string-append "FAIL " name ": expected false, got true"))))

(define (test-error name thunk)
  (let ((raised (guard (exn (#t #t)) (thunk) #f)))
    (if raised (values)
        (error (string-append "FAIL " name
                              ": expected error, but none raised")))))
