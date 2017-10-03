(provide 'm-buffers)

(defun buffer-unblock-block(buffer-name function &optional args)
  "disable buffer read only if it is and executes the function
after execution makes buffer read only"
  (get-buffer-create buffer-name)
  (with-current-buffer buffer-name
    (if buffer-read-only (toggle-read-only))
    (apply function args)
    (if buffer-read-only nil (toggle-read-only))))

(defun loop-lines(lines func)
  (cl-loop for line in (split-string lines "\n") do
	   (funcall func line)))

(defun lines-insert-margin(lines &optional margin)
  (let ((margin (or margin "")))
    (loop-lines lines
		(lambda(line)
		  (insert (concat "\n" margin line))))))

(defun wmessage(message &optional margin)
  (let ((margin (or margin "MESSAGE: ")))
    (buffer-unblock-block
     "*Messages*"
     (lambda()
       (lines-insert-margin message margin)))))
