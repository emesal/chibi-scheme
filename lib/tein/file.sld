(define-library (tein file)
  (import (scheme base))
  (export file-exists? delete-file
          call-with-input-file call-with-output-file
          with-input-from-file with-output-to-file)
  (include "file.scm"))
