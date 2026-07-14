;;; init.el --- Minimal Emacs configuration
;;; Based on personal configuration + tsoding style ideas


;;; ============================
;;; Startup
;;; ============================

;; Initialize package system (loads installed packages)
(package-initialize)

;; Disable startup screen
(setq inhibit-startup-screen t)

;; Disable unnecessary UI
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)


;;; ============================
;;; Font & Theme
;;; ============================

;; Font
;; Change Iosevka to another installed font if needed
(set-face-attribute 'default nil
                    :family "FiraCode Nerd Font Mono"
                    :height 170)


;; Theme
(load-theme 'misterioso t)

;; Alternative:
;; (load-theme 'gruber-darker t)


;;; ============================
;;; Basic UI
;;; ============================

;; Show line number
(global-display-line-numbers-mode 1)

;; Highlight matching parentheses
(show-paren-mode 1)


;; Cursor
(set-cursor-color "#DAA520")
(setq-default cursor-type 'box)


;; Highlight current line
;; (global-hl-line-mode 1)



;;; ============================
;;; Editing behavior
;;; ============================

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Default indentation width
(setq-default tab-width 4)


;; Automatically insert matching brackets
(electric-pair-mode 1)


;; Delete trailing whitespace when saving
(add-hook 'before-save-hook
          'delete-trailing-whitespace)



;;; ============================
;;; Backup files
;;; ============================

;; Put backup files into a separate directory
(setq backup-directory-alist
      '(("." . "~/.emacs-backups/")))


;; Put auto-save files into a separate directory
(setq auto-save-file-name-transforms
      '((".*" "~/.emacs-autosaves/" t)))



;;; ============================
;;; Ido completion
;;; ============================

;; Built-in fuzzy file/buffer completion
(ido-mode 1)
(ido-everywhere 1)

(setq ido-enable-flex-matching t)

;; Better M-x command searching
(setq read-buffer-completion-ignore-case t)



;;; ============================
;;; Which-key
;;; ============================

;; Show available key bindings
;; Example:
;; Press C-x then wait
;; Emacs shows possible commands

(require 'which-key)

(which-key-mode 1)



;;; ============================
;;; Git
;;; ============================

;; Magit is the standard Emacs git interface
;;
;; Install:
;; M-x package-install RET magit RET

(require 'magit)

(global-set-key
 (kbd "C-x g")
 'magit-status)



;;; ============================
;;; Project management
;;; ============================

;; Built-in project support

(require 'project)

(global-set-key
 (kbd "C-c p f")
 'project-find-file)



;;; ============================
;;; Scrolling
;;; ============================

;; Better scrolling behavior

(setq scroll-margin 5)

(setq scroll-conservatively 101)



;;; ============================
;;; Programming modes
;;; ============================

;; C/C++ style
(setq-default c-basic-offset 4)


;; Enable line numbers in programming buffers
(add-hook 'prog-mode-hook
          (lambda ()
            (display-line-numbers-mode 1)))



;;; ============================
;;; Org mode
;;; ============================

;; Org files use visual line wrapping
(add-hook 'org-mode-hook
          (lambda ()
            (visual-line-mode 1)))



;;; ============================
;;; Final message
;;; ============================

(message "Emacs configuration loaded successfully")
