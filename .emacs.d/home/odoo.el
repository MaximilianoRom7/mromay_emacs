(defun python-debug(command)
    "command should be like
(python-debug \"pdb2 /home/skyline/Development/odoo_10/start.py\")"
    (let ((func 'realgud:run-debugger)
	  (args (list "pdb" 'pdb-query-cmdline
		      'pdb-parse-cmd-args
		      'realgud:pdb-minibuffer-history
		      command t))
	  no-error)
      (ignore-errors
	(apply func args)
	(set 'no-error t))
      (unless no-error
	;; the error happend most of the time
	;; becouse the buffer didn't close
	;; so executing the same function again
	;; closes the buffer and starts the
	;; debugger normally
	(message (format "%s" err))
	(sit-for 2)
	(apply func args))
      ))

(defun local:odoo-kill()
  (interactive)
  (local:concat-shell-run
   "lsof -i"
   "grep python"
   "grep LISTEN"
   "grep ':80'"
   "tr -s ' '"
   "cut -d ' ' -f2"
   "xargs -L 1 kill -9")
  (local:python-kill-pdb))

(defun local:buffer-kill-noconfirm(buff)
  "kill-buffer-without-confirmation"
  (interactive)
  (with-current-buffer buff
    (let ((buffer-modified-p nil))
      (kill-this-buffer))))

(defun local:python-kill-pdb(&optional confirm)
  "kill all the pdb buffers"
  (interactive)
  (let ((buffers (filter-string "pdb" (mapcar #'buffer-name (buffer-list)))))
    (if confirm
	;; ask confirmation
	(mapc #'kill-buffer buffers)
      ;; do not ask
      (mapc #'local:buffer-kill-noconfirm buffers))))

(defun local:odoo-start(&optional start_script)
  (interactive)
  (let ((buff (filter-string "pdb" (mapcar #'buffer-name (buffer-list)))))
    (if buff
	;; pdb is running
	(progn
	  (switch-to-buffer (get-buffer-create (car buff)))
	  ))
    (if start_script
	(progn
	  (unless (stringp start_script)
	    (setq start_script (completing-read "Choose an odoo: " odoo-paths)))
	  (cd (file-name-directory start_script))
	  (realgud:pdb
	   (concat "python2 -m pdb " start_script " --config=odoo-server.conf") t))
      ;; else
      (realgud:pdb
       (concat "python2 -m pdb odoo.py --config=odoo-server.conf") t))
    ))

;; odoo paths
;; /home/skyline/Development/versions/repos/odoo10/lib/python2.7/site-packages/odoo/odoo

(defun local:odoo-kill-start(&optional start_script)
  (interactive)
  (setq odoo-paths (odoo-find-start-script odoo-root))
  (local:odoo-kill)
  ;; don't know why but without delay does not work
  (sit-for 0.3)
  (local:odoo-start start_script))

(defun odoo-find-script-command(path)
  (shell-command-to-string
   (concat "find " path " -maxdepth 6 -type f -name start_odoo.py")))

(defun filter-empty-string(strings)
  ;; given a list of strings
  ;; retuns another list of not empty strings
  (-filter #'(lambda(x) (> (length x) 0)) strings))

(defun odoo-find-start-script(odoo-root)
  (filter-empty-string
   (-flatten 
    (mapcar
     #'(lambda(path)
	 (split-string (odoo-find-script-command path) "\n"))
     odoo-root))))


(setq
 pkgs '("/lib/python2.7/site-packages")
 odoo-root '("/home/skyline/Development"))

(global-set-key (kbd "C-c o") (local:wrapp 'local:odoo-kill-start '(t)))
