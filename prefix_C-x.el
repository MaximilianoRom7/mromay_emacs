

(defun goto-ansi-term()
  (interactive)
  (if (get-buffer "*ansi-term*")
      (switch-to-buffer "*ansi-term*")
    (ansi-term "/bin/bash")))

(global-set-key (kbd "C-x t") 'goto-ansi-term)
(global-set-key (kbd "C-x C-g") 'create-load-packages)
