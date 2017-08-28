

(global-set-key (kbd "C-c d") 'edebug-defun)

(defun local:end-of-buffer(&rest rest)
  "to fix bug in realgud called after realgud:send-input"
  (interactive)
    (dolist (time (cons 0 (number-sequence 0.5 1.2 0.2)))
      (run-with-timer
       time nil `(lambda(&rest rest)
		   (with-current-buffer ,(current-buffer)
		     (end-of-buffer))
		   (message "end-of-buffer")
		   ))))

(advice-add 'realgud:send-input :after 'local:end-of-buffer)

