;; tein override: file IO opcodes from (chibi) + delete-file/file-exists?
;; from (tein filesystem). FsPolicy enforcement at C opcode level.

(define-library (scheme file)
  (import (chibi) (only (tein filesystem) delete-file file-exists?))
  (export file-exists? delete-file
          open-input-file open-binary-input-file
          open-output-file open-binary-output-file
          call-with-input-file call-with-output-file
          with-input-from-file with-output-to-file))
