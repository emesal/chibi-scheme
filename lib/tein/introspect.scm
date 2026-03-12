;;; (tein introspect) — environment introspection for LLM agents
;;;
;;; provides runtime discovery of available modules, module exports,
;;; procedure arity, and environment bindings.

(define (available-modules) (tein-available-modules-internal))

(define (module-exports mod-path) (tein-module-exports-internal mod-path))
