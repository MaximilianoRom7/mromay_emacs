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

(provide 'mromay-files)
