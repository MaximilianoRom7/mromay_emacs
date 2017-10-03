(provide 'm-docker)

(defun docker-open-dired()
  (interactive)
  (let* ((container_names
	  (split-string
	   (shell-command-to-string
	    "docker ps --format '{{.Names}}'") "\n"))
	 (container_choosen
	  (completing-read
	   "Choose a container name: " container_names))
	 (container_pid
	  (replace-regexp-in-string
	   "\n" ""
	   (shell-command-to-string
	    (concat 
	     "docker inspect --format {{.State.Pid}} " container_choosen))))
	 (container_folder (concat "/proc/" container_pid "/root")))
    (if (file-exists-p container_folder)
	(dired container_folder)
      (message (concat "Directory " container_folder " does not exist.")))))

