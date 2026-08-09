;;; init.el --- Emacs configuration
;;; Inspired by tsoding's setup

;;; Package archives
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

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
(setq inhibit-startup-screen t)
(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(column-number-mode 1)

;; Font
(set-face-attribute 'default nil
                    :family "FiraCode Nerd Font Mono"
                    :height 170)

;; Theme
(rc/package-ensure 'gruber-darker-theme)
(load-theme 'gruber-darker t)
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

;;; Backup files out of the way
(setq backup-directory-alist '(("." . "~/.emacs-backups/"))
      auto-save-file-name-transforms '((".*" "~/.emacs-autosaves/" t)))
(make-directory "~/.emacs-backups/" t)
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
