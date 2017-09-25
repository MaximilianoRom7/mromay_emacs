

(setq global-packages-dirs
      '("~/.emacs.d/elpa-25.2"))

(defun create-load-packages()
  "add to list load-path all the packages from elpa-25"
  (interactive)
  (cl-loop
   for path in global-packages-dirs do
   (setq packages-dirs (shell-command-to-string (concat "ls -d " path "/*/")))
   (mapcar #'(lambda(dir)
	       (if (not (string= dir ""))
		   (if (not (memq dir load-path))
		       (add-to-list 'load-path dir))))
	   (split-string packages-dirs "\n"))
   ))

(create-load-packages)

;; TODO UNDERSTAND EJC-SQL
(require 'ejc-sql)
(require 'helm)
(require 'helm-regexp)
(require 'magit)
(require 'realgud)
(require 'recentf)
(require 'neotree)
(require 'windsize)
(require 'helm-swoop)

(load "~/.emacs.d/home/vars.el")
(load "~/.emacs.d/home/utils.el")
(load "~/.emacs.d/home/window.el")
(load "~/.emacs.d/home/debug.el")
(load "~/.emacs.d/home/notes.el")
(load "~/.emacs.d/home/odoo.el")
(load "~/.emacs.d/home/sql.el")
(load "~/.emacs.d/home/python.el")
(load "~/.emacs.d/home/python_mod.el")
(load "~/.emacs.d/home/custom.el")
(load "~/.emacs.d/home/custom.el")
(load "~/.emacs.d/home/prefix_C-c.el")
(load "~/.emacs.d/home/prefix_C-f.el")
(load "~/.emacs.d/home/prefix_C-b.el")
(load "~/.emacs.d/home/prefix_C-x.el")
(load "~/.emacs.d/home/prefix_C-s.el")
(load "~/.emacs.d/home/docker.el")


(add-hook 'diff-mode-hook (lambda (&rest rest) (interactive) (setq truncate-lines t)))

(set-default 'truncate-lines t)

(global-auto-revert-mode t)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("marmalade" . "https://marmalade-repo.org/packages/")
	("melpa" . "https://melpa.org/packages/")))

(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2)
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))

(global-linum-mode 1)
(setq linum-format "%d   ")

(defun toggle-env-pdb-skip ()
  (interactive)
  (setq _LEVEL (read-from-minibuffer "PDB_LOCK level ?: "))
  (shell-command-to-string (concat "echo " _LEVEL " > /root/.pdb_lock"))
  (message (shell-command-to-string "cat /root/.pdb_lock")))

(global-set-key (kbd "C-x C-t") 'toggle-env-pdb-skip)


(recentf-mode 1)

(setq recentf-max-menu-items 25)
(global-set-key (kbd "C-x g") 'goto-line)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(global-set-key (kbd "C-c q") 'beginning-of-buffer)
(global-set-key (kbd "C-c a") 'end-of-buffer)

(global-set-key [f8] 'neotree-toggle)

(custom-set-faces
 '(neo-dir-link-face ((t (:foreground "magenta"))))
 '(neo-file-link-face ((t (:foreground "yellow")))))

(if (window-system)
    (custom-set-variables
       '(custom-enabled-themes (quote (manoj-dark))))
  ;; else
  (custom-set-variables
   '(package-selected-packages
     (quote
      (magit helm-swoop swoop windsize recentf-ext web-mode realgud neotree)))))

(global-set-key (kbd "M-s M-i") '(lambda () (interactive) (multi-occur-in-matching-buffers)))

(global-set-key "\M-[1;5C"    'forward-word)
(global-set-key "\M-[1;5D"    'backward-word)

(windmove-default-keybindings)

(put 'set-goal-column 'disabled nil)


(add-to-list 'load-path "/root/.emacs.d/purcell/lisp")
(add-to-list 'load-path "/root/.emacs.d/purcell/site-lisp")

(ignore-errors
  (find-file "/home/skyline/Development/notes"))