(require 'mromay-utils)
(require 'mromay-files)
(require 'mromay-buffers)
(require 'mromay-shell)
(require 'mromay-python)
(require 'mromay-python-mod)
(require 'mromay-odoo-templates)


(setq realgud-safe-mode nil)

(setq
 pkgs '("/lib/python2.7/site-packages")
 odoo-root (list (concat-home "/odoo"))
 odoo-paths-cache-file (concat-home "/mromay_emacs/mromay-odoo/mromay-odoo-paths")
 script-start-odoo (concat-home "/mromay_emacs/mromay-odoo/python/start_odoo.py"))

(defun message-wait(msg &optional wait)
  "Writes a message into the '*Message*' buffer
and waits n seconds optional"
  (wmessage msg)
  (let ((wait (or wait 1)))
    (sit-for wait)))

(defun kill-process-odoo()
  (shell-concat-run
   "lsof -i"
   "grep python"
   "grep LISTEN"
   "grep ':80'"
   "tr -s ' '"
   "cut -d ' ' -f2"
   "xargs -L 1 kill -9"))

(defun kill-process-pdb()
    (m:buffer-kill-pdb))

(defun kill-odoo()
  (interactive)
  (kill-process-odoo)
  (kill-process-pdb))

(defun m:odoo-start(&optional start_script)
  (interactive)
  (let* ((start_script (completing-read "Choose an odoo: " odoo-paths))
         (bin-python (concat (directory-parent start_script) "/bin/python"))
         (odoo-server (concat start_script "/odoo-server.conf"))
         (command (concat bin-python " "
                          script-start-odoo " "
                          "--config=" odoo-server)))
    (realgud:pdb command t)))

(defun odoo-find-paths(path &optional cache)
  (shell-concat-run
   (concat "find " path " -maxdepth 6 -type d -name addons")
   "xargs -L 1 dirname"
   (concat "while read l; "
	         "do ls $l/sql_db.py 1> /dev/null 2> /dev/null && echo $l; "
	         "done")
   "xargs -L 1 dirname"))

(defun odoo-find-paths-cache(path &optional cache)
  (if nil ;; cache
      (shell-run (concat "cat " cache))
    (let ((paths (odoo-find-paths path)))
      (if paths
	        (shell-concat-run
	         (concat "echo " paths)
           ;;(if cache
           ;;    (concat "tee -a " cache))
           )
	      ))))

(defun odoo-find-start-script(odoo-root)
  (foreach-line-apply
   #'(lambda(path) (odoo-find-paths-cache path odoo-paths-cache-file))
   odoo-root))

(defun m:odoo-kill-start(&optional start_script)
  (interactive)
  (let ((odoo-paths (odoo-find-start-script odoo-root)))
    (kill-odoo)
    ;; don't know why but without delay does not work
    (sit-for 0.3)
    (m:odoo-start start_script)))

(defun m:odoo-kill-process-all()
  "kills all the python proces, gets the pid with ps aux and grep"
  (shell-concat-run
   "ps aux"
   "grep python"
   "grep odoo"
   "grep -v 'grep'"
   "tr -s ' '"
   "cut -d ' ' -f 2"
   "xargs -L 1 kill -9"))

(defun m:odoo-start-old()
  (interactive)
  "deprecated function that starts odoo, use m:odoo-kill-start instead,
ask confirmation to kill the buffer is the pdb process is still running"
  (buffers-kill-ilike "pdb")
  ;; TODO change this kill process and kill only the pdb process knowing the pid
  (m:odoo-kill-process-all)
  (let* ((path-env      (concat-home     "/odoo/c10/1"))
         (path-odoo     (concat path-env "/odoo_10"))
         (path-python   (concat path-env "/bin/python "))
         (command  (concat path-python path-odoo "/start_odoo.py "
                           "--config=" path-odoo "/odoo-server.conf ")))
    (realgud:pdb command nil)))

(global-set-key (kbd "C-c o") (local:wrapp 'm:odoo-kill-start '(t)))
;; (global-set-key (kbd "C-c o") 'm:odoo-start)

(provide 'mromay-odoo)
