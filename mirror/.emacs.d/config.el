(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

(package-initialize)

(elcord-mode)

(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "C-x k") 'delete-window)

(setq-default indent-tabs-mode nil)
(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80))

(c-add-style "c-style"
             '("k&r"
               (indent-tabs-mode . f)
               (c-basic-offset . 4)))
(defun bi/c-hook ()
  (c-set-style "c-style")
  (auto-fill-mode))

(add-hook 'c-mode-hook 'bi/c-hook)

(defun bi/java-hook ()
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode nil))

;; Add the hook to java-mode
(add-hook 'java-mode-hook 'bi/java-hook)

(eval-after-load "haskell-mode"
  ;; i have no idea what this does really but its part of haskell-mode
  '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))

(use-package tex
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq latex-run-command "pdflatex"))

(defun bi/tex-compile-hack ()
  "Execute the build.sh script in a folder to compile a LaTeX project"
  "But this is horrible, seriously don't do this -- its only temporary"
  (interactive)

  ;; this would work without the push/popd but the issue is the tex file could be nested
  ;; and not able to get the build.sh fild path, there has to be a better way of doing it though
  (shell-command "pushd ~/Documents/haskell && bash build.sh && popd"))

(eval-after-load 'latex
  '(define-key LaTeX-mode-map (kbd "C-c C-k" 'bi/tex-compile)))
