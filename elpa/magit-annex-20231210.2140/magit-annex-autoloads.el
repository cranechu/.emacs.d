;;; magit-annex-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from magit-annex.el

 (autoload 'magit-annex-dispatch "magit-annex" nil t)
(eval-after-load 'magit '(progn (define-key magit-mode-map "@" 'magit-annex-dispatch) (transient-append-suffix 'magit-dispatch '(0 -1 -1) '("@" "Annex" magit-annex-dispatch))))
(autoload 'magit-annex-init "magit-annex" "\
Initialize git-annex repository.
('git annex init [DESCRIPTION]')

(fn &optional DESCRIPTION)" t)
(autoload 'magit-annex-unused-in-refs "magit-annex" "\
Show annex files not used in any branches or tags.
('git annex unused [ARGS]')

(fn &optional ARGS)" t)
(autoload 'magit-annex-unused-in-reflog "magit-annex" "\
Show annex files not used in any of the revisions in HEAD's reflog.
('git annex unused --used-refspec=reflog [ARGS]')

(fn &optional ARGS)" t)
(autoload 'magit-annex-list-files "magit-annex" "\
List annex files.
('git annex list [ARGS]')

(fn &optional ARGS)" t)
(autoload 'magit-annex-list-dir-files "magit-annex" "\
List annex files in DIRECTORY.
('git annex list [ARGS] DIRECTORY')

(fn DIRECTORY &optional ARGS)" t)
(register-definition-prefixes "magit-annex" '("magit-annex-"))

;;; End of scraped data

(provide 'magit-annex-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; magit-annex-autoloads.el ends here
