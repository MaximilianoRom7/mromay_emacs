(require 'mromay-utils)
(require 'mromay-buffers)

(defun directory-or-parent(dir &optional recursive_level)
  "Given a path if it is a directory returns it
if it is a file return parent directory
if the parent directory is not a real directory return nil"
  (let ((recursive_level (or recursive_level 3))
	(dir (directory-file-name dir)))
    (wmessage (concat (number-to-string recursive_level) " " dir) "LEVEL: ")
    (if (> recursive_level 0)
	(if (file-directory-p dir)
	    dir
	  (directory-or-parent
	   (file-name-directory dir)
	   (1- recursive_level))))))

(defun files-load-all-el(path)
  (let ((files (filter-not-string "base.el" (list-files-ext path ".el$"))))
    (cl-loop for file in files do
	     (let ((full (concat path file)))
	       (wmessage (concat "Loading file: " full))
	       (load full)
	       ))))

(defun directory-parent(dir)
  "returns the parent directory, example:
if called with /a/a/a/ => /a/a
or if called with /a/a/a  => /a/a"
  (directory-file-name
   (file-name-directory
    (directory-file-name dir))))

(defun concat-home(path)
  "concats the user home directory with the path
for example:
if you want to use ~/odoo then you do
(concat-home '/odoo')"
  (concat (directory-file-name user-home-directory) path))

(provide 'mromay-files)
