;; define this keymap becouse spacemacs uses this variable
;; in the core but the package anaconda-mode changed this
;; variable name
(setq anaconda-view-mode-map (make-keymap))

(require 'prefix-C-b)
(require 'prefix-C-c)
(require 'prefix-C-f)
(require 'prefix-C-s)
(require 'prefix-C-x)

(provide 'prefixes)
