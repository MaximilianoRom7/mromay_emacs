(require 'mromay-packages)

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

(defun toggle-env-pdb-skip ()
  (interactive)
  (setq _LEVEL (read-from-minibuffer "PDB_LOCK level ?: "))
  (shell-run (concat "echo " _LEVEL " > /root/.pdb_lock"))
  (message (shell-run "cat /root/.pdb_lock")))

(defun create-load-packages()
  "add to list load-path all the packages from elpa-25"
  (interactive)
  (let (load-path-copy)
    (cl-loop
     for path in global-packages-dirs do
     (if (file-exists-p path)
	 (let* ((command (concat "ls -d " path "/*/"))
		(packages-dirs (shell-run command)))
	   (mapcar #'(lambda(dir)
		       (if (not (string= dir ""))
			   (if (file-exists-p dir)
			       (if (not (memq dir load-path-copy))
				   (add-to-list 'load-path-copy dir)))))
		   (split-string packages-dirs "\n")))))
    load-path-copy))

(defun filter-files(paths)
  (cl-remove-if-not #'file-exists-p paths))

(defun string-split-concat(chars split1 &optional split2)
  (let ((split2 (if split2 split2 ", ")))
    (mapconcat 'identity (mapcar 'string-trim (split-string chars split1)) split2)))

(defun test-string-split-concat()
  (let ((cols " id  |        create_date         |         write_date         | write_uid"))
    (message (string-split-concat cols "|" ", "))
    ))

(defun string-trim (string)
  "Remove white spaces in beginning and ending of STRING.
White space here is any of: space, tab, emacs newline (line feed, ASCII 10)."
(replace-regexp-in-string "\\`[ \t\n]*" "" (replace-regexp-in-string "[ \t\n]*\\'" "" string)))

(defun filter-string(str list)
  "from a list of strings return a list with the ones that contain the str"
  (delq nil (mapcar #'(lambda(p) (if (string-match str p) p)) list)))

(defun filter-not-string(str list)
  "from a list of strings return a list with the ones that DO NOT contain the str"
  (delq nil (mapcar #'(lambda(p) (if (string-match str p) nil p)) list)))

(defun local:wrapp(func &rest args)
  "this function retuns a lambda that calls the original func"
  (interactive)
  `(lambda (&rest ignore)
     (interactive)
     (apply ',func ',@args)))

(defun local:keys-get-functions(map)
  (dolist (el map)
    (ignore-errors
      (let ((f (cdr el)))
	(if (fboundp f)
	    (message (format "%S" f))
	  )))))

(defun local:keymap-walk-recursive(list &optional funcs)
  ;; (if (consp list)
  (dolist (l list)
    (if (consp l)
	(let ((c (cdr l)))
	  (if (consp c)
	      (if (set 'local (local:walk-recursive c))
		  (if funcs
		      (set 'funcs `(,@funcs ,@local))
		    (set 'funcs local))
		)
	    ;; else
	    (if (fboundp c)
		(set 'funcs (cons l funcs)))
	    )))
    )
  funcs)

;; testing
;; (local:keys-get-functions edebug-mode-map)

(provide 'mromay-utils)
