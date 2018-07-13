(require 'mromay-utils)
(require 'mromay-buffers)
(require 'mromay-shell)
(require 'mromay-python)
(require 'mromay-python-mod)


(setq realgud-safe-mode nil)

(defun concat-home(path)
  "concats the user home directory with the path
for example:
if you want to use ~/odoo then you do
(concat-home '/odoo')"
  (concat (directory-file-name user-home-directory) path))

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

(defun buffer-switch-create(buffer)
  (switch-to-buffer (get-buffer-create (car buffer))))

(defun m:buffer-kill(buffer)
  "Same as kill-buffer"
  (kill-buffer buffer))

(defun m:buffer-kill-noconfirm(buffer)
  "kill buffer without confirmation"
  (interactive)
  (with-current-buffer buffer
    (let ((buffer-modified-p nil))
      (kill-this-buffer))))

(defun m:buffer-kill-confirm(buffer &optional force)
  "Kill a buffer and ask confirmation or force kill without confirmation"
  (if force
      ;; do not ask
      (mapc #'m:buffer-kill-noconfirm buffer)
    ;; ask confirmation
    (mapc #'m:buffer-kill buffer)))

(defun m:buffer-name-contains(buffer name)
  (if (string-match name (buffer-name buffer))
      buffer))

(defun m:buffer-name-contains-(name)
  "Returns a lambda function that wraps m:buffer-name-contains
and replaces the name attribute for a constant
that means returns a predicate that can be used as a filter
where the name of the buffer is a constant"
  (lambda(buffer)
    (m:buffer-name-contains buffer name)))

(defun m:buffers-kill(buffers)
  "To a list of buffers applies m:buffer-kill"
  (m:buffers-do buffers #'m:buffer-kill))

(defun m:buffers-kill-noconfirm(buffers)
  "To a list of buffers applies m:buffer-kill-noconfirm"
  (m:buffers-do buffers #'m:buffer-kill-noconfirm))

(defun m:buffers-kill-confirm(buffers)
  "To a list of buffers applies m:buffer-kill-confirm"
  (m:buffers-do buffers #'m:buffer-kill-confirm))

(defun m:buffers-do(buffers func)
  (mapc func buffers))

(defun m:buffers-filter-name(buffers name)
  (remove-if-not
   (m:buffer-name-contains- name)
   buffers))

(defun m:buffers-filter-name-do(buffers name func)
  (m:buffers-do (m:buffers-filter-name buffers name) func))

(defun m:buffers-filter-name-kill(buffers name)
  (m:buffers-filter-name-do buffers name #'m:buffer-kill))

(defun m:buffers-list()
  (buffer-list))

(defun m:buffers-list-filter-name(name)
  (m:buffers-filter-name (m:buffers-list) name))

(defun buffer-by-name-do(name func)
  "Deprecated: applies a function over the NAME of a buffer instead of
appling the function to the buffer itself"
  (let ((buffers (filter-string name (mapcar #'buffer-name (buffer-list)))))
    (if buffers
	      (funcall func buffers))))

(defun m:process-kill(process &optional confirm)

  (interactive)
  (buffer-by-name-do "pdb" (lambda(buffers)
			                       (m:buffer-kill-confirm buffers confirm)))
  )

(defun m:buffer-kill-pdb(&optional confirm)
  "kill all the pdb buffers"
  (m:process-kill "pdb"))

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

(defun directory-parent(dir)
  "returns the parent directory, example:
if called with /a/a/a/ => /a/a
or if called with /a/a/a  => /a/a"
  (directory-file-name
   (file-name-directory
    (directory-file-name dir))))

(defun local:odoo-start(&optional start_script)
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

(defun filter-empty-string(strings)
  ;; given a list of strings
  ;; retuns another list of not empty strings
  (-filter #'(lambda(x) (> (length x) 0)) strings))

(defun foreach-line-apply(func lines)
  (filter-empty-string
   (-flatten
    (mapcar
     #'(lambda(path)
	       (split-string (funcall func path) "\n"))
     lines))))

(defun odoo-find-start-script(odoo-root)
  (foreach-line-apply
   #'(lambda(path) (odoo-find-paths-cache path odoo-paths-cache-file))
   odoo-root))

(defun local:odoo-kill-start(&optional start_script)
  (interactive)
  (let ((odoo-paths (odoo-find-start-script odoo-root)))
    (kill-odoo)
    ;; don't know why but without delay does not work
    (sit-for 0.3)
    (local:odoo-start start_script)))

(defun template-odoo-tree()
  (interactive)
  (insert
   (concat
    "<!-- el campo id lo usas para referenciar esta vista -->\n"
    "        <record model=\"ir.ui.view\" id=\"...\">\n"
    "            <!-- el campo name es el string que aparece como -->\n"
    "            <!-- titulo de la vista cuando se abre -->\n"
    "            <field name=\"name\">...</field>\n"
    "            <!-- el campo model tiene que coincidir con la variable _name del model -->\n"
    "            <field name=\"model\">...</field>\n"
    "            <!-- dentro de arch va el cuerpo de la vista -->\n"
    "            <field name=\"arch\" type=\"xml\">\n"
    "                <tree string=\"...\">\n"
    "                    <field name=\"...\"/>\n"
    "                    <field name=\"...\"/>\n"
    "                    <field name=\"...\"/>\n"
    "                </tree>\n"
    "            </field>\n"
    "        </record>\n"
    )))

(defun template-odoo-form()
  (interactive)
  (insert
   (concat
    "<!-- el campo id lo usas para referenciar esta vista -->\n"
    "        <record model=\"ir.ui.view\" id=\"...\">\n"
    "            <!-- el campo name es el string que aparece como -->\n"
    "            <!-- titulo de la vista cuando se abre -->\n"
    "            <field name=\"name\">...</field>\n"
    "            <!-- el campo model tiene que coincidir con la variable _name del model -->\n"
    "            <field name=\"model\">...</field>\n"
    "            <!-- dentro de arch va el cuerpo de la vista -->\n"
    "            <field name=\"arch\" type=\"xml\">\n"
    "                <form string=\"...\">\n"
    "                    <group>\n"
    "                        <group>\n"
    "                            <field name=\"...\"/>\n"
    "                        </group>\n"
    "                        <group>\n"
    "                            <field name=\"...\"/>\n"
    "                        </group>\n"
    "                    </group>\n"
    "                </form>\n"
    "            </field>\n"
    "        </record>\n"
    )))

(defun template-odoo-action()
  (interactive)
  (insert
   (concat
    "<!-- el campo id de esta accion se usa en la propiedad action del menu -->\n"
    "        <record model=\"ir.actions.act_window\" id=\"act_afip_activity\">\n"
    "            <field name=\"name\">...</field>\n"
    "            <field name=\"res_model\">...</field>\n"
    "            <field name=\"type\">ir.actions.act_window</field>\n"
    "            <field name=\"view_type\">form</field>\n"
    "            <field name=\"view_mode\">tree,form</field>\n"
    "        </record>\n"
    )))

(defun start-odoo()
  (interactive)
  ;; ask confirmation to kill the buffer is the pdb process is still running
  (buffers-kill-ilike "pdb")
  ;; TODO change this kill process and kill only the pdb process knowing the pid
  (shell-concat-run
   "ps aux"
   "grep python"
   "grep odoo"
   "grep -v 'grep'"
   "tr -s ' '"
   "cut -d ' ' -f 2"
   "xargs -L 1 kill -9")
  (let* ((path-env      (concat-home     "/odoo/c10/1"))
         (path-odoo     (concat path-env "/odoo_10"))
         (path-python   (concat path-env "/bin/python "))
         (command  (concat path-python path-odoo "/start_odoo.py "
                           "--config=" path-odoo "/odoo-server.conf ")))
    (realgud:pdb command nil)))

(global-set-key (kbd "C-x t") 'template-odoo-tree)
(global-set-key (kbd "C-x r") 'template-odoo-form)
(global-set-key (kbd "C-x e")'template-odoo-action)
(global-set-key (kbd "C-c o") (local:wrapp 'local:odoo-kill-start '(t)))
;; (global-set-key (kbd "C-c o") 'start-odoo)

(provide 'mromay-odoo)
