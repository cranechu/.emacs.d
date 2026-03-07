;; init.el -*- lexical-binding: t; -*-

(defconst my/emacs-dir
  (file-name-directory
   (or load-file-name user-init-file buffer-file-name default-directory))
  "Directory that contains this init file.")

(defconst my/lisp-dir (expand-file-name "lisp" my/emacs-dir)
  "Directory for local Lisp files.")

(defconst my/elpa-dir (expand-file-name "elpa" my/emacs-dir)
  "Directory for local ELPA packages.")

;; Fast startup: relax GC and file handlers during init, then restore them.
(defconst my/default-gc-cons-threshold gc-cons-threshold)
(defconst my/default-gc-cons-percentage gc-cons-percentage)
(defvar my/default-file-name-handler-alist file-name-handler-alist)

(setq gc-cons-threshold 100000000
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

(defun my/restore-startup-defaults ()
  "Restore startup settings that were relaxed for faster initialization."
  (setq gc-cons-threshold my/default-gc-cons-threshold
        gc-cons-percentage my/default-gc-cons-percentage
        file-name-handler-alist my/default-file-name-handler-alist))

(add-hook 'emacs-startup-hook #'my/restore-startup-defaults)

;; Package bootstrap.
(setq package-user-dir my/elpa-dir)

(require 'package)
(require 'cc-mode)
(require 'comint)
(require 'dired-x)
(require 'imenu)
(require 'winner)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(unless package--initialized
  (package-initialize))

(add-to-list 'load-path my/lisp-dir)

(require 'use-package)

(use-package benchmark-init
  :if (locate-library "benchmark-init")
  :functions (benchmark-init/deactivate)
  :config
  (add-hook 'after-init-hook #'benchmark-init/deactivate))

;; General behavior.
(transient-mark-mode 1)

(setq diff-switches "-u"
      require-final-newline 'query
      inhibit-startup-message t
      make-backup-files nil
      select-enable-clipboard t
      debug-on-error t
      scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      auto-window-vscroll nil
      fill-column 80
      c-default-style "linux")

(setq-default c-basic-offset 2
              indent-tabs-mode nil
              tab-width 2
              scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)

;; UI.
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(add-to-list 'default-frame-alist '(fullscreen . fullboth))

(load-theme 'wombat t)

;; TAGS.
(setq tags-table-list '("~/enterprise/TAGS"))
(global-set-key (kbd "M-.") #'xref-find-definitions-other-window)

(use-package zoom-window
  :if (locate-library "zoom-window")
  :bind (("C-x C-z" . zoom-window-zoom)))

;; Mode line.
(use-package smart-mode-line
  :if (locate-library "smart-mode-line")
  :config
  (setq sml/name-width 31
        sml/shorten-modes t
        rm-blacklist ""
        sml/theme nil
        sml/no-confirm-load-theme t)
  (display-time-mode 1)
  (sml/setup))

;; Sticky function at head.
(use-package stickyfunc-enhance
  :ensure nil
  :if (locate-library "stickyfunc-enhance")
  :functions (semantic-ia-show-summary)
  :config
  (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
  (semantic-mode 1)
  (global-set-key (kbd "C-c s") #'semantic-ia-show-summary))

;; Line numbers.
(global-set-key (kbd "M-g") #'goto-line)
(global-display-line-numbers-mode 1)

;; Shell.
(ansi-color-for-comint-mode-on)
(remove-hook 'comint-output-filter-functions
             #'comint-postoutput-scroll-to-bottom)

;; Mark words.
(defun my/mark-word-backward (n)
  (interactive "p")
  (unless (or (eq last-command this-command)
              (eq last-command 'my/mark-word))
    (set-mark (point)))
  (backward-word n))

(defun my/mark-word (n)
  (interactive "p")
  (unless (or (eq last-command this-command)
              (eq last-command 'my/mark-word-backward))
    (set-mark (point)))
  (forward-word n))

(global-set-key (kbd "M-k") #'my/mark-word)
(global-set-key (kbd "C-M-k") #'my/mark-word-backward)

(use-package multiple-cursors
  :if (locate-library "multiple-cursors")
  :bind (("M-n" . mc/mark-next-like-this)
         ("M-p" . mc/mark-previous-like-this)))

(use-package iy-go-to-char
  :if (locate-library "iy-go-to-char")
  :config
  (with-eval-after-load 'multiple-cursors
    (add-to-list 'mc/cursor-specific-vars 'iy-go-to-char-start-pos)))

(use-package zzz-to-char
  :if (locate-library "zzz-to-char")
  :bind (("M-z" . zzz-up-to-char)))

;; All code.
(add-hook 'prog-mode-hook #'follow-mode)

(use-package rainbow-delimiters
  :if (locate-library "rainbow-delimiters")
  :hook (prog-mode . rainbow-delimiters-mode))

;; Fill column indicator.
(setq-default display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Dired.
(setq dired-guess-shell-alist-user
      `(( "\\.pdf\\'" ,(if (eq system-type 'darwin) "open" "xdg-open"))))

;; Helm.
(defvar helm-buffer-max-length)

(use-package helm
  :if (locate-library "helm")
  :functions (helm-autoresize-mode)
  :bind (("C-o" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x C-b" . helm-buffers-list)
         ("M-s m" . helm-mini)
         ("M-s i" . helm-imenu)
         ("M-s b" . helm-bookmarks))
  :config
  (setq helm-split-window-inside-p t
        helm-use-frame-when-more-than-two-windows nil
        helm-buffer-max-length nil
        imenu-max-item-length 120)
  (helm-mode 1)
  (helm-autoresize-mode 1))

(use-package helm-swoop
  :if (locate-library "helm-swoop")
  :bind (("C-j" . helm-swoop)))

;; Save buffers when switching context.
(defun my/save-current-buffer-if-file (&rest _)
  "Save the current buffer if it is visiting a file."
  (when buffer-file-name
    (save-buffer)))

(advice-add 'switch-to-buffer :before #'my/save-current-buffer-if-file)
(advice-add 'other-window :before #'my/save-current-buffer-if-file)

(with-eval-after-load 'ace-window
  (advice-add 'ace-window :before #'my/save-current-buffer-if-file))

;; Save all buffers when Emacs loses focus.
(defvar my/frame-focused-p t
  "Track the last known frame focus state.")

(defun my/save-buffers-on-focus-loss ()
  "Save file-visiting buffers when the selected frame loses focus."
  (let ((focused (frame-focus-state)))
    (when (and my/frame-focused-p (not focused))
      (save-some-buffers t))
    (setq my/frame-focused-p focused)))

(add-function :after after-focus-change-function
              #'my/save-buffers-on-focus-loss)

;; Auto revert/reload modified buffer.
(global-auto-revert-mode 1)

;; Editing/window helpers.
(global-set-key (kbd "M-h") #'backward-kill-word)
(global-set-key (kbd "<C-left>") #'shrink-window-horizontally)
(global-set-key (kbd "<C-right>") #'enlarge-window-horizontally)
(global-set-key (kbd "M-i") #'delete-other-windows)
(global-set-key (kbd "C-x x") #'split-window-right)

;; Window switch.
(winner-mode 1)
(global-set-key (kbd "C-c C-q") #'winner-undo)
(global-set-key (kbd "C-c C-c C-q") #'winner-redo)
(global-set-key (kbd "C-q") #'other-window)

;; Google C style.
(use-package google-c-style
  :ensure nil
  :if (locate-library "google-c-style")
  :hook ((c-mode-common . google-set-c-style)
         (c-mode-common . google-make-newline-indent)
         (c-mode-common . follow-mode)))

(defun cpplint ()
  "Check source format with cpplint and expose errors through Compilation mode."
  (interactive)
  (unless buffer-file-name
    (user-error "Current buffer is not visiting a file"))
  (compilation-start
   (format "cpplint %s" (shell-quote-argument buffer-file-name))))

;; Magit.
(use-package magit
  :if (locate-library "magit")
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-refresh-status-buffer nil))

;; Org.
(add-hook 'org-mode-hook
          (lambda ()
            (setq truncate-lines nil)))

;; Jump to visible text.
(use-package avy
  :if (locate-library "avy")
  :bind (("M-j" . avy-goto-char-timer))
  :config
  (setq avy-all-windows t))

;; Smooth scroll.
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))
(global-set-key (kbd "<C-down>") #'scroll-up-line)
(global-set-key (kbd "<C-up>") #'scroll-down-line)

;; Highlight.
(use-package beacon
  :if (locate-library "beacon")
  :config
  (beacon-mode 1))

(use-package hl-todo
  :if (locate-library "hl-todo")
  :config
  (global-hl-todo-mode 1))

;; Chinese font.
(use-package cnfonts
  :if (locate-library "cnfonts"))

;; Auto complete.
(electric-pair-mode 1)

(use-package auto-complete
  :if (locate-library "auto-complete-config")
  :config
  (require 'auto-complete-config)
  (ac-config-default)
  (setq-default ac-sources
                '(ac-source-yasnippet
                  ac-source-abbrev
                  ac-source-dictionary
                  ac-source-words-in-same-mode-buffers)))

;; Python helpers.
(use-package py-autopep8
  :if (locate-library "py-autopep8"))

(use-package cython-mode
  :if (locate-library "cython-mode"))

(use-package python-pytest
  :if (locate-library "python-pytest")
  :after python
  :bind (("C-t" . python-pytest-dispatch))
  :config
  (setq python-pytest-executable
        "python3 -B -m pytest --pciaddr=0000:01:00.0 --show-capture=no")
  (when (fboundp 'transient-append-suffix)
    (transient-append-suffix
     'python-pytest-dispatch
     "-v"
     '("-z" "print debug logging" "--log-cli-level=debug"))))

;; Session management.
(use-package psession
  :if (locate-library "psession")
  :init
  (setq psession-elisp-objects-default-directory
        (expand-file-name "elisp-objects/" my/emacs-dir))
  :config
  (psession-savehist-mode 1)
  (psession-mode 1))

(put 'upcase-region 'disabled nil)

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
 '(show-paren-mode t)
 '(size-indication-mode t)
 '(zoom-window-mode-line-color "Blue"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(sml/battery ((t (:inherit sml/global :foreground "white"))) t)
 '(sml/discharging ((t (:inherit sml/global :foreground "white"))))
 '(sml/filename ((t (:inherit sml/global :foreground "white" :weight bold))))
 '(sml/global ((t (:foreground "white" :inverse-video nil)))))
