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

;;; PATH — a GUI Emacs inherits the desktop session's PATH, not the shell's,
;;; so language servers installed per-user are invisible without this.
(dolist (dir '("~/go/bin" "/usr/local/go/bin" "~/.cargo/bin" "~/.local/bin"))
  (let ((d (expand-file-name dir)))
    (when (file-directory-p d)
      (add-to-list 'exec-path d)
      (setenv "PATH" (concat d path-separator (getenv "PATH"))))))

;;; Tree-sitter — highlighting for languages Emacs ships no classic mode for.
;;; Grammars live in ~/.config/emacs/tree-sitter; install missing ones with
;;; M-x treesit-install-language-grammar.
(when (and (require 'treesit nil t) (treesit-available-p))
  (setq treesit-language-source-alist
        '((go         . ("https://github.com/tree-sitter/tree-sitter-go"))
          (gomod      . ("https://github.com/camdencheek/tree-sitter-go-mod"))
          (rust       . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
          (tsx        . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src"))))

  ;; Only claim a file extension when the grammar is actually built, so a
  ;; missing grammar degrades to fundamental-mode instead of erroring.
  (dolist (entry '(("\\.go\\'"     go         go-ts-mode)
                   ("/go\\.mod\\'" gomod      go-mod-ts-mode)
                   ("\\.rs\\'"     rust       rust-ts-mode)
                   ("\\.ts\\'"     typescript typescript-ts-mode)
                   ("\\.tsx\\'"    tsx        tsx-ts-mode)))
    (when (treesit-ready-p (nth 1 entry) t)
      (add-to-list 'auto-mode-alist (cons (nth 0 entry) (nth 2 entry))))))

;;; Editing — each language keeps its own convention; the defaults below
;;; only apply to modes that don't set their own (Python 4, Rust 4, ...).
(setq-default indent-tabs-mode nil
              tab-width 2
              c-basic-offset 2)

;; Go is the exception: gofmt indents with one real TAB per level.
;; go-ts-mode's offset is 8 columns while tab-width above is 2, which made
;; it emit *four* tabs per level — pin the two together so 1 level = 1 tab.
(defun rc/go-indent ()
  (setq-local indent-tabs-mode t
              tab-width 4
              go-ts-mode-indent-offset 4))
(add-hook 'go-ts-mode-hook #'rc/go-indent)
(add-hook 'go-mod-ts-mode-hook #'rc/go-indent)
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

;;; Completion — company pops up as you type, like VS Code.
;;; TAB cycles candidates, RET accepts the selected one.
(rc/package-ensure 'company)
(setq company-idle-delay 0.1
      company-minimum-prefix-length 1
      company-selection-wrap-around t
      company-tooltip-align-annotations t
      ;; Complete plain prose only on demand, not while writing text.
      company-dabbrev-downcase nil)
(global-company-mode 1)
(with-eval-after-load 'company
  (define-key company-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  (define-key company-active-map (kbd "TAB") #'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "RET") #'company-complete-selection)
  (define-key company-active-map [return] #'company-complete-selection))

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

;;; Dired — the stock header repeats the filesystem's free space ("available
;;; 70.0 GiB") in every directory, which says nothing about the directory you
;;; are in.  Drop it and show that directory's own size instead, computed with
;;; du in a subprocess so a huge tree never blocks Emacs.
(setq dired-free-space nil)

(defvar-local rc/dired-size nil
  "Human-readable size of this Dired buffer's directory, or nil.")

(defun rc/dired-header ()
  "Render the directory and its size in the header line."
  (setq-local header-line-format
              (concat " " (abbreviate-file-name default-directory)
                      (and rc/dired-size (concat "  —  " rc/dired-size)))))

(defun rc/dired-du ()
  "Measure `default-directory' with du, then refresh the header line."
  (when (and (derived-mode-p 'dired-mode)
             (not (file-remote-p default-directory))
             (file-directory-p default-directory))
    (setq rc/dired-size "…")
    (rc/dired-header)
    (let ((buf (current-buffer)))
      (make-process
       :name "dired-du" :noquery t
       :buffer (generate-new-buffer " *dired-du*")
       ;; 2>/dev/null: unreadable subdirectories are normal, not worth reporting
       :command (list "sh" "-c"
                      (format "du -sh %s 2>/dev/null"
                              (shell-quote-argument
                               (expand-file-name default-directory))))
       :sentinel
       (lambda (proc _event)
         (unless (process-live-p proc)
           (let ((out (with-current-buffer (process-buffer proc) (buffer-string))))
             (kill-buffer (process-buffer proc))
             (when (buffer-live-p buf)
               (with-current-buffer buf
                 (setq rc/dired-size
                       (if (string-match "\\`[ \t]*\\([^ \t\n]+\\)" out)
                           (match-string 1 out)
                         "?"))
                 (rc/dired-header))))))))))
(add-hook 'dired-after-readin-hook #'rc/dired-du)

;;; Org mode
(add-hook 'org-mode-hook #'visual-line-mode)

;;; Custom file (keep last — loads user customizations)
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

(message "Emacs loaded.")
