(define-library (tein file)
  (import (scheme base))
  (export file-exists? delete-file
          tein-open-input-file tein-open-binary-input-file
          tein-open-output-file tein-open-binary-output-file
          call-with-input-file call-with-output-file
          with-input-from-file with-output-to-file)
  (include "file.scm"))
