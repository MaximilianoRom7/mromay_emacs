(require 'realgud)

;; TODO
;; this variable is important to use venv-workon function
;; from the package virtualenvwrapper
(setq short-dir-1 "/home/skyline/Development")

(setq venv-location
      (list "~/.virtualenvs/"
	(concat short-dir-1 "/versions/repos/odoo.1")
	(concat short-dir-1 "/versions/repos/odoo.2")
	(concat short-dir-1 "/versions/repos/odoo.3")
	))

;; (message (nth 0 (filter-string "/repos/odoo10" venv-location)))
;; (sit-for 1)

(if (not (boundp 'local:virtualenv-choosen))
    (setq local:virtualenv-choosen nil))

;; TODO
;; does not choose by default the last option if none is given as the answer
(defun local:venv-run(pycommand)
  (if venv-location
      (progn
	(if local:virtualenv-choosen
	    (setq message (concat "Choose a Virtualenv: (" local:virtualenv-choosen ")"))
	  (setq message "Choose a Virtualenv: "))
	(setq local:venv-to-use (completing-read message venv-location))
	(if (not local:venv-to-use)
	    (if local:virtualenv-choosen
		;; use the last choosen virtualenv
		(setq local:venv-to-use t))
	  ;; else one was choosen
	  (setq local:virtualenv-choosen local:venv-to-use))
	)
    (message "There are no virtualenvs to use"))
  ;; test
  ;; (message (concat "Virtualenv Choosen was: " local:virtualenv-choosen))
  (funcall pycommand local:virtualenv-choosen)
  )

(defun local:concat-shell-run(&rest pipes)
  ;; (message (type-of pipes))
  (local:concat-shell pipes)
  ;; (setq command (local:concat-shell pipes))
  ;; (message (concat "Command: " command))
  (if command
      (progn
	;; (message command)
	;; (sit-for 2)
	(shell-command-to-string command))
    ""))
  
(defun local:concat-shell(&rest pipes)
  ;; (message (type-of pipes))
  (if (> (length pipes) 0)
      (progn
	(setq command (nth 0 (nth 0 pipes)))
	;; (setq command (concat command (nth 1 (nth 0 pipes))))
	;; (message (concat "Pipe: " command ))
	;; (sit-for 3)
	(cl-loop for pipe in (cdr (nth 0 pipes)) do
		 (setq command (concat command " | " pipe))
		 ;; (sit-for 0.3)
		 )
	command)
    ;; else return ""
    ""))

(defun local:venv-kill-odoo()
  (message
   (local:concat-shell-run 
    "lsof -i"
    "grep python"
    "grep LISTEN"
    "grep ':80'"
    "tr -s ' '"
    "cut -d ' ' -f2"
    "xargs -L1 kill -9")))

;; odoo relative path to the virtualenv
(setq odoo-relpath "/lib/python2.7/site-packages/odoo")
(setq local:odoo-version 8)

(defun local:venv-run-odoo-config(&optional virtualenv)
  ;; (message (concat "Virtualenv to run odoo is: " virtualenv))
  ;; (sit-for 0.3)
  (setq odoo-path (concat virtualenv odoo-relpath))
  ;; (message odoo-path)
  (if (eq local:odoo-version 8)
      (progn
	(setq command
	      (concat "python2 -c \""
		      "import odoo; "
		      "import sys; "
		      "sys.argv = ['', "
		      "'--config', '" odoo-relpath "/odoo/odoo-server.conf', "
		      "'--db-filter', 'odoo10']; "
		      "odoo.cli.main()\""))
	;; (message command)
	;; (sit-for 20)
	(realgud:pdb command t)
	)
  (realgud:pdb
   (concat "python2 -m pdb " odoo-path "/odoo.py "
	   "--config " odoo-path "/odoo-server.conf")))
  ;; (sit-for 0.3)
  )

(defun local:venv-run-odoo()
  (local:venv-kill-odoo)
  (local:venv-run 'local:venv-run-odoo-config))

;; (local:venv-run-odoo-config)
;; (local:venv-run-odoo)

;; test
(defun local:concat-shell-run-test()
  (message (concat "Command 1: " (local:concat-shell-run )))
  (sit-for 0.3)
  (message (concat "Command 2: "  (local:concat-shell-run "a" "v")))
  (sit-for 0.3)
  (message (concat "Command 3: "  (local:concat-shell-run "ls /root" "grep a")))
  (sit-for 0.3))

;; (local:concat-shell-run-test)

(defun append-cons(&rest linees)
  (setq out (nth 0 lines))
  (cl-loop for l in (cdr lines) do
	   (setq out (concat out " " l))
	   (message l)
	   (sit-for 0.4))
  out)

(defun test-args(&rest lines)
  (append-cons lines))

;; (message (local:concat-shell-run "a" "b" "c" "d"))
;; (message (local:concat-shell-run "ls /root" "grep a"))
;; (message (local:concat-shell "a" "b"))
;; (message (test-args "a" "b" "c"))

(provide 'python-mod)
