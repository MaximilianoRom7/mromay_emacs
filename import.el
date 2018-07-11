(require 'buffers)
(require 'list)

(setq global-imports (and (boundp 'global-imports) global-imports))
(setq lib-root "~/.emacs.d/home/")

(defun import-restart()
  (setq global-imports nil))

(defun import(path)
  (let ((path (or (and
		   (symbolp path)
		   (concat lib-root (symbol-name path) ".el"))
		  path)))
    (if (file-exists-p path)
	(if (not (member path global-imports))
	    (progn
	      (push path global-imports)
	      (load path))))))

(defun import-all()
  (let ((files (list-files-full-ext lib-root ".el$")))
    (cl-loop for file in files do
	     (wmessage file "IMPORTING: ")
	     (import file)
	     )))
