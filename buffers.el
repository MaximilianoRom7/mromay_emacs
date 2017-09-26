

(defun buffer-unblock-block(buffer-name function args)
  "disable buffer read only if it is and executes the function
after execution makes buffer read only"
  (get-buffer-create buffer-name)
  (with-current-buffer buffer-name
    (if buffer-read-only (toggle-read-only))
    (apply function args)
    (if buffer-read-only nil (toggle-read-only))
    ))

(defun wmessage(message)
  (buffer-unblock-block
   "*Messages*"
   (lambda()
     (cl-loop for line in (split-string message "\n") do
	      (message line)
	      (insert (concat "\nMESSAGE: " line))))
   nil))
