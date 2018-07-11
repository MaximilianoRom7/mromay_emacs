(require 'cl)

(defun list-files(dir)
  (subseq (directory-files dir) 2))

(defun list-files-ext(dir ext)
  (filter-string ext (list-files dir)))

(defun list-files-full(dir)
  (mapcar (lambda(file) (concat dir file)) (list-files dir)))

(defun list-files-full-ext(dir ext)
  (filter-string ext (list-files-full dir)))

(provide 'list)
