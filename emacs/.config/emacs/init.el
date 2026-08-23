;;; init.el --- Emacs configuration  -*- lexical-binding: t -*-
;;; Inspired by tsoding's setup

;;; Package archives — Tsinghua mirror
(require 'package)
(setq package-archives
      '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(defvar rc/pkg-refreshed nil)
(defun rc/package-ensure (pkg)
  "Install PKG from ELPA if not already installed."
  (unless (package-installed-p pkg)
    (unless rc/pkg-refreshed
      (setq rc/pkg-refreshed t)
      (package-refresh-contents))
    (package-install pkg)))

;;; UI
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-screen t
      use-short-answers t)
(show-paren-mode 1)
(column-number-mode 1)

;; Line numbers only where they help — not in magit/dired/shell buffers
(setq display-line-numbers-type 'relative)
(dolist (hook '(prog-mode-hook text-mode-hook conf-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; Font
(set-face-attribute 'default nil
                    :family "FiraCode Nerd Font Mono"
                    :height 170)

;; Theme — gruber-darker predates Emacs 30, which wants `unspecified' rather
;; than nil for "no color"; its nils make every new frame warn.  Load the
;; theme without enabling it, rewrite the nils at the source, then enable.
(defun rc/unspecify-nil-face-attrs (theme)
  "Replace nil face attribute values in THEME's specs with `unspecified'."
  (dolist (setting (get theme 'theme-settings))
    (when (eq (car setting) 'theme-face)
      (dolist (display (nth 3 setting))
        (let ((attrs (if (keywordp (cadr display)) (cdr display) (cadr display))))
          (while (cdr attrs)
            (unless (cadr attrs) (setcar (cdr attrs) 'unspecified))
            (setq attrs (cddr attrs))))))))

(rc/package-ensure 'gruber-darker-theme)
(load-theme 'gruber-darker t t)
(rc/unspecify-nil-face-attrs 'gruber-darker)
(enable-theme 'gruber-darker)
(set-face-attribute 'line-number nil :inherit 'default)

;; Cursor
(set-cursor-color "#DAA520")
(setq-default cursor-type 'box)

;;; Editing
(setq-default indent-tabs-mode nil
              tab-width 2
              c-basic-offset 2)
(electric-pair-mode 1)
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(setq scroll-margin 5
      scroll-conservatively 101)

;;; No backup files; auto-saves out of the way
(setq make-backup-files nil
      auto-save-file-name-transforms '((".*" "~/.emacs-autosaves/" t)))
(make-directory "~/.emacs-autosaves/" t)

;;; Ido — fuzzy completion
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t
      read-buffer-completion-ignore-case t)

;;; Shell — prevent starship from garbling comint output
(advice-add 'shell :around
            (lambda (fn &rest args)
              (let ((process-environment
                     (cons "TERM=dumb" process-environment)))
                (apply fn args))))

;;; Compile
(setq compilation-scroll-output t)

;;; Completion — company, TAB to indent or complete
(rc/package-ensure 'company)
(setq company-idle-delay 0.2
      company-minimum-prefix-length 2)
(global-company-mode 1)
(with-eval-after-load 'company
  (define-key company-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  (define-key company-active-map (kbd "TAB") #'company-complete-common-or-cycle))

;;; Eglot — start a language server only when one is actually installed,
;;; so languages without a server just fall back to plain company.
(defvar rc/lsp-servers
  '((python-mode . "pyright-langserver") (python-ts-mode . "pyright-langserver")
    (c-mode . "clangd")   (c++-mode . "clangd")
    (c-ts-mode . "clangd") (c++-ts-mode . "clangd")
    (go-ts-mode . "gopls")
    (rust-mode . "rust-analyzer") (rust-ts-mode . "rust-analyzer"))
  "Major mode -> language server executable.")

(defun rc/eglot-maybe ()
  "Start eglot if this buffer's language server is on PATH."
  (let ((exe (alist-get major-mode rc/lsp-servers)))
    (when (and exe (executable-find exe))
      (eglot-ensure))))
(add-hook 'prog-mode-hook #'rc/eglot-maybe)

;;; which-key — show available keybindings on pause
(rc/package-ensure 'which-key)
(which-key-mode 1)

;;; Magit
(rc/package-ensure 'magit)
(global-set-key (kbd "C-x g") #'magit-status)

;;; Project
(global-set-key (kbd "C-c p f") #'project-find-file)

;;; Org mode
(add-hook 'org-mode-hook #'visual-line-mode)

;;; Custom file (keep last — loads user customizations)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

(message "Emacs loaded.")
