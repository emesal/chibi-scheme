;; (tein time) — stub definitions replaced by native rust implementations.
;; these stubs exist so that (tein time) can be imported as a library
;; dependency (e.g. by (srfi 19)) before the rust layer has had a chance
;; to inject the native versions. the tein context builder calls
;; register_module_time which overwrites these via define_fn_variadic.

(define jiffies-per-second 1000000000)

(define (current-second)
  (error "tein: (tein time) not initialised — call register_module_time"))

(define (current-jiffy)
  (error "tein: (tein time) not initialised — call register_module_time"))

(define (timezone-offset-seconds)
  (error "tein: (tein time) not initialised — call register_module_time"))
