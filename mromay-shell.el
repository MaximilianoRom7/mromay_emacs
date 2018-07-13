(defun shell-concat(&rest pipes)
  "concatenate the list of arguments to create a command in bash
also removes the nil values from the list before concatenating"
  (if pipes
      (let ((pipes (remove-if nil pipes)))
	      (setq command (car pipes))
	      (cl-loop for pipe in (cdr pipes) do
		             (setq command (concat command " | " pipe)))
	      command)
    ""))

(defun shell-run(command)
  (let ((shell-command-switch "-c"))
    (shell-command-to-string command)))

(defun shell-concat-run(&rest pipes)
  "form a bash command and run it"
  (setq command (apply #'shell-concat pipes))
  (if command
	    (shell-run command)
    ""))

(defun test-shell-concat-run()
  (message (concat "Command 1: " (shell-concat-run )))
  (sit-for 0.3)
  (message (concat "Command 2: "  (shell-concat-run "a" "v")))
  (sit-for 0.3)
  (message (concat "Command 3: "  (shell-concat-run "ls /root" "grep a")))
  (sit-for 0.3))

(provide 'mromay-shell)
