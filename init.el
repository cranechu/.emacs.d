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
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
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
(tool-bar-mode -1)
;;(scroll-bar-mode -1)
(set-frame-parameter nil 'fullscreen 'fullboth)

;; default to unified diffs
(setq diff-switches "-u")

;; always end a file with a newline
(setq require-final-newline 'query)

;;load path
(add-to-list 'load-path "~/.emacs.d/lisp")

;; color theme
(load-theme 'wombat t)

;;TAGS
(setq tags-table-list '("~/enterprise/TAGS"))
(global-set-key (kbd "M-.") 'xref-find-definitions-other-window)

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
   '("b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default))
 '(ede-project-directories '("~/work"))
 '(fringe-mode 0 nil (fringe))
 '(grep-command "grep --color -nH --null -Ir -e ")
 '(grep-find-command
   '("find . -type f -exec grep --color -nH --null -e  \\{\\} +" . 49))
 '(package-selected-packages
   '(cython-mode csharp-mode python-pytest clang-format cnfonts psession ace-jump-mode ack zzz-to-char undo-tree iy-go-to-char super-save benchmark-init elpy beacon smooth-scroll py-autopep8 go-guru exec-path-from-shell helm-go-package go-playground key-chord fill-column-indicator go-autocomplete go-direx go-eldoc go-errcheck go-impl ace-window magit-filenotify magit-gerrit magit-gitflow deferred epl f find-file-in-project highlight-indentation pkg-info request-deferred rich-minority s function-args ein racer cargo eshell-up smart-mode-line smart-mode-line-powerline-theme company helm-cscope helm-helm-commands ac-helm helm-anything helm-dash auto-complete column-marker igrep anything anything-exuberant-ctags ppd-sr-speedbar sr-speedbar ##))
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
(sml/setup)

;; sticky function at head
(require 'stickyfunc-enhance)
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
(semantic-mode 1)
(global-set-key (kbd "C-c s") 'semantic-ia-show-summary)

;;line number
(global-set-key "\M-g" 'goto-line)
(global-display-line-numbers-mode)

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

;; go to char for mc
(require 'iy-go-to-char)
(add-to-list 'mc/cursor-specific-vars 'iy-go-to-char-start-pos)

;; zap up to char
(require 'zzz-to-char)
(global-set-key (kbd "M-z") #'zzz-up-to-char)

;;;; undo tree
;;(global-undo-tree-mode)
;;(setq undo-tree-visualizer-diff t)

;;all code
(add-hook 'prog-mode-hook 'follow-mode)
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;;python
;;(elpy-enable)
;;(setq elpy-rpc-python-command "python3")
;;(add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-mode))
;;(add-to-list 'auto-mode-alist '("\\.pxd\\'" . python-mode))
;;(setq python-indent-offset 4)
;;(setq python-indent-guess-indent-offset nil)

;;column bondary
(require 'fill-column-indicator)
(setq fci-rule-color "darkblue")
(setq fill-column 80)
(add-hook 'prog-mode-hook 'fci-mode)

;; dired
(setq dired-guess-shell-alist-user '(("\\.pdf\\'" "evince&")))

(use-package helm
  :ensure t
  :config
  (setq helm-split-window-inside-p t)
  (setq helm-use-frame-when-more-than-two-windows nil)
  (helm-autoresize-mode 1))

(use-package helm-mode
    :config (helm-mode 1))

(use-package helm-command
    :bind (("C-o" . helm-M-x)))

(use-package helm-files
    :bind (("C-x C-f" . helm-find-files)))

(use-package helm-buffers
    :bind (("C-x C-b" . helm-buffers-list)
           ("M-s m" . helm-mini))
    :config (setq helm-buffer-max-length nil))

(use-package helm-occur
    :bind (("C-j" . helm-swoop)))

(use-package helm-imenu
    :bind (("M-s i" . helm-imenu))
    :config (setq imenu-max-item-length 120))

(use-package helm-bookmarks
    :bind (("M-s b" . helm-bookmarks)))


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

;; auto revert/reload modified buffer
(global-auto-revert-mode t)

;;debug message
(setq debug-on-error t)

;;backspace
(global-set-key (kbd "M-h") 'backward-kill-word)

;;window resize
(global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)
(global-set-key (kbd "M-i") 'delete-other-windows)
(global-set-key (kbd "C-x x") 'split-window-right)

;;window switch
(winner-mode 1)
(global-set-key (kbd "C-c C-q") 'winner-undo)
(global-set-key (kbd "C-c C-c C-q") 'winner-redo)
(global-set-key (kbd "C-q") 'other-window)

;;;; neotree
;;(require 'neotree)
;;(setq neo-autorefresh nil)
;;(setq neo-toggle-window-keep-p t)
;;(setq neo-click-changes-root nil)
;;(setq neo-window-fixed-size t)
;;(setq neo-buffer--start-node "~/")
;;(setq neo-global--do-autorefresh nil)
;;(global-set-key (kbd "C-x n") 'neotree-toggle)

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

;; chinese font
(require 'cnfonts)

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

;; autopep8
(require 'py-autopep8)

;; cython
(require 'cython-mode)

;; pytest
(use-package python-pytest
  :after python
  :config
  (setq python-pytest-executable "sudo python3 -B -m pytest --pciaddr=0000:01:00.0 --show-capture=no")
  (transient-append-suffix
    'python-pytest-dispatch
    "-v"
    '("-z" "print debug logging" "--log-cli-level=debug"))
  :bind (("C-t" . python-pytest-popup)))

;; system clipboard
(setq x-select-enable-clipboard t)

;; session management
(use-package psession
  :config
  (psession-savehist-mode 1)
  (psession-mode 1))

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
 '(sml/global ((t (:foreground "white" :inverse-video nil)))))

