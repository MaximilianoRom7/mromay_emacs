;;
;; window related key bindings
;;
(global-set-key (kbd "C-x 4") 'neotree-toggle)
(global-set-key (kbd "C-c <left>") 'windsize-left)
(global-set-key (kbd "C-c <right>") 'windsize-right)
(global-set-key (kbd "C-c <up>") 'windsize-up)
(global-set-key (kbd "C-c <down>") 'windsize-down)

;; delete the function "delete buffer with running process ?"
(let* ((func 'process-kill-buffer-query-function)
       (funcs kill-buffer-query-functions))
  (if (memq func funcs)
      (setq kill-buffer-query-functions (delq func funcs))))


(defun window:data()
  (mapcar #'(lambda(w) (list w (window-width w) (window-height w))) (window-list)))

(defun local:window-horizontal(w size)
  "w is a window object"
  (window-resize w size t))

(defun local:window-vertical(w size)
  "w is a window object"
  (window-resize w size))


;; move always in clock direction left-up-right-down

(global-set-key (kbd "M-1") 'local:windmove-left)
(global-set-key (kbd "M-2") 'local:windmove-up)
(global-set-key (kbd "M-3") 'local:windmove-right)
(global-set-key (kbd "M-4") 'local:windmove-down)

(global-set-key (kbd "C-x M-1") 'local:windmove-left)
(global-set-key (kbd "C-x M-2") 'local:windmove-right)

(defun local:windmove-left()
  (interactive)
  (condition-case err
      (windmove-left)
    (error (windmove-up))))

(defun local:windmove-up()
  (interactive)
  (condition-case err
      (windmove-up)
    (error (windmove-right))))

(defun local:windmove-right()
  (interactive)
  (condition-case err
      (windmove-right)
    (error (windmove-down))))

(defun local:windmove-down()
  (interactive)
  (condition-case err
      (windmove-down)
    (error (windmove-left))))

(provide 'window)
