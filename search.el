
(defun search-in-all-buffers()
  (interactive)
  (multi-occur-in-matching-buffers "" (read-buffer "Search for ?  ")))
