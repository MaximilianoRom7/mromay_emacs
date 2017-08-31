(defun dired-hide-unuseful-files()
  (interactive)
  (require 'dired-x)
  (setq-default dired-omit-files-p t)
  (setq dired-omit-files "\\.pyc$"))

(dired-hide-unuseful-files)

;; truncate buffer at 1025 lines
;; as this variable indicates
;; comint-buffer-maximum-size

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


(setq-default message-log-max nil)

(kill-buffer "*Messages*")
