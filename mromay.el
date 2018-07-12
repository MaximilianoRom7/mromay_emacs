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

(setq realgud-safe-mode nil)


(defun start-odoo()
  (interactive)
  (buffers-kill-ilike "pdb")
  (shell-command-to-string "ps aux | grep python | grep odoo | grep -v 'grep ' | while read l; do if [[ '$l' =~ '^[0-9]+$' ]]; then pid=$l; else pid=$(echo $l | process-pid); fi; kill -9 $pid; done")
  (sit-for 1)
  (setq default-directory "/home/mromay/odoo_10_community/2/odoo_10")
  (realgud:pdb "/usr/bin/python /home/mromay/odoo_10_community/2/odoo_10/start_odoo.py --config=/home/mromay/odoo_10_community/2/odoo_10/odoo-server.conf " nil))

(global-set-key (kbd "C-c o") 'start-odoo)

(provide 'mromay)
