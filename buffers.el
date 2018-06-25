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

(defun buffers-map-name()
  (let* ((buffers (buffer-list))
	 buffers-name)
    (cl-loop for buffer in buffers do
	     (setq buffers-name
		   (cons (list buffer (buffer-name buffer)) buffers-name)))
    buffers-name))

(defun buffers-ilike(str)
  (let* ((buffers-name (buffers-map-name)))
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
  (let* ((buffers-ilike (buffers-ilike str))
	 (buffer-name (buffers-name buffers-ilike)))
    (mapc 'kill-buffer buffer-name)))
