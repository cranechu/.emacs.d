;; .emacs

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; UI
(menu-bar-mode -1)
;;(tool-bar-mode -1)
;;(scroll-bar-mode -1)
(set-frame-parameter nil 'fullscreen 'fullboth)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline 'query)

;;load path
(add-to-list 'load-path "~/.emacs.d/lisp")

;;package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://stable.melpa.org/packages/") t)
(package-initialize)

;;dark color theme
(load-theme 'manoj-dark t)

;;TAGS
;;(setq tags-table-list '("~/ceph/TAGS"))
;;use RTags for C++
;; only run this if rtags is installed
(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
(add-hook 'objc-mode-hook 'rtags-start-process-unless-running)
(global-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
(global-set-key (kbd "M-,") 'rtags-location-stack-back)
(global-set-key (kbd "M-<") 'rtags-location-stack-forward)
(global-set-key (kbd "M-/") 'rtags-find-all-references-at-point)
(rtags-enable-standard-keybindings)
(setq rtags-use-helm t)

;; replace tabs with spaces
(setq c-basic-indent 8)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 8)
(setq indent-line-function 'insert-tab)
(setq-default c-basic-offset 8
              tab-width 8
              indent-tabs-mode t)

;;zoom window
(require 'zoom-window)
(global-set-key (kbd "C-x C-z") 'zoom-window-zoom)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(ede-project-directories (quote ("~/work")))
 '(fringe-mode 0 nil (fringe))
 '(package-selected-packages
   (quote
    (vlf flycheck-rtags helm-rtags rtags async dash deferred epl f find-file-in-project helm-core highlight-indentation ivy js2-mode load-relative loc-changes page-break-lines pkg-info popup powerline pyvenv request request-deferred rich-minority s simple-httpd skewer-mode test-simple websocket function-args ein realgud rust-playground racer cargo elpy eshell-up sublimity projectile dashboard smart-mode-line smart-mode-line-powerline-theme company helm-cscope helm-etags-plus rust-mode flycheck yasnippet helm-c-yasnippet helm-helm-commands zoom-window ac-helm helm helm-anything helm-dash auto-complete column-marker xcscope igrep anything anything-exuberant-ctags ppd-sr-speedbar sr-speedbar solarized-theme ##)))
 '(save-place-mode t nil (saveplace))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(zoom-window-mode-line-color "DarkGreen"))

;;start with 2 vertical windows
(defun 2-windows-vertical-to-horizontal ()
  (let ((buffers (mapcar 'window-buffer (window-list))))
    (when (= 2 (length buffers))
      (delete-other-windows)
      (set-window-buffer (split-window-horizontally) (cadr buffers)))))
(add-hook 'emacs-startup-hook '2-windows-vertical-to-horizontal)

;;indent
(setq-default c-basic-offset 2)
(setq c-default-style "linux"
      c-basic-offset 2)

;;mode line
(sml/setup)
(display-time-mode 1)
(display-battery-mode 1)

;;line number
(global-linum-mode t)
;(defun linum-format-func (line)
;  (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
;    (propertize (format (format "%%%dd " w) line) 'face 'linum)))
;(setq linum-format 'linum-format-func)
;(add-hook 'speedbar-mode-hook '(lambda () (linum-mode -1)))
(setq linum-format "%4d ")

;;shell
(ansi-color-for-comint-mode-on)
(remove-hook 'comint-output-filter-functions
	     'comint-postoutput-scroll-to-bottom)
;;(require 'eshell-up)

;;python
(elpy-enable)

;;coding enhancements
(require 'xcscope)
(require 'column-marker)
(require 'sr-speedbar)
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

;;helm
(require 'helm)
(require 'helm-config)
(helm-mode 1)
(helm-autoresize-mode 1)

(global-set-key (kbd "C-o") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-set-key (kbd "C-i") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)

(setq helm-split-window-in-side-p           t
      helm-move-to-line-cycle-in-source     t
      helm-ff-search-library-in-sexp        t
      helm-M-x-fuzzy-match                  t
      helm-buffers-fuzzy-matching           t
      helm-locate-fuzzy-match               t
      helm-recentf-fuzzy-match              t
      helm-scroll-amount                    8
      helm-ff-file-name-history-use-recentf t)

(provide 'init-helm)

;;delete trailing spaces
;(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; no startup buffer
(setq inhibit-startup-message t)

;; no backup file ~
(setq make-backup-files nil)

;;debug
(require 'realgud)
(require 'realgud-gdb)

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(defadvice switch-to-buffer (before save-buffer-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-up (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-down (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-left (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice windmove-right (before other-window-now activate)
  (when buffer-file-name (save-buffer)))

;;debug message
(setq debug-on-error t)

;;backspace
(global-set-key (kbd "M-h") 'backward-kill-word)

;;window resize
(global-set-key (kbd "<C-up>") 'shrink-window)
(global-set-key (kbd "<C-down>") 'enlarge-window)
(global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)

;;window switch
(global-set-key (kbd "C-q") 'other-window)

;;dashboard on startup
(require 'dashboard)
(dashboard-setup-startup-hook)

;;google c style
(require 'cc-mode)
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)
(add-hook 'c-mode-common-hook 'follow-mode)
(defun cpplint ()
  "check source code format according to Google Style Guide, command: next-error, previous-error"
  (interactive)
  (compilation-start (concat "cpplint " (buffer-file-name))))

;; no exit by accident
(global-set-key (kbd "C-x C-c") 'save-some-buffers)

(setq x-select-enable-clipboard t)
(put 'upcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
