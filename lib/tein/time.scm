;; (tein time) — native rust implementations are registered by the tein
;; rust layer (register_module_time) before this library is first imported.
;; chibi resolves the native fn exports via env parent-chain lookup (localp=0),
;; sharing the top-level binding cells via rename-bindings — no stubs needed.

(define jiffies-per-second 1000000000)
