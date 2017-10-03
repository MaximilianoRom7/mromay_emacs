(provide 'm-autoinstall)
(require 'm-buffers)

(wmessage "autoinstall")

(defun package-installed-loop(package-list func-if &optional func-else)
  (dolist (package package-list)
    (if (package-installed-p package)
	(funcall func-if package)
      (if func-else
	  (funcall func-else package)))))

(defun package-install(package-list)
  (package-installed-loop
   package-list
   (lambda(package)
      (ignore-errors
	(package-install package))
      (wmessage (concat "Package: " (symbol-name package) " installed")))))

(defun package-require(package-list)
  (dolist (package package-list)
    (require package)))

(defun package-install-require(package-list)
  (package-install package-list)
  (package-require package-list))
