;;; early-init.el --- Early bird configuration

;; Run before frame is created — fullscreen is smooth here
(add-to-list 'default-frame-alist
             '(fullscreen . maximized))

(add-to-list 'default-frame-alist '(width . 100))
(add-to-list 'default-frame-alist '(height . 35))

;; Dark background before theme loads — prevents white flash
(add-to-list 'default-frame-alist '(background-color . "#2d3743"))
