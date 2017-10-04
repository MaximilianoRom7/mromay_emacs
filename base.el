(load "~/.emacs.d/home/import.el")

(setq load-path (append load-path (create-load-packages)))
(setq load-path (filter-files load-path))

(import 'utils)

(packages-install-require
 '(cl-lib
   ejc-sql
   helm
   helm-regexp
   helm-swoop
   helm-swoop
   magit
   neotree
   package
   realgud
   recentf
   windsize))


(global-set-key (kbd "C-c q") 'beginning-of-buffer)
(global-set-key (kbd "C-c a") 'end-of-buffer)

(global-set-key [f8] 'neotree-toggle)

(global-set-key (kbd "M-s M-i") '(lambda () (interactive) (multi-occur-in-matching-buffers)))

(global-set-key "\M-[1;5C"    'forward-word)
(global-set-key "\M-[1;5D"    'backward-word)

(windmove-default-keybindings)

(put 'set-goal-column 'disabled nil)


(add-to-list 'load-path "/root/.emacs.d/purcell/lisp")
(add-to-list 'load-path "/root/.emacs.d/purcell/site-lisp")

(ignore-errors
  (find-file "/home/skyline/Development/notes"))
