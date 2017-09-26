(defun package-autoinstall(package-list)
  (dolist (package package-list)
    (if (package-installed-p package)
	(wmessage (concat "Package: " (symbol-name package) " installed"))
      (ignore-errors
	(package-install package)))))

(package-autoinstall
 '(cl-lib
   ejc-sql
   helm
   magit
   realgud
   recentf
   neotree
   windsize
   helm-swoop))
