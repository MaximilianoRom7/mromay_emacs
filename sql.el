;; 
;; query related utilities
;; 


(defun buffer-plain-text()
  "Get the whole buffer text content without text properties"
  (interactive)
  (buffer-substring-no-properties (point-min) (point-max)))


(defun buffer-split-paragraph()
  "split the buffer content between 3 newline characters a 'paragraph'"
  (interactive)
  (let ((paragraphs (split-string (buffer-plain-text) "\n\n\n")))
    ;; (message (number-to-string (length paragraphs)))
    paragraphs))

(defun string-lines-any-char(lines)
  "returns t if any line of lines has at least one character '[a-z]'"
  (interactive)
  (let ((lines (if (consp lines)
		   lines
		 (if (stringp lines)
		     (split-string lines "\n")
		   (error "lines argument must be either a cons of strings or a string")))))
    (if (delq nil (mapcar #'(lambda(line) (string-match "[a-z]" line)) lines)) t nil)))

(defun char-repeat(char times)
  (let ((line ""))
    (dotimes (n times)
      (set 'line (concat line char)))
    line))

;; (let ((s 0) (line ""))
;;   (dotimes (n 4)
;;     (set 'line (concat line (number-to-string (set 's (1+ s)))))
;;     (message (number-to-string s)))
;;   line)

(setq
 sql-buffer "sql-query-output"
 sql-simple-sep (concat (char-repeat "|" 140) "\n")
 sql-paragraph-sep (concat "\n\n" (char-repeat sql-simple-sep 2) "\n")
 sql-user "odoo"
 sql-base "odoo")

(defun buffer-put-content(content buffer-name &optional paragraph-sep)
  "content has to be a cons that contains strings
which are going to be written into the new buffer called buffer-name
paragraph-sep is an optional separator to put between each paragraph"
  (let ((buffer (get-buffer-create buffer-name)))
    (with-current-buffer buffer
      (if paragraph-sep
	  (mapc #'(lambda(paragraph) (insert (concat paragraph paragraph-sep))) content)
	(mapc #'(lambda(paragraph) (insert paragraph)) content)))
    (switch-to-buffer-other-window buffer)))

(defun buffer-refresh-content(content buffer-name &optional paragraph-sep)
  "refresh the buffer content for a new one
uses buffer-put-content but first erases the buffer"
  (interactive)
  (with-current-buffer buffer-name
    (erase-buffer)
    (buffer-put-content content buffer-name paragraph-sep)))

(defun string-to-list-slow(lines)
  "disable better to use string-to-list"
  (butlast (cdr (split-string lines ""))))

(defun string-erase-tailing-newlines(lines)
  (let ((len (length lines))
	(newLines lines)
	(chars (string-to-list lines))
	(hasTrailing t)
	(n 0)
	pos)
    (while hasTrailing
      (set 'pos (- len (1+ n)))
      ;; (message (concat "Equal: " (nth pos chars)))
      ;; (sit-for 1)
      (if (equal (nth pos chars) "\n")
	    (set 'newLines (substring newLines 0 pos))
	(set 'hasTrailing nil))
      (set 'n (1+ n)))
    newLines))

(defun buffer-unblock-block(buffer-name function args)
  "disable buffer read only if it is and executes the function
after execution makes buffer read only"
  (get-buffer-create buffer-name)
  (with-current-buffer buffer-name
    (if buffer-read-only (toggle-read-only))
    (apply function args)
    (if buffer-read-only nil (toggle-read-only))
    ))

(defun window-dedicated-toggle()
  "when current window is dedicated to its buffer
then is not, and when is not, it is"
  (interactive)
  (let ((window (selected-window)))
    (set-window-dedicated-p window (not (window-dedicated-p window)))
    (message "toggled window dedicated")
    ))

(defun sql-run-buffer-paragraphs(&optional buffer-name)
  "split buffer into paragraphs and execute each as an sql query"
  (interactive)
  (let ((buffer-name (or buffer-name sql-buffer))
	(paragraphs (cl-remove-if-not
		     'string-lines-any-char
		     (buffer-split-paragraph)))
	results)
    ;; (buffer-refresh-content paragraphs buffer-name sql-paragraph-sep)
    (set 'results (mapcar 'string-erase-tailing-newlines (mapcar 'sql-run-query paragraphs)))
    ;; (set 'results (mapcar 'sql-run-query paragraphs))
    (buffer-unblock-block buffer-name 'buffer-refresh-content (list results buffer-name sql-paragraph-sep))
    ;; (buffer-refresh-content results buffer-name sql-paragraph-sep)
    
    ))

(defun sql-command-run-query()
  (concat "psql -U " sql-user " " sql-base " -c "))

(defun sql-run-query(query)
  (shell-command-to-string
   (concat (sql-command-run-query) "\"" query "\"")))



