;; init.el

;; fast startup
(setq gc-cons-threshold 100000000)
(setq gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook 'my/set-gc-threshold)
(defun my/set-gc-threshold ()
  "Reset `gc-cons-threshold' to its default value."
  (setq gc-cons-threshold 800000))
(setq file-name-handler-alist nil)

;; package
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://stable.melpa.org/packages/") t)
(package-initialize)

;; benchmark-init
(require 'benchmark-init)
;; To disable collection of benchmark data after init is done.
(add-hook 'after-init-hook 'benchmark-init/deactivate)

;; use-package
(require 'use-package)

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; UI
(menu-bar-mode -1)
;;(tool-bar-mode -1)
;;(scroll-bar-mode -1)
(set-frame-parameter nil 'fullscreen 'fullboth)

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline 'query)

;;load path
(add-to-list 'load-path "~/.emacs.d/lisp")

;; color theme
;(load-theme 'manoj-dark t)
(load-theme 'wombat t)

;;TAGS
(setq tags-table-list '("~/ssdmeter/TAGS"))
;;use RTags for C++
;; only run this if rtags is installed
;; (add-hook 'c-mode-hook 'rtags-start-process-unless-running)
;; (add-hook 'c++-mode-hook 'rtags-start-process-unless-running)
;; (add-hook 'objc-mode-hook 'rtags-start-process-unless-running)
;; (global-set-key (kbd "M-.") 'rtags-find-symbol-at-point)
;; (global-set-key (kbd "M-,") 'rtags-location-stack-back)
;; (global-set-key (kbd "M-m") 'rtags-location-stack-forward)
;; (global-set-key (kbd "M-/") 'rtags-find-all-references-at-point)
;; (rtags-enable-standard-keybindings)
;; (setq rtags-use-helm t)
;; '(rtags-autostart-diagnostics t)
;; '(rtags-completions-enabled t)
;; '(rtags-container-timer-interval 2)
;; '(rtags-display-summary-as-tooltip t)
;; '(rtags-reparse-timeout 3000)
;; '(rtags-track-container t)
;; '(rtags-skippedline ((t (:background "dim gray"))))

;;zoom window
(require 'zoom-window)
(global-set-key (kbd "C-x C-z") 'zoom-window-zoom)

;;custom set variables
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-safe-themes
   (quote
    ("b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(ede-project-directories (quote ("~/work")))
 '(fringe-mode 0 nil (fringe))
 '(package-selected-packages
   (quote
    (python-pytest hl-todo yasnippet-snippets benchmark-init elpy beacon use-package smooth-scroll py-autopep8 rainbow-delimiters markdown-mode yaml-mode rtags go-guru neotree exec-path-from-shell helm-go-package go-playground multiple-cursors key-chord fill-column-indicator go-autocomplete go-direx go-dlv go-eldoc go-errcheck go-impl go-mode gotest ace-window magit magit-annex magit-filenotify magit-gerrit magit-gh-pulls magit-gitflow magit-imerge vlf async dash deferred epl f find-file-in-project helm-core highlight-indentation ivy js2-mode load-relative loc-changes page-break-lines pkg-info popup powerline pyvenv request request-deferred rich-minority s simple-httpd skewer-mode test-simple websocket function-args ein realgud rust-playground racer cargo eshell-up sublimity projectile smart-mode-line smart-mode-line-powerline-theme company helm-cscope helm-etags-plus rust-mode flycheck yasnippet helm-c-yasnippet helm-helm-commands zoom-window ac-helm helm helm-anything helm-dash auto-complete column-marker xcscope igrep anything anything-exuberant-ctags ppd-sr-speedbar sr-speedbar solarized-theme ##)))
 '(save-place-mode t nil (saveplace))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(zoom-window-mode-line-color "Blue"))

;;indent
(setq c-default-style "linux")
(setq c-basic-indent 2)
(setq-default c-basic-offset 2)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;;mode line
(setq sml/name-width 31)
(setq sml/shorten-modes t)
(setq rm-blacklist "")
(display-time-mode 1)
(display-battery-mode 1)
(sml/setup)

;; which function in the header line
(which-function-mode 1)
(let ((which-func '(which-func-mode ("" which-func-format " "))))
  (setq-default mode-line-format (remove which-func mode-line-format))
  (setq-default mode-line-misc-info (remove which-func mode-line-misc-info))
  (setq-default header-line-format which-func))

;; sticky function at head
(require 'stickyfunc-enhance)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(semantic-mode 1)
(global-set-key (kbd "C-c s") 'semantic-ia-show-summary)

;;line number
(setq linum-format "%4d ")
(add-hook 'prog-mode-hook 'linum-mode)
(global-set-key "\M-g" 'goto-line)

;;shell
(ansi-color-for-comint-mode-on)
(remove-hook 'comint-output-filter-functions
	     'comint-postoutput-scroll-to-bottom)

;;mark words
(defun my/mark-word-backward (N)
  (interactive "p")
  (if (and
       (not (eq last-command this-command))
       (not (eq last-command 'my/mark-word)))
      (set-mark (point)))
  (backward-word N))
(defun my/mark-word (N)
  (interactive "p")
  (if (and 
       (not (eq last-command this-command))
       (not (eq last-command 'my/mark-word-backward)))
      (set-mark (point)))
  (forward-word N))
(global-set-key (kbd "M-k") 'my/mark-word)
(global-set-key (kbd "C-M-k") 'my/mark-word-backward)

;; multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "M-n") 'mc/mark-next-like-this)
(global-set-key (kbd "M-p") 'mc/mark-previous-like-this)

;;all code
(add-hook 'prog-mode-hook 'follow-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;python
(elpy-enable)
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.pxd\\'" . python-mode))
(setq python-indent-offset 4)
(setq python-indent-guess-indent-offset nil)

;;column bondary
(require 'fill-column-indicator)
(setq fci-rule-color "darkblue")
(setq fill-column 80)
(add-hook 'c-mode-hook 'fci-mode)

;; golang not use for now
;; (require 'go-mode)
;; (setq gofmt-command "goimports")
;; (setq gofmt-is-goimports t)
;; (add-hook 'before-save-hook 'gofmt-before-save)
;; (add-to-list 'load-path "~/go/src/github.com/dougm/goflymake")
;; (add-to-list 'load-path "~/go/src/github.com/benma/go-dlv")
;; (add-hook 'go-mode-hook 'fci-mode)
;; (add-hook 'go-mode-hook 'follow-mode)
;; (require 'go-flycheck)
;; (require 'go-dlv)
;; (require 'go-autocomplete)
;; (require 'auto-complete-config)
;; (ac-config-default)
;; (go-guru-hl-identifier-mode)
;; (eval-after-load 'go-mode
;;   '(substitute-key-definition 'go-import-add 'helm-go-package go-mode-map))
;; (require 'go-guru)

;; execute commands by hitting two keys simultaneously.
(require 'key-chord)
;; reduce delay times s.t. you don't accidentally trigger a key-chord
;; during normal typing.
(setq key-chord-two-keys-delay .040
      key-chord-one-key-delay .050)
(key-chord-mode 1)
(key-chord-define-global "j1" 'delete-other-windows)
(key-chord-define-global "j2" 'split-window-vertically)
(key-chord-define-global "j3" 'split-window-horizontally)
(key-chord-define-global "j0" 'delete-windows)

;; dired
(setq dired-guess-shell-alist-user '(("\\.pdf\\'" "evince&")))

;; helm
;; 
;; (define-key helm-find-files-map "\t" 'helm-execute-persistent-action)
;; (setq

;; (provide 'init-helm)

(use-package helm
  :config
  (progn
    (require 'helm-config)
    (setq helm-candidate-number-limit 100)
    (setq helm-idle-delay 0.0           ; this actually updates things   
          helm-input-idle-delay 0.01    ; reeeelatively quickly.
          helm-split-window-in-side-p           t
          helm-move-to-line-cycle-in-source     t
          helm-ff-search-library-in-sexp        t
          helm-M-x-fuzzy-match                  t
          helm-semantic-fuzzy-match             t
          helm-buffers-fuzzy-matching           t
          helm-locate-fuzzy-match               t
          helm-recentf-fuzzy-match              t
          helm-scroll-amount                    8
          helm-ff-file-name-history-use-recentf t
          helm-yas-display-key-on-candidate     t
          helm-quick-update                     t
          helm-M-x-requires-pattern nil
          helm-ff-skip-boring-files t)
    (helm-mode 1)
    (helm-autoresize-mode 1)
    (define-key helm-find-files-map "C-j" 'helm-execute-persistent-action))
  :bind (("C-o" . helm-M-x)
         ("M-y" . helm-show-kill-ring)
         ("C-c h" . helm-command-prefix)
         ("C-j" . helm-occur)
         ("C-M-j" . helm-locate)
         ("C-x C-b" . helm-mini)
         ("C-x C-f" . helm-find-files)
         ("C-h SPC" . helm-all-mark-rings)))

;; no startup buffer
(setq inhibit-startup-message t)

;; no backup file ~
(setq make-backup-files nil)

;; debugger
;(require 'realgud)
;(require 'realgud-gdb)

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(defadvice switch-to-buffer (before save-buffer-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
  (when buffer-file-name (save-buffer)))
(defadvice ace-window (before other-window-now activate)
  (when buffer-file-name (save-buffer)))

;; save all buffer when emacs lost focus
(add-hook 'focus-out-hook (lambda () (save-some-buffers t)))

;;debug message
(setq debug-on-error t)

;;backspace
(global-set-key (kbd "M-h") 'backward-kill-word)

;;window resize
(global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)

;;window switch
(winner-mode 1)
(global-set-key (kbd "C-c C-q") 'winner-undo)
(global-set-key (kbd "C-c C-c C-q") 'winner-redo)
(global-set-key (kbd "C-q") 'ace-window)
(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(setq aw-scope 'frame)

;; neotree
(require 'neotree)
(setq neo-autorefresh nil)
(setq neo-toggle-window-keep-p t)
(setq neo-click-changes-root nil)
(setq neo-window-fixed-size t)
(setq neo-buffer--start-node "~/")
(setq neo-global--do-autorefresh nil)
(global-set-key (kbd "C-x n") 'neotree-toggle)

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

;; magit
(setq magit-refresh-status-buffer nil)
(global-set-key (kbd "C-x g") 'magit-status)

;; org
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

;;ace-jump-mode
(require 'ace-jump-mode)
(setq ace-jump-mode-scope 'frame)
(bind-key* "M-j" 'ace-jump-mode)

;; smooth scroll
(require 'smooth-scroll)
(smooth-scroll-mode 1)
(global-set-key (kbd "<C-down>") 'scroll-up-1)
(global-set-key (kbd "<C-up>") 'scroll-down-1)
(setq scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
(setq-default scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)
(setq auto-window-vscroll nil)

;; highlight something
(beacon-mode 1)
(global-hl-todo-mode 1)

;; auto complete
(electric-pair-mode 1)
(require 'auto-complete-config)
(ac-config-default)
(setq-default ac-sources '(
                           ac-source-yasnippet
                           ac-source-abbrev
                           ac-source-dictionary
                           ac-source-words-in-same-mode-buffers
                           ))

;; yasnippet
(require 'yasnippet-snippets)
(yas-global-mode 1)

;; pytest
(use-package python-pytest)

;; start to last buffer
(require 'psession)
(psession-mode 1)

;; auto generated
(setq x-select-enable-clipboard t)
(put 'upcase-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(sml/battery ((t (:inherit sml/global :foreground "white"))) t)
 '(sml/discharging ((t (:inherit sml/global :foreground "white"))))
 '(sml/filename ((t (:inherit sml/global :foreground "white" :weight bold))))
 '(sml/global ((t (:foreground "white" :inverse-video nil))))
 '(which-func ((t (:foreground "white")))))

