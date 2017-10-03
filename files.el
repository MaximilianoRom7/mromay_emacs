(require 'm-utils)

(defun files-load-all-el(path)
  (let ((files (filter-not-string "base.el" (list-files-ext path ".el$"))))
    (cl-loop for file in files do
	     (let ((full (concat path file)))
	       (wmessage (concat "Loading file: " full))
	       (load full)
	       ))))
