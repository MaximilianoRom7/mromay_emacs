;; a file intended for magit global key bindings

(define-prefix-command 'map-c-b)
(global-set-key (kbd "C-b") 'map-c-b)

(defun local--magit-current-branch()
  (setq output (shell-run "git branch | egrep \"* \" | cut -d ' ' -f2"))
  (substring output 0 (string-match "\n" output)))

(defun local--magit-update-branch()
  (setq local--current-branch (list (local--magit-current-branch))))

(defun local--magit-exec(magit-command)
  "exec command in current branch without asking for one"
  (local--magit-update-branch)
  (funcall magit-command local--current-branch))

(defun local--magit-log-current()
  (interactive)
  (local--magit-exec #'magit-log))

(defun local--magit-diff-current()
  (interactive)
  ;; there is an error becouse the #'magit-diff
  ;; expects a string and not a list like '("master")
  (local--magit-update-branch)
  ;; (local--magit-exec #'magit-diff)
  (magit-diff (nth 0 local--current-branch)))

(global-set-key
 (kbd "C-b l")
 'local--magit-log-current)

(global-set-key
 (kbd "C-b s")
 'magit-status)

(global-set-key
 (kbd "C-b d")
 'local--magit-diff-current)

(global-set-key
 (kbd "C-b c")
 'magit-commit)

(defun local--magit-add()
  "add and stage all files in the repository"
  (interactive)
  (setq command "git add . --all")
  (if (y-or-n-p (concat command "\n" "Are You Sure ?: "))
      (progn
	      (shell-run command)
	      (message "OK"))
    (message "Canceled")
    ))

(global-set-key
 (kbd "C-b a")
 'local--magit-add)

(provide 'mromay-prefix-c-b)
