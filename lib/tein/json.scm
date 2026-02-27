;;; (tein json) — bidirectional JSON <-> scheme value conversion
;;;
;;; json-parse and json-stringify are registered by the rust runtime
;;; via define_fn_variadic when a standard-env context is built.
;;; this file is included by json.sld for module definition.
