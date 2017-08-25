
;; /usr/local/bin/odoo -c odoo-server.conf --xmlrpc-port=8069
;; /usr/local/bin/odoo_10e -c odoo-server.conf --xmlrpc-port=8069
;; ps aux | grep python | grep odoo | tr -s ' ' | cut -d ' ' -f 2 | xargs -L 1 kill -9

;; Added by Package.el. This must come before configurations of
;; installed packages. Don't delete this line. If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(load "~/.emacs.d/home/base.el")



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(nil nil t)
 '(package-selected-packages
   (quote
    (go-mode ejc-sql haskell-mode mwe-log-commands command-log-mode evil virtualenvwrapper magit helm-swoop swoop windsize recentf-ext web-mode realgud neotree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-diff-added ((((type tty)) (:foreground "green"))))
 '(magit-diff-added-highlight ((((type tty)) (:foreground "LimeGreen"))))
 '(magit-diff-context-highlight ((((type tty)) (:foreground "default"))))
 '(magit-diff-file-heading ((((type tty)) nil)))
 '(magit-diff-removed ((((type tty)) (:foreground "red"))))
 '(magit-diff-removed-highlight ((((type tty)) (:foreground "IndianRed"))))
 '(magit-section-highlight ((((type tty)) nil)))
 '(neo-dir-link-face ((t (:foreground "magenta"))))
 '(neo-file-link-face ((t (:foreground "yellow")))))
