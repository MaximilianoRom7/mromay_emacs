;;
;; query related utilities
;;
(require 'mromay-buffers)


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


(defcustom m:sql-user-name
  (or user-login-name "postgres")
  "the postgresql user name to use to run the sql queries"
  :group 'mromay-sql
  :type 'string)

(defcustom m:sql-database-name
  "" ;; this variable must be set with 'M-x RET customize'
  "the postgresql data base name to use to run the sql queries"
  :group 'mromay-sql
  :type 'string)

(defcustom m:sql-output-buffer
  "*sql-query-output*"
  "the name of the buffer to insert the output of the queries"
  :group 'mromay-sql
  :type 'string)

(defcustom m:sql-simple-sep
  (concat (char-repeat "|" 140) "\n")
  "TODO make doc"
  :group 'mromay-sql
  :type 'string)

(defcustom m:sql-paragraph-sep
  (concat "\n\n" (char-repeat m:sql-simple-sep 2) "\n")
  "TODO make doc"
  :group 'mromay-sql
  :type 'string)

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
  (let ((buffer-name (or buffer-name m:sql-output-buffer))
	      (paragraphs (cl-remove-if-not
		                 'string-lines-any-char
		                 (buffer-split-paragraph)))
	      results)
    ;; (buffer-refresh-content paragraphs buffer-name m:sql-paragraph-sep)
    (set 'results (mapcar 'string-erase-tailing-newlines (mapcar 'sql-run-query paragraphs)))
    ;; (set 'results (mapcar 'sql-run-query paragraphs))
    (buffer-unblock buffer-name 'buffer-refresh-content (list results buffer-name m:sql-paragraph-sep))
    ;; (buffer-refresh-content results buffer-name m:sql-paragraph-sep)
    ))

(defun sql-command-run-query()
  (concat "psql -U " m:sql-user-name " " m:sql-database-name " -c "))

(defun sql-run-query(query)
  (shell-run
   (concat (sql-command-run-query) "\"" query "\"")))

(provide 'mromay-sql)
