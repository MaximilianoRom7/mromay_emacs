
;; To let enter a space in minibuffer when calling read-buffer
;; (define-key minibuffer-local-completion-map "\M- "
;;   (lambda () (interactive) (insert " ")))

(defun search-in-all-buffers()
  (interactive)
  (let ((search-for (read-buffer "Search for ?  ")))
    (multi-occur-in-matching-buffers "" search-for)))

(provide 'search)
