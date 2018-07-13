(require 'core-spacemacs-buffer)

(setq buffer-default-output "*Messages*")

(defun read-only(active)
  (if active
      (if (not buffer-read-only)
	        (toggle-read-only))
    (if buffer-read-only
	      (toggle-read-only))))

(defun buffer-unblock(func &optional buffer-name args)
  "disable buffer read only if it is and executes the function
after execution makes buffer read only"
  (let ((args (or args nil))
	      (buffer-name (or buffer-name (current-buffer-name))))
    (get-buffer-create buffer-name)
    (with-current-buffer buffer-name
      (let ((read buffer-read-only))
	      (read-only nil)
	      (if args
	          (apply func args)
	        (funcall func))
	      (read-only read)))))

(defun loop-lines(lines func)
  (cl-loop for line in (split-string lines "\n") do
	         (funcall func line)))

(defun lines-insert-margin(lines &optional margin name-buffer)
  (let ((margin (or margin ""))
	      (name-buffer (or name-buffer buffer-default-output)))
    (loop-lines lines
		            (lambda(line)
		              (with-current-buffer name-buffer
		                (insert-unblock (concat "\n" margin line)))))))

(defun insert-unblock(content)
  (buffer-unblock (lambda() (insert content))))

(defun current-buffer-name()
  (buffer-name (current-buffer)))

(defun wmessage(message &optional margin)
  "Writes a message with a left margin
for example calling:

(wmessage \"Hi !\")

MESSAGE: Hi !

or

(wmessage \"Hi !\" \"MAX: \")

MAX: Hi !
"
  (let ((margin (or margin "MESSAGE: ")))
    (buffer-unblock
     (lambda()
       (lines-insert-margin message margin))
     buffer-default-output)))

;; (buffer-string)
;; (buffer-substring (point-min) (point-max))

(defun spacemacs-buffer-trailing-whitespace(&optional show)
  (with-current-buffer (get-buffer spacemacs-buffer-name)
    (setq show-trailing-whitespace show)))

(setq clean-whitespace
      #'(lambda ()
          (with-current-buffer (get-buffer spacemacs-buffer-name)
            (setq show-trailing-whitespace nil))
          (message "jajja")))

(defun spacemacs-buffer-hooks()
  (add-function
   :after
   #'(lambda ()
       (progn
         ;; (message "jojo")
         (sit-for 1)))
   #'spacemacs-buffer//startup-hook))

(defun --spacemacs-buffer-hooks()
  (add-function
   :after
   (progn
     (message "jojo")
     (sit-for 1)
     (run-at-time
      2 nil
      #'(lambda ()
          (with-current-buffer (get-buffer spacemacs-buffer-name)
            (setq show-trailing-whitespace nil))
          (message "jajja"))))
   #'spacemacs-buffer//startup-hook))

(defun buffer-content(&optional buffer)
  (let ((buffer (or buffer (current-buffer))))
    (with-current-buffer buffer
      (substring-no-properties (buffer-string)))))

(defun file-contents(path)
  "Given an absolute file path returns its content as a string"
  (with-temp-buffer
    (insert-file-contents path)
    (buffer-content)))

(defun file-contents-print(path &optional buffer-name)
  (let ((buffer-name (or buffer-name buffer-default-output)))
    (with-temp-buffer
      (let ((content (file-contents path))
	          (margin (concat path ": ")))
	      (lines-insert-margin content margin buffer-name)))))

(defun m:buffers-map-name()
  (let* ((buffers (buffer-list))
	       buffers-name)
    (cl-loop for buffer in buffers do
	           (setq buffers-name
		               (cons (list buffer (buffer-name buffer)) buffers-name)))
    buffers-name))

(defun m:buffers-ilike(str)
  (let* ((buffers-name (m:buffers-map-name)))
    (cl-remove-if-not
     (lambda(buffer-name)
       (if (string-match-p str (nth 1 buffer-name))
	         t
	       nil))
     buffers-name)
    ))

(defun buffers-name(buffer-name)
  (mapcar (lambda(buffer-name) (nth 1 buffer-name)) buffer-name))

(defun buffers-kill-ilike(str)
  (let* ((buffers-ilike (m:buffers-ilike str))
	       (buffer-name (buffers-name buffers-ilike)))
    (mapc 'kill-buffer buffer-name)))

(defun m:buffer-switch-create(buffer)
  (switch-to-buffer (get-buffer-create (car buffer))))

(defun m:buffer-kill(buffer)
  "Same as kill-buffer"
  (kill-buffer buffer))

(defun m:buffer-kill-noconfirm(buffer)
  "kill buffer without confirmation"
  (interactive)
  (with-current-buffer buffer
    (let ((buffer-modified-p nil))
      (kill-this-buffer))))

(defun m:buffer-kill-confirm(buffer &optional force)
  "Kill a buffer and ask confirmation or force kill without confirmation"
  (if force
      ;; do not ask
      (mapc #'m:buffer-kill-noconfirm buffer)
    ;; ask confirmation
    (mapc #'m:buffer-kill buffer)))

(defun m:buffer-name-contains(buffer name)
  (if (string-match name (buffer-name buffer))
      buffer))

(defun m:buffer-name-contains-(name)
  "Returns a lambda function that wraps m:buffer-name-contains
and replaces the name attribute for a constant
that means returns a predicate that can be used as a filter
where the name of the buffer is a constant"
  (lambda(buffer)
    (m:buffer-name-contains buffer name)))

(defun m:buffers-kill(buffers)
  "To a list of buffers applies m:buffer-kill"
  (m:buffers-do buffers #'m:buffer-kill))

(defun m:buffers-kill-noconfirm(buffers)
  "To a list of buffers applies m:buffer-kill-noconfirm"
  (m:buffers-do buffers #'m:buffer-kill-noconfirm))

(defun m:buffers-kill-confirm(buffers)
  "To a list of buffers applies m:buffer-kill-confirm"
  (m:buffers-do buffers #'m:buffer-kill-confirm))

(defun m:buffers-do(buffers func)
  (mapc func buffers))

(defun m:buffers-filter-name(buffers name)
  (remove-if-not
   (m:buffer-name-contains- name)
   buffers))

(defun m:buffers-filter-name-do(buffers name func)
  (m:buffers-do (m:buffers-filter-name buffers name) func))

(defun m:buffers-filter-name-kill(buffers name)
  (m:buffers-filter-name-do buffers name #'m:buffer-kill))

(defun m:buffers-list()
  (buffer-list))

(defun m:buffers-list-filter-name(name)
  (m:buffers-filter-name (m:buffers-list) name))

(defun m:buffer-by-name-do(name func)
  "Deprecated: applies a function over the NAME of a buffer instead of
appling the function to the buffer itself"
  (let ((buffers (filter-string name (mapcar #'buffer-name (buffer-list)))))
    (if buffers
	      (funcall func buffers))))

(defun m:buffer-kill-ilike(buffer-ilike &optional confirm)
  (interactive)
  (m:buffer-by-name-do buffer-ilike
                       (lambda(buffers)
			                   (m:buffer-kill-confirm buffers confirm))))

(defun m:buffer-kill-pdb(&optional confirm)
  "kill all the pdb buffers"
  (m:buffer-kill-ilike "pdb"))

(provide 'mromay-buffers)
