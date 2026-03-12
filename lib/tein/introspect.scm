;;; (tein introspect) — environment introspection for LLM agents
;;;
;;; provides runtime discovery of available modules, module exports,
;;; procedure arity, and environment bindings.

(define (available-modules) (tein-available-modules-internal))

(define (module-exports mod-path) (tein-module-exports-internal mod-path))

(define (procedure-arity proc) (tein-procedure-arity-internal proc))

(define (env-bindings . args)
  (if (null? args)
      (tein-env-bindings-internal)
      (tein-env-bindings-internal (car args))))

(define (imported-modules) (tein-imported-modules-internal))

;; --- documentation alist for this module ---

(define introspect-docs
  '((__module__ . "tein introspect")
    (available-modules . "list modules importable in current context")
    (imported-modules . "list modules already imported in current context")
    (module-exports . "list exported binding names of a module")
    (env-bindings . "list all bindings in current environment, optional prefix filter")
    (binding-info . "detailed info about a binding: kind, arity, module, docs")
    (procedure-arity . "return (min . max) arity, #f for max if variadic")
    (describe-environment . "structured data dump of all available modules and exports")
    (describe-environment/text . "pretty-printed text overview of the environment")))

;; --- reverse index: symbol → providing module ---
;; built once at import time by inverting module-exports.
;; first module in available-modules that exports a symbol wins.

(define *binding-module-index*
  (let loop ((mods (available-modules)) (index '()))
    (if (null? mods)
        index
        (let* ((mod-path (car mods))
               (exports
                (guard (exn (#t '()))
                  (module-exports mod-path))))
          (loop (cdr mods)
                (let inner ((names exports) (idx index))
                  (if (null? names)
                      idx
                      (inner (cdr names)
                             (if (assq (car names) idx)
                                 idx  ; first match wins
                                 (cons (cons (car names) mod-path) idx))))))))))

;; --- doc alist cache ---
;; eagerly load doc sub-libraries for tein modules.
;; each cache entry is (mod-path . doc-alist).

(define *doc-alist-cache*
  (let loop ((mods (available-modules)) (cache '()))
    (if (null? mods)
        cache
        (let ((mod-path (car mods)))
          (if (and (pair? mod-path)
                   (eq? (car mod-path) 'tein)
                   (pair? (cdr mod-path))
                   (null? (cddr mod-path)))
              ;; single-level tein module: try to load (tein X docs)
              (let ((docs-sym
                     (string->symbol
                      (string-append
                       (symbol->string (cadr mod-path)) "-docs"))))
                (guard (exn (#t (loop (cdr mods) cache)))
                  (let ((docs-val
                         (eval `(begin
                                  (import (tein ,(cadr mod-path) docs))
                                  ,docs-sym)
                               (environment '(scheme base) '(scheme eval)))))
                    (loop (cdr mods)
                          (cons (cons mod-path docs-val) cache)))))
              (loop (cdr mods) cache))))))

;; --- binding-info ---

(define (binding-info sym)
  (let ((kind (tein-binding-kind-internal sym)))
    (if (not kind)
        #f
        (let* ((arity (if (eq? kind 'procedure)
                          (procedure-arity (eval sym (interaction-environment)))
                          #f))
               (mod-entry (assq sym *binding-module-index*))
               (mod-path (and mod-entry (cdr mod-entry)))
               (doc-entry (and mod-path
                               (let ((cache-hit (assoc mod-path *doc-alist-cache*)))
                                 (and cache-hit
                                      (let ((doc-alist (cdr cache-hit)))
                                        (let ((d (assq sym doc-alist)))
                                          (and d
                                               (string? (cdr d))
                                               (not (string=? (cdr d) ""))
                                               (cdr d)))))))))
          (let ((result (list (cons 'name sym)
                              (cons 'kind kind))))
            (let ((result (if arity
                              (append result (list (cons 'arity arity)))
                              result)))
              (let ((result (if mod-path
                                (append result (list (cons 'module mod-path)))
                                result)))
                (if doc-entry
                    (append result (list (cons 'doc doc-entry)))
                    result))))))))

;; --- describe-environment ---

(define (module-path->string path)
  (let loop ((rest path) (acc ""))
    (cond
     ((null? rest) acc)
     ((null? (cdr rest))
      (string-append acc (if (symbol? (car rest))
                             (symbol->string (car rest))
                             (number->string (car rest)))))
     (else
      (loop (cdr rest)
            (string-append acc
                           (if (symbol? (car rest))
                               (symbol->string (car rest))
                               (number->string (car rest)))
                           " "))))))

(define (describe-environment)
  (let ((mods
         (map (lambda (mod-path)
                (let* ((exports
                        (guard (exn (#t '()))
                          (module-exports mod-path)))
                       (cache-hit (assoc mod-path *doc-alist-cache*))
                       (base (list (cons 'name mod-path)
                                   (cons 'exports exports))))
                  (if cache-hit
                      (let ((docs (cdr cache-hit)))
                        (append base
                                (list (cons 'docs
                                            (let keep ((rest docs) (acc '()))
                                              (cond
                                               ((null? rest) (reverse acc))
                                               ((eq? (caar rest) '__module__)
                                                (keep (cdr rest) acc))
                                               ((string=? (cdar rest) "")
                                                (keep (cdr rest) acc))
                                               (else
                                                (keep (cdr rest) (cons (car rest) acc)))))))))
                      base)))
              (available-modules))))
    (list (cons 'modules mods))))

(define (describe-environment/text)
  (let* ((env-data (describe-environment))
         (modules (cdr (assq 'modules env-data))))
    (string-append
     "(tein introspect) — environment overview\n\n"
     (number->string (length modules)) " modules available:\n\n"
     (apply string-append
            (map (lambda (mod-info)
                   (let* ((name (cdr (assq 'name mod-info)))
                          (exports (cdr (assq 'exports mod-info)))
                          (docs-entry (assq 'docs mod-info))
                          (name-str (module-path->string name))
                          (n (length exports)))
                     (string-append
                      "(" name-str ") — " (number->string n) " exports\n"
                      (if (and docs-entry (pair? (cdr docs-entry)))
                          ;; tein module with docs: show each with docstring
                          (apply string-append
                                 (map (lambda (exp)
                                        (let ((doc (assq exp (cdr docs-entry))))
                                          (if (and doc (string? (cdr doc))
                                                   (not (string=? (cdr doc) "")))
                                              (string-append "  " (symbol->string exp)
                                                             " — " (cdr doc) "\n")
                                              (string-append "  " (symbol->string exp) "\n"))))
                                      exports))
                          ;; no docs: comma-separated summary
                          (if (> n 0)
                              (string-append
                               "  "
                               (let loop ((rest exports) (acc ""))
                                 (cond
                                  ((null? rest) acc)
                                  ((null? (cdr rest))
                                   (string-append acc (symbol->string (car rest))))
                                  (else
                                   (loop (cdr rest)
                                         (string-append acc (symbol->string (car rest)) ", ")))))
                               "\n")
                              ""))
                      "\n")))
                 modules)))))
