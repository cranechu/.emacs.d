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

(defconst my/default-gc-cons-threshold
  (if (boundp 'my/initial-gc-cons-threshold)
      my/initial-gc-cons-threshold
    gc-cons-threshold))

(defconst my/default-gc-cons-percentage
  (if (boundp 'my/initial-gc-cons-percentage)
      my/initial-gc-cons-percentage
    gc-cons-percentage))

(defvar my/default-file-name-handler-alist
  (if (boundp 'my/initial-file-name-handler-alist)
      my/initial-file-name-handler-alist
    file-name-handler-alist))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

(defun my/restore-startup-defaults ()
  "Restore startup settings that were relaxed for faster initialization."
  (setq gc-cons-threshold (* 32 1024 1024)
        gc-cons-percentage 0.1
        file-name-handler-alist my/default-file-name-handler-alist))

(add-hook 'emacs-startup-hook #'my/restore-startup-defaults)

(defun my/gc-on-focus-out ()
  "Run garbage collection when Emacs loses focus."
  (unless (frame-focus-state)
    (garbage-collect)))

(add-function :after after-focus-change-function #'my/gc-on-focus-out)

;; `anything' still references these browser variables, removed in Emacs 30.
(defvar browse-url-galeon-program "galeon")
(defvar browse-url-netscape-program "netscape")
(defvar browse-url-mosaic-program "xmosaic")

;; Package bootstrap.  The quickstart cache replaces hundreds of individual
;; package descriptor/autoload reads with one precomputed file.
(declare-function package-quickstart-refresh "package")

(setq package-user-dir my/elpa-dir
      package-quickstart t
      package-quickstart-file (expand-file-name "package-quickstart.el"
                                                my/emacs-dir)
      package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/"))
      package-native-compile t)

(unless (bound-and-true-p package--activated)
  (package-activate-all))

(defun my/package-quickstart-refresh-if-needed ()
  "Build the package quickstart cache after the first uncached startup."
  (when (and package-quickstart
             (not (file-readable-p package-quickstart-file)))
    (require 'package)
    (package-quickstart-refresh)))

(defun my/schedule-package-quickstart-refresh ()
  "Schedule creation of a missing package quickstart cache."
  (when (and package-quickstart
             (not (file-readable-p package-quickstart-file)))
    (run-with-idle-timer 1 nil #'my/package-quickstart-refresh-if-needed)))

(add-hook 'emacs-startup-hook #'my/schedule-package-quickstart-refresh)

(add-to-list 'load-path my/lisp-dir)

(require 'use-package)

(use-package benchmark-init
  :if (locate-library "benchmark-init")
  :commands (benchmark-init/activate
             benchmark-init/deactivate
             benchmark-init/show-durations-tabulated
             benchmark-init/show-durations-tree))

;; General behavior.
(transient-mark-mode 1)

(setq diff-switches "-u"
      require-final-newline 'query
      inhibit-startup-message t
      ring-bell-function #'ignore
      use-short-answers t
      make-backup-files t
      version-control t
      delete-old-versions t
      kept-new-versions 10
      kept-old-versions 3
      backup-by-copying t
      create-lockfiles nil
      select-enable-clipboard t
      debug-on-error nil
      delete-by-moving-to-trash t
      frame-resize-pixelwise t
      fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      read-process-output-max (* 1024 1024)
      process-adaptive-read-buffering nil
      which-func-update-delay 1.0
      scroll-margin 1
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01
      auto-window-vscroll nil
      auto-revert-verbose nil
      global-auto-revert-non-file-buffers t
      recentf-max-saved-items 300
      recentf-auto-cleanup 'never
      history-length 200
      history-delete-duplicates t
      savehist-autosave-interval 300
      completion-ignore-case t
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      enable-recursive-minibuffers t
      help-window-select t
      show-paren-context-when-offscreen 'child-frame
      fill-column 80
      c-default-style "linux")

(setq-default c-basic-offset 2
              indent-tabs-mode nil
              tab-width 2
              truncate-lines t
              scroll-up-aggressively 0.01
              scroll-down-aggressively 0.01)

(let ((backup-dir (expand-file-name "backups/" my/emacs-dir))
      (autosave-dir (expand-file-name "auto-saves/" my/emacs-dir)))
  (make-directory backup-dir t)
  (make-directory autosave-dir t)
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,autosave-dir t))
        auto-save-list-file-prefix (expand-file-name ".saves-" autosave-dir)))

;; UI.
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))
(add-to-list 'default-frame-alist '(fullscreen . fullboth))

(load-theme 'wombat t)

(fset 'yes-or-no-p 'y-or-n-p)
(minibuffer-depth-indicate-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(repeat-mode 1)
(global-so-long-mode 1)

;; TAGS.
(setq tags-table-list '("~/enterprise/TAGS"))
(global-set-key (kbd "M-.") #'xref-find-definitions-other-window)

(use-package zoom-window
  :if (locate-library "zoom-window")
  :bind (("C-x C-z" . zoom-window-zoom)))

;; Mode line.
(use-package smart-mode-line
  :if (locate-library "smart-mode-line")
  :defer 0.05
  :config
  (setq sml/name-width 31
        sml/shorten-modes t
        rm-blacklist ""
        sml/theme nil
        sml/no-confirm-load-theme t)
  (display-time-mode 1)
  (sml/setup))

;; Sticky function at head.
(defun my/semantic-inhibit-makefile-p ()
  "Keep Semantic from synchronously parsing Makefiles."
  (derived-mode-p 'makefile-mode))

(use-package stickyfunc-enhance
  :ensure nil
  :if (locate-library "stickyfunc-enhance")
  :defer 0.5
  :config
  (add-hook 'semantic-inhibit-functions #'my/semantic-inhibit-makefile-p)
  (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
  (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
  (semantic-mode 1))

(autoload 'semantic-ia-show-summary "semantic/ia" nil t)
(global-set-key (kbd "C-c s") #'semantic-ia-show-summary)

;; Line numbers.
(global-set-key (kbd "M-g") #'goto-line)
(global-display-line-numbers-mode 1)

(dolist (hook '(term-mode-hook
                eshell-mode-hook
                shell-mode-hook
                vterm-mode-hook
                compilation-mode-hook
                help-mode-hook
                helpful-mode-hook
                dired-mode-hook
                org-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

;; Shell.
(add-hook 'comint-mode-hook #'ansi-color-for-comint-mode-on)

(with-eval-after-load 'comint
  (remove-hook 'comint-output-filter-functions
               #'comint-postoutput-scroll-to-bottom))

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
  :defer t
  :config
  (with-eval-after-load 'multiple-cursors
    (add-to-list 'mc/cursor-specific-vars 'iy-go-to-char-start-pos)))

(use-package zzz-to-char
  :if (locate-library "zzz-to-char")
  :bind (("M-z" . zzz-up-to-char)))

;; All code.
(add-hook 'prog-mode-hook #'follow-mode)
(add-hook 'prog-mode-hook #'subword-mode)
(add-hook 'prog-mode-hook #'hs-minor-mode)

(use-package rainbow-delimiters
  :if (locate-library "rainbow-delimiters")
  :hook (prog-mode . rainbow-delimiters-mode))

;; Fill column indicator.
(setq-default display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Dired.
(declare-function dired-hide-details-mode "dired-x")

(setq dired-guess-shell-alist-user
      `(( "\\.pdf\\'" ,(if (eq system-type 'darwin) "open" "xdg-open")))
      dired-recursive-copies 'always
      dired-recursive-deletes 'top
      dired-dwim-target t)

(add-hook 'dired-mode-hook #'dired-hide-details-mode)

(with-eval-after-load 'dired
  (require 'dired-x))

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
        helm-ff-file-name-history-use-recentf t
        helm-move-to-line-cycle-in-source t
        helm-scroll-amount 8
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
(defun my/transient-append-magit-gerrit-suffix (original prefix loc suffix
                                                         &rest args)
  "Map magit-gerrit's removed Magit dispatch anchor to its replacement."
  (when (and (eq prefix 'magit-dispatch)
             (equal loc "%")
             (eq (car (last suffix)) 'magit-gerrit-popup))
    (setq loc "!"))
  (apply original prefix loc suffix args))

(with-eval-after-load 'transient
  (advice-add 'transient-append-suffix :around
              #'my/transient-append-magit-gerrit-suffix))

(use-package magit
  :if (locate-library "magit")
  :functions (magit-display-buffer-same-window-except-diff-v1)
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-refresh-status-buffer nil
        magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; Org.
(add-hook 'org-mode-hook
          (lambda ()
            (setq truncate-lines nil)))

;; Jump to visible text.
(use-package avy
  :if (locate-library "avy")
  :bind (("M-j" . avy-goto-word-1))
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
  :defer 0.3
  :config
  (beacon-mode 1))

(use-package hl-todo
  :if (locate-library "hl-todo")
  :defer 0.4
  :config
  (global-hl-todo-mode 1))

;; Chinese font.
(use-package cnfonts
  :if (locate-library "cnfonts")
  :defer t)

;; Auto complete.
(electric-pair-mode 1)
(delete-selection-mode 1)

(use-package auto-complete
  :if (locate-library "auto-complete-config")
  :defer 0.2
  :config
  (require 'auto-complete-config)
  (ac-config-default)
  (setq ac-auto-start 2
        ac-delay 0.08
        ac-use-menu-map t
        ac-quick-help-delay 0.5)
  (setq-default ac-sources
                '(ac-source-yasnippet
                  ac-source-abbrev
                  ac-source-dictionary
                  ac-source-words-in-same-mode-buffers)))

;; Python helpers.
(use-package py-autopep8
  :if (locate-library "py-autopep8")
  :defer t)

(use-package cython-mode
  :if (locate-library "cython-mode")
  :defer t)

(use-package python-pytest
  :if (locate-library "python-pytest")
  :after python
  :bind (("C-t" . python-pytest-dispatch))
  :config
  (setq python-pytest-executable
        "sudo python3 -B -m pytest --pciaddr=0000:01:00.0 --show-capture=no")
  (when (fboundp 'transient-append-suffix)
    (transient-append-suffix
     'python-pytest-dispatch
     "-v"
     '("-z" "print debug logging" "--log-cli-level=debug"))))

;; Session management.
(defvar psession--save-buffers-alist)
(defvar psession--winconf-alist)
(defvar psession--last-winconf)
(defvar my/psession-command-line-file-p nil
  "Non-nil when startup already displayed a file from the command line.")
(defvar my/psession-command-line-buffers nil
  "File buffers created while processing startup command-line arguments.")
(defvar my/psession-requested-buffer nil
  "File buffer that command-line processing selected for display.")
(defvar my/psession-pending-buffers nil
  "Restored buffers whose normal major mode has not been initialized yet.")
(defvar my/psession-initialize-timer nil
  "Obsolete timer from an older restore implementation.")
(defvar my/psession-window-restore-timer nil)
(defvar my/psession-window-layout-handled-p nil)
(defvar my/psession-restoring-p nil)
(defvar my/psession-initializing-p nil)
(defvar-local my/psession-buffer-needs-initialization nil)

(declare-function psession--restore-some-buffers "psession")
(declare-function psession--restore-winconf-1 "psession")

(defun my/record-command-line-file-buffers (original args-left)
  "Call ORIGINAL with ARGS-LEFT and remember file buffers it creates."
  (let ((buffers-before (buffer-list)))
    (prog1 (funcall original args-left)
      (setq my/psession-command-line-buffers nil)
      (dolist (buffer (buffer-list))
        (when (and (not (memq buffer buffers-before))
                   (buffer-file-name buffer))
          (push buffer my/psession-command-line-buffers)))
      (when (buffer-file-name (current-buffer))
        (push (current-buffer) my/psession-command-line-buffers))
      (setq my/psession-requested-buffer
            (let ((displayed (window-buffer (selected-window))))
              (cond
               ((buffer-file-name displayed) displayed)
               ((buffer-file-name (current-buffer)) (current-buffer))
               (t (car my/psession-command-line-buffers)))))
      (setq my/psession-command-line-file-p
            (and my/psession-command-line-buffers t)))))

(unless after-init-time
  (advice-add 'command-line-1 :around #'my/record-command-line-file-buffers))

(defun my/startup-window-displays-file-p ()
  "Return non-nil when an initial window already displays a file."
  (catch 'found
    (dolist (window (window-list))
      (when (buffer-file-name (window-buffer window))
        (throw 'found t)))))

(defun my/psession-find-file-lazily (file)
  "Visit FILE with a lightweight mode, deferring its normal mode setup."
  (or (find-buffer-visiting file)
      (if (file-directory-p file)
          (find-file-noselect file 'nowarn)
        (let ((auto-mode-alist '((".*" . fundamental-mode)))
              (interpreter-mode-alist nil)
              (magic-mode-alist nil)
              (magic-fallback-mode-alist nil)
              (major-mode-remap-alist nil)
              (enable-local-variables nil)
              (enable-local-eval nil)
              (inhibit-local-variables-regexps '(".*"))
              (find-file-hook nil)
              (change-major-mode-after-body-hook nil)
              (after-change-major-mode-hook nil))
          (let ((buffer (find-file-noselect file 'nowarn)))
            (with-current-buffer buffer
              (setq my/psession-buffer-needs-initialization t))
            buffer)))))

(defun my/psession-initialize-buffer (buffer)
  "Finish normal mode and file-hook setup for restored BUFFER."
  (when (buffer-live-p buffer)
    (setq my/psession-pending-buffers
          (delq buffer my/psession-pending-buffers))
    (with-current-buffer buffer
      (when my/psession-buffer-needs-initialization
        (let ((point-position (point))
              (mark-position (and (mark t) (marker-position (mark-marker))))
              (modified-p (buffer-modified-p))
              (inhibit-redisplay t)
              (inhibit-message t)
              (my/psession-initializing-p t))
          (setq my/psession-buffer-needs-initialization nil)
          (normal-mode t)
          (run-hooks 'find-file-hook)
          (goto-char (min point-position (point-max)))
          (when mark-position
            (set-mark (min mark-position (point-max))))
          (set-buffer-modified-p modified-p))))))

(defun my/psession-initialize-current-buffer ()
  "Initialize a lazily restored buffer as soon as it is selected."
  (unless (or my/psession-restoring-p my/psession-initializing-p)
    (my/psession-initialize-buffer (current-buffer))))

(defun my/psession-initialize-visible-buffers (frame-or-window)
  "Initialize restored buffers visible in FRAME-OR-WINDOW."
  (unless (or my/psession-restoring-p my/psession-initializing-p)
    (let ((windows (if (windowp frame-or-window)
                       (list frame-or-window)
                     (window-list frame-or-window 'no-minibuffer))))
      (dolist (window windows)
        (my/psession-initialize-buffer (window-buffer window))))))

(when (timerp my/psession-initialize-timer)
  (cancel-timer my/psession-initialize-timer)
  (setq my/psession-initialize-timer nil))

(defun my/psession-show-requested-buffer ()
  "Keep the command-line requested buffer selected and visible."
  (when (buffer-live-p my/psession-requested-buffer)
    (let ((window (or (get-buffer-window my/psession-requested-buffer
                                          (selected-frame))
                      (selected-window))))
      (select-window window)
      (unless (eq (window-buffer window) my/psession-requested-buffer)
        (set-window-buffer window my/psession-requested-buffer))
      (set-buffer my/psession-requested-buffer))))

(defun my/psession-restore-buffers-fast ()
  "Restore saved buffers quickly and defer their expensive mode setup."
  (setq my/psession-command-line-file-p
        (or my/psession-command-line-file-p
            (my/startup-window-displays-file-p)))
  (when psession--save-buffers-alist
    (let ((start (current-time))
          (gc-cons-threshold most-positive-fixnum)
          (gc-cons-percentage 0.6)
          (inhibit-redisplay t)
          (inhibit-message t)
          (message-log-max nil)
          (large-file-warning-threshold nil)
          (my/psession-restoring-p t)
          (restored 0)
          pending
          failed)
      (dolist (entry (delete-dups (copy-sequence
                                   psession--save-buffers-alist)))
        (condition-case err
            (let ((file (car entry))
                  (position (cdr entry)))
              (when (file-exists-p file)
                (with-current-buffer (my/psession-find-file-lazily file)
                  (goto-char (min position (point-max)))
                  (push-mark (point) 'nomsg)
                  (when my/psession-buffer-needs-initialization
                    (push (current-buffer) pending)))
                (setq restored (1+ restored))))
          (error
           (push (format "%s: %s" (car entry) (error-message-string err))
                 failed))))
      (setq my/psession-pending-buffers (delete-dups (nreverse pending)))
      (let ((inhibit-message nil)
            (message-log-max t))
        (message "Psession restored %d buffers in %.2f seconds; %d modes deferred%s"
                 restored
                 (float-time (time-subtract (current-time) start))
                 (length my/psession-pending-buffers)
                 (if failed
                     (format "; %d failed (see *Messages*)" (length failed))
                   ""))
        (dolist (failure (nreverse failed))
          (message "Psession restore failed: %s" failure)))
      (run-with-idle-timer 1 nil #'garbage-collect))))

(defun my/psession-restore-window-layout-now ()
  "Restore the saved window layout if no requested file superseded it."
  (setq my/psession-window-restore-timer nil
        my/psession-window-layout-handled-p t)
  (when (and (not my/psession-command-line-file-p)
             (assoc-default psession--last-winconf psession--winconf-alist))
    (psession--restore-winconf-1 psession--last-winconf nil 'safe)
    (my/psession-initialize-visible-buffers (selected-frame))))

(defun my/psession-schedule-window-layout-restore ()
  "Schedule saved window layout restoration after command-line processing."
  (unless (or my/psession-command-line-file-p
              my/psession-window-layout-handled-p
              (timerp my/psession-window-restore-timer))
    (setq my/psession-window-restore-timer
          (run-with-idle-timer 0.05 nil
                               #'my/psession-restore-window-layout-now))))

(defun my/psession-restore-window-layout ()
  "Restore saved layout, while keeping requested files in front."
  (if my/psession-command-line-file-p
      (progn
        (setq my/psession-window-layout-handled-p t)
        (when (timerp my/psession-window-restore-timer)
          (cancel-timer my/psession-window-restore-timer)
          (setq my/psession-window-restore-timer nil))
        (my/psession-show-requested-buffer))
    (unless (daemonp)
      (my/psession-schedule-window-layout-restore))))

(defun my/psession-preserve-server-file ()
  "Prevent a pending saved layout from replacing a server-requested file."
  (when buffer-file-name
    (setq my/psession-command-line-file-p t
          my/psession-requested-buffer (current-buffer)
          my/psession-window-layout-handled-p t)
    (when (timerp my/psession-window-restore-timer)
      (cancel-timer my/psession-window-restore-timer)
      (setq my/psession-window-restore-timer nil))
    (my/psession-show-requested-buffer)))

(defun my/psession-server-frame-ready ()
  "Restore session layout in the first server frame without requested files."
  (my/psession-schedule-window-layout-restore))

(add-hook 'buffer-list-update-hook #'my/psession-initialize-current-buffer)
(add-hook 'window-buffer-change-functions
          #'my/psession-initialize-visible-buffers)

(with-eval-after-load 'server
  (add-hook 'server-visit-hook #'my/psession-preserve-server-file)
  (add-hook 'server-after-make-frame-hook #'my/psession-server-frame-ready))

(use-package psession
  :if (locate-library "psession")
  :init
  (setq psession-elisp-objects-default-directory
        (expand-file-name "elisp-objects/" my/emacs-dir))
  :config
  (psession-savehist-mode 1)
  (psession-mode 1)
  (remove-hook 'emacs-startup-hook #'psession--restore-some-buffers)
  (remove-hook 'emacs-startup-hook #'psession-restore-last-winconf)
  (add-hook 'emacs-startup-hook #'my/psession-restore-buffers-fast 'append)
  (add-hook 'emacs-startup-hook #'my/psession-restore-window-layout 'append))

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
