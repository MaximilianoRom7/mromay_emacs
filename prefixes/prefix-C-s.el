(require 'helm)
(require 'mromay-docker)
(define-prefix-command 'map-c-s)
(global-set-key (kbd "C-s") 'map-c-s)

(global-set-key (kbd "C-s a") 'helm-ag)
(global-set-key (kbd "C-s s") 'helm-occur)
(global-set-key (kbd "C-s d") 'helm-multi-swoop-all)
(global-set-key (kbd "C-s o") 'docker-open-dired)

(provide 'prefix-C-s)
