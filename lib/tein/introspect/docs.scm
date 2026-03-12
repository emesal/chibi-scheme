;;; (tein introspect docs) — documentation alist for (tein introspect)

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
