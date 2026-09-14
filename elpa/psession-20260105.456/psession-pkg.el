;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "psession" "20260105.456"
  "Persistent save of elisp objects."
  '((emacs  "24")
    (cl-lib "0.5")
    (async  "1.9.3"))
  :url "https://github.com/thierryvolpiatto/psession"
  :commit "ebe81c18f94bb74e0b795bbe6d4fa9284ccbbf5e"
  :revdesc "ebe81c18f94b"
  :keywords '("psession" "persistent" "save" "session")
  :authors '(("Thierry Volpiatto" . "thievol@posteo.net"))
  :maintainers '(("Thierry Volpiatto" . "thievol@posteo.net")))
