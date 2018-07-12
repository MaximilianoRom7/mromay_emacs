;; define this keymap becouse spacemacs uses this variable
;; in the core but the package anaconda-mode changed this
;; variable name
(setq anaconda-view-mode-map (make-keymap))

(require 'mromay-prefix-c-b)
(require 'mromay-prefix-c-c)
(require 'mromay-prefix-c-f)
(require 'mromay-prefix-c-s)
(require 'mromay-prefix-c-x)

(provide 'mromay-prefixes)
