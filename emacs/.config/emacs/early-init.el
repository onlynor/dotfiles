;;; early-init.el --- Early bird configuration

;; Run before frame is created — fullscreen is smooth here
(add-to-list 'default-frame-alist
             '(fullscreen . maximized))

(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(height . 35))

;; Dark background before theme loads — prevents white flash
;; Match gruber-darker default bg to avoid flicker
(add-to-list 'default-frame-alist '(background-color . "#1a1a1a"))
