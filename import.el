
(setq global-imports (and (boundp 'global-imports) global-imports))

(defun import-restart()
  (setq global-imports nil))

(defun import(path)
  (if (file-exists-p path)
      (if (not (member path global-imports))
	  (progn 
	    (push path global-imports)
	    (load path)
	    ))))
