;; Language mode hooks

(require 'tex)
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq latex-run-command "pdflatex")

;; Hook to hopefully fix some indentation issues by rebinding RET and <C-return>
;; when in c-mode/java-mode/etc.
(defun bi/c-style-indent-hook ()
  (local-set-key (kbd "RET") (key-binding (kbd "M-j")))
  (local-set-key (kbd "<C-return>") #'electric-indent-just-newline))

(defun bi/c-hook ()
  (c-set-style "c-style")
  (auto-fill-mode)
  (c-toggle-auto-hungry-state 1))

(defun bi/java-hook ()
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode nil))

(defun bi/tex-compile ()
  "Compile the Latex project based on running build.sh in the current project directory"
  "This is a hacky way but it works so long as build.sh is present"
  (interactive)

  ;; This is horrible and temporary but it *should* work for now
  ;; A better would be asking what file to use to build it and the path and storing it at runtime
  ;; *or* if possible automatically traverse up the directory tree and find the build.sh file.
  (shell-command "pushd ~/Documents/haskell && bash build.sh && popd"))

;; C, C++, Java
(add-hook 'c-mode-hook 'bi/c-hook)
(add-hook 'c++-mode-hook 'bi/c-hook)
(add-hook 'java-mode-hook 'bi/java-hook)

;; Common Lisp
(load (expand-file-name "~/.quicklisp/slime-helper.el"))
(setq inferior-lisp-program "sbcl")

;; Haskell
(eval-after-load "haskell-mode"
  '(define-key haskell-mode-map (kbd "C-c C-c") 'haskell-compile))

(eval-after-load 'latex
  ;; hacky "compile all" key
  '(define-key LaTeX-mode-map (kbd "C-c C-k") 'bi/tex-compile))
