(require 'realgud)
(require 'mromay-utils)
(require 'mromay-buffers)
(require 'mromay-autoinstall)

(package-initialize)

;; (load "~/.emacs.d/home/import.el")
;; (import-all)

(setq load-path (append load-path (create-load-packages)))
(setq load-path (filter-files load-path))

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

(defun kill-buffer-noask()
  (interactive)
  (let ((buffer-modified-p nil))
    (kill-this-buffer)))

(add-hook 'dired-mode-hook
	  (lambda() (local-set-key
		     (kbd "k")
		     #'kill-buffer-noask)))

(global-set-key [f8] 'neotree-toggle)

(global-set-key (kbd "M-s M-i") '(lambda () (interactive) (multi-occur-in-matching-buffers)))

(global-set-key "\M-[1;5C"    'forward-word)
(global-set-key "\M-[1;5D"    'backward-word)

(windmove-default-keybindings)

(put 'set-goal-column 'disabled nil)


(add-to-list 'load-path "/root/.emacs.d/purcell/lisp")
(add-to-list 'load-path "/root/.emacs.d/purcell/site-lisp")


(run-at-time 2 nil (lambda() (find-file "~/mromay_emacs/sched/notes")))

(provide 'mromay)
