(provide 'm-python)

(defun py:paths()
  (shell-command-to-string
   (concat "python2 -c \"import sys; "
	   "from pprint import pprint; "
	   "[pprint(p) for p in sys.path]\"")))

(defun say:py:paths()
  (message (py:paths)))

(defun pdb-odoo-debug
  (realgud:pdb "pdb2 /home/skyline/Development/odoo/mera/odoo-8.0-20160428/odoo.py --config=/home/skyline/Development/odoo/mera/odoo-8.0-20160428/odoo-server-debug.conf" t))

(global-set-key
 (kbd "C-x C-n")
 (lambda ()
   (interactive)
   (kill-odoo)
   (condition-case nil
       (kill-buffer "*pdb odoo.py shell*")
     (error nil))
   (realgud:pdb "pdb2 /home/skyline/Development/odoo/mera/odoo-8.0-20170118/odoo.py --config=/home/skyline/Development/odoo/mera/odoo-8.0-20170118/odoo-server.conf" t)))


(global-set-key
 (kbd "C-x C-m")
 (lambda () (interactive)
   (kill-odoo)
   (sit-for 1)
   (condition-case nil
       (kill-buffer "*pdb odoo-bin shell*")
     (error nil))
   (switch-to-buffer "odoo-bin")
   (realgud:pdb
    (concat "python2 -m pdb "
	    "/usr/local/lib/python2.7"
	    "/dist-packages/odoo-10.0.post20170303-py2.7.egg"
	    "/odoo/odoo-bin --config="
	    "/usr/local/lib/python2.7"
	    "/dist-packages/odoo-10.0.post20170303-py2.7.egg"
	    "/odoo/odoo-server.conf --db-filter=odoo10-*") t)
   ))


(global-set-key
 (kbd "C-x C-m")
 (lambda () (interactive)
   (kill-odoo)
   (sit-for 1)
   (condition-case nil
       (kill-buffer "*pdb odoo-bin shell*")
     (error nil))
   (switch-to-buffer "odoo-bin")
   (realgud:pdb
    (concat "python2 -m pdb "
	    "/usr/local/lib/python2.7"
	    "/dist-packages/odoo-10.0.post20170303-py2.7.egg"
	    "/odoo/odoo-bin --config="
	    "/usr/local/loib/python2.7"
	    "/dist-packages/odoo-10.0.post20170303-py2.7.egg"
	    "/odoo/odoo-server.conf --db-filter=odoo10-*") t)
   ))

(global-set-key
 (kbd "C-x C-o")
 (lambda () (interactive)
   (kill-odoo)
   ;; (sit-for 1)
   (condition-case nil
       (kill-buffer "*pdb start_odoo.py shell*")
     (error nil))
   (setq working_dir "/home/skyline/Development/odoo/planet/odoo")
   (setq working_dir_2
	 (concat
	  "/home/skyline/Development"
	  "/odoo/versions/odoo-8.0-20161012"))
   (realgud:pdb
    (concat "python2 -m pdb " working_dir "/odoo.py "
	    "--config " working_dir "/odoo-server.conf") t)
   ))

