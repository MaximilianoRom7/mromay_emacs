;; commands related to take notes

(defun write-full-date()
  (interactive)
  (insert (concat "\n\n" (shell-run "date") "\n")))

(global-set-key (kbd "C-c t") 'write-full-date)

(provide 'mromay-notes)
