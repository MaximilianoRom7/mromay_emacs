(defun shell-concat(&rest pipes)
  "concatenate the arguments to create a command in bash"
  (if pipes
      (progn
	      (setq command (car pipes))
	      (cl-loop for pipe in (cdr pipes) do
		             (setq command (concat command " | " pipe)))
        (message command)
	      command)
    ""))

(defun shell-concat-run(&rest pipes)
  "form a bash command and run it"
  (setq command (apply #'shell-concat pipes))
  (if command
	    (shell-command-to-string command)
    ""))

(provide 'mromay-shell)
