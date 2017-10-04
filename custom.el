(require 'dired-x)

(setq dired-omit-files "\\.pyc$")
(setq shell-command-switch "-ic")

(setq-default dired-omit-files-p t)
(setq-default truncate-lines t)
(setq-default message-log-max nil)

(global-auto-revert-mode t)

(add-hook 'diff-mode-hook (lambda (&rest rest) (interactive) (setq truncate-lines t)))

;; truncate buffer at 1025 lines
;; as this variable indicates
;; comint-buffer-maximum-size

;; (setq comint-buffer-maximum-size 100)
;; (add-hook 'comint-output-filter-functions 'comint-truncate-buffer)
;; (remove-hook 'comint-output-filter-functions 'comint-truncate-buffer)

(custom-set-faces
 ;; other faces
 '(magit-diff-added ((((type tty)) (:foreground "green"))))
 '(magit-diff-added-highlight ((((type tty)) (:foreground "LimeGreen"))))
 '(magit-diff-context-highlight ((((type tty)) (:foreground "default"))))
 '(magit-diff-file-heading ((((type tty)) nil)))
 '(magit-diff-removed ((((type tty)) (:foreground "red"))))
 '(magit-diff-removed-highlight ((((type tty)) (:foreground "IndianRed"))))
 '(magit-section-highlight ((((type tty)) nil))))

(ignore-errors
  (kill-buffer "*Messages*"))
