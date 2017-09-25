(defun append-string-once(dir-list-append dir-list)
  ;; (setq copy-dir-list dir-list)
  (mapcar #'(lambda(dir)
              (if (not (string= dir ""))
                  (if (not (memq dir dir-list))
                      (add-to-list dir-list dir))))
          dir-list-append)
  ;; copy-dir-list
  )

 ;; (require 'windsize)

 ;; right-char                                                                                                    ;; left-char
 ;; next-line
 ;; previous-line
 ;; (setq resize-keys-lock nil)
 ;;
 ;; (defun toggle-resize-keys ()
 ;;   (if (not resize-keys-lock)
 ;;       (progn
 ;;         (setq resize-keys-lock t)
 ;;         (message "move resize bugger ENABLED")
 ;;         (global-set-key (kbd "<left>")  (lambda () (interactive) (windsize-left)))
 ;;         (global-set-key (kbd "<down>")  (lambda () (interactive) (windsize-down)))
 ;;         (global-set-key (kbd "<right>") (lambda () (interactive) (windsize-right)))
 ;;         (global-set-key (kbd "<up>")    (lambda () (interactive) (windsize-up)))
 ;;         )
 ;;     (progn
 ;;       (setq resize-keys-lock nil)
 ;;       (message "move resize bugger DISABLED")
 ;;       (global-set-key (kbd "<left>")  (lambda () (interactive) (left-char)))
 ;;       (global-set-key (kbd "<down>")  (lambda () (interactive) (next-line)))
 ;;       (global-set-key (kbd "<right>") (lambda () (interactive) (right-char)))
 ;;       (global-set-key (kbd "<up>")    (lambda () (interactive) (previous-line)))
 ;;       )))
 ;;
 ;;
 ;; (global-set-key (kbd "C-x j") (lambda () (interactive) (toggle-resize-keys)))

 ;; (global-set-key (kbd "<up>") (lambda () (interactive) (previous-line)))
 ;; (global-set-key (kbd "<up>") (lambda () (interactive) (message "aaa")))


 ;; (load-library "realgud")


;; pdb2 /home/skyline/Development/versions/odoo10/bin/start-odoo

 ;; (global-set-key (kbd "C-c <left>")  'windmove-left)
 ;; (global-set-key (kbd "C-c <right>") 'windmove-right)
 ;; (global-set-key (kbd "C-c <up>")    'windmove-up)
 ;; (global-set-key (kbd "C-c <down>")  'windmove-down)



 ;; (add-hook 'find-file-hook (lambda () (setq buffer-read-only t)))
