(provide 'm-base)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
	("marmalade" . "https://marmalade-repo.org/packages/")
	("melpa" . "https://melpa.org/packages/")))


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

(load "~/.emacs.d/home/list.el")
(load "~/.emacs.d/home/buffers.el")
(load "~/.emacs.d/home/autoinstall.el")

(package-install-require
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

(package-require
 '(files))

(setq lib-root "~/.emacs.d/home/")

;; (load (concat lib-root "utils.el"))

(files-load-all-el lib-root)

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
