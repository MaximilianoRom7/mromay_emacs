(provide 'm-buffers)

(setq buffer-default-output "*Messages*")

(defun read-only(active)
  (if active
      (if (not buffer-read-only)
	  (toggle-read-only))
    (if buffer-read-only
	(toggle-read-only))))

(defun buffer-unblock(func &optional buffer-name args)
  "disable buffer read only if it is and executes the function
after execution makes buffer read only"
  (let ((args (or args nil))
	(buffer-name (or buffer-name (current-buffer-name))))
    (get-buffer-create buffer-name)
    (with-current-buffer buffer-name
      (let ((read buffer-read-only))
	(read-only nil)
	(if args
	    (apply func args)
	  (funcall func))
	(read-only read)))))

(defun loop-lines(lines func)
  (cl-loop for line in (split-string lines "\n") do
	   (funcall func line)))

(defun lines-insert-margin(lines &optional margin buffer-name)
  (let ((margin (or margin ""))
	(buffer-name (or buffer-name buffer-default-output)))
    (loop-lines lines
		(lambda(line)
		  (with-current-buffer buffer-name
		    (insert-unblock (concat "\n" margin line)))))))

(defun insert-unblock(content)
  (buffer-unblock (lambda() (insert content))))

(defun current-buffer-name()
  (buffer-name (current-buffer)))

(defun wmessage(message &optional margin)
  (let ((margin (or margin "MESSAGE: ")))
    (buffer-unblock
     buffer-default-output
     (lambda()
       (lines-insert-margin message margin)))))

;; (buffer-string)
;; (buffer-substring (point-min) (point-max))

(defun buffer-content(&optional buffer)
  (let ((buffer (or buffer (current-buffer))))
    (with-current-buffer buffer
      (substring-no-properties (buffer-string)))))

(defun read-file(path &optional buffer-name)
  (let ((buffer-name (or buffer-name buffer-default-output)))
    (with-temp-buffer
      (insert-file-contents path)
      (lines-insert-margin (buffer-string) "FILE CONTENT: " buffer-name))))
