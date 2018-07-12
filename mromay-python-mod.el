(require 'realgud)
(provide 'mromay-shell)

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

(defun local:venv-kill-odoo()
  (message
   (shell-concat-run
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
  (setq odoo-path (concat virtualenv odoo-relpath))
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
  )

(defun local:venv-run-odoo()
  (local:venv-kill-odoo)
  (local:venv-run 'local:venv-run-odoo-config))

(defun append-cons(&rest linees)
  (setq out (nth 0 lines))
  (cl-loop for l in (cdr lines) do
	         (setq out (concat out " " l))
	         (message l)
	         (sit-for 0.4))
  out)

(defun test-args(&rest lines)
  (append-cons lines))

(provide 'mromay-python-mod)
