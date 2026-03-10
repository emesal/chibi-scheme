(define-library (tein filesystem)
  (import (scheme base))
  (export
    ;; real implementations (rust trampolines)
    file-exists? delete-file
    file-directory? file-regular? file-link?
    file-size directory-files
    create-directory delete-directory
    rename-file current-directory
    ;; deferred (raise "not implemented")
    duplicate-file-descriptor duplicate-file-descriptor-to
    close-file-descriptor renumber-file-descriptor
    open-input-file-descriptor open-output-file-descriptor
    link-file symbolic-link-file read-link
    directory-fold directory-fold-tree
    delete-file-hierarchy create-directory*
    change-directory with-directory
    open open-pipe make-fifo open-output-file/append
    file-status file-link-status
    file-device file-inode file-mode file-num-links
    file-owner file-group file-represented-device
    file-block-size file-num-blocks
    file-access-time file-change-time
    file-modification-time file-modification-time/safe
    file-character? file-block? file-fifo? file-socket?
    get-file-descriptor-flags set-file-descriptor-flags!
    get-file-descriptor-status set-file-descriptor-status!
    file-lock file-truncate
    file-is-readable? file-is-writable? file-is-executable?
    file-permissions set-file-permissions!
    chmod chown is-a-tty?
    ;; constants
    open/read open/write open/read-write
    open/create open/exclusive open/truncate
    open/append open/non-block
    lock/shared lock/exclusive lock/non-blocking lock/unlock)
  (include "filesystem.scm"))
