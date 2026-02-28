;;; (tein toml) — bidirectional TOML <-> scheme value conversion
;;;
;;; toml-parse and toml-stringify are registered by the rust runtime
;;; via define_fn_variadic when a standard-env context is built.
;;; this file is included by toml.sld for module definition.
