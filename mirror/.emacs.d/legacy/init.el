;;;
;;; bimorphism's emacs config
;;;

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))

;; Initialize MELPA
(package-initialize)

(load-file "~/.emacs.d/custom.el")

;; Discord integration (to flex on the mortal IDE/vscode users)
(elcord-mode)

;;(setq org-src-preserve-indentation t)

;; Keybindings
;; Define some global keybindings to make my life easier

;; Window management
;; C-x 2 - split below
;; C-x 3 - split right

(global-set-key (kbd "C-x k") 'delete-window)
(global-set-key (kbd "M-o") 'ace-window)

;; Use 4 spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80))

;; C/C++ specific stuff
(c-add-style "c-style"
	     '("k&r"
	       (indent-tabs-mode . f)
	       (c-basic-offset . 4)))

;; Load hooks
(load-file "~/.emacs.d/hooks.el")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes '(base16-horizon-dark))
 '(custom-safe-themes
   '("6145e62774a589c074a31a05dfa5efdf8789cf869104e905956f0cbd7eda9d0e" "96be1c5bb74fc2ffdfed87e46c87f1492969bf2af1fc96232e35c06b517aecc1" "59ba50f24540958f33699a5247255d10f34dd812f3975837e3eddccdc4caa32e" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "e0d42a58c84161a0744ceab595370cbe290949968ab62273aed6212df0ea94b4" "987b709680284a5858d5fe7e4e428463a20dfabe0a6f2a6146b3b8c7c529f08b" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "f956b10d80e774db159dadaf43429b334316f69becbd6037ee023833fb35e4bd" "c48551a5fb7b9fc019bf3f61ebf14cf7c9cdca79bcb2a4219195371c02268f11" default))
 '(elcord-mode t nil (elcord))
 '(linum-format " %5i ")
 '(package-selected-packages
   '(use-package auctex haskell-mode base16-theme inkpot-theme sublime-themes slime ace-window elcord))
 '(tab-width 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
