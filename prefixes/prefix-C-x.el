(defun goto-ansi-term()
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/bash")))

(global-set-key (kbd "C-x t") 'goto-ansi-term)
(global-set-key (kbd "C-x C-g") 'create-load-packages)
(global-set-key (kbd "C-x C-t") 'toggle-env-pdb-skip)
(global-set-key (kbd "C-x g") 'goto-line)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(provide 'prefix-C-x)
