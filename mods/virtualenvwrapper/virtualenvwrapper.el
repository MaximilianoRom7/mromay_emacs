

;; overriding original function
(defun venv-get-candidates-dir (dir)
  "Given a directory DIR containing virtualenvs, return a list
of names that can be used in the completing read."
  (let ((proper-dir (file-name-as-directory (expand-file-name dir))))
    (-filter (lambda (s)
               (let ((subdir (concat proper-dir s)))
                 (car (file-attributes
                       (concat (file-name-as-directory subdir) venv-executables-dir)))))
             (directory-files proper-dir nil "^[^.]"))))


;; (nth 0 (split-string (shell-command-to-string "readlink ~/.virtualenvs/odoo_repos_10") "\n"))
