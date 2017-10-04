(wmessage "autoinstall")

(defun packages-installed-loop(package-list func-if &optional func-else)
  (dolist (package package-list)
    (if (package-installed-p package)
	(funcall func-if package)
      (if func-else
	  (funcall func-else package)))))

(defun packages-install(package-list)
  (packages-installed-loop
   package-list
   (lambda(package)
      (ignore-errors
	(package-install package)
	(wmessage (concat (symbol-name package) " installed") "PACKAGE: "))))
  (wmessage "" ""))

(defun packages-require(package-list)
  (dolist (package package-list)
    (require package)
    (wmessage (symbol-name package) "REQUIRE: "))
  (wmessage "" ""))

(defun packages-load(package-list)
  (dolist (package package-list)
    (load package)
    (wmessage package "LOADING: "))
  (wmessage "" ""))

(defun packages-install-require(package-list)
  (packages-install package-list)
  (packages-require package-list))
