
;; all variables go in here
(setq
 auto-revert-mode             t
 global-auto-revert-mode      t
 neo-window-fixed-size        nil
 realgud-safe-mode            nil
 PDB_SKIP                     nil)

(if (fboundp 'global-undo-tree-mode)
    (global-undo-tree-mode t)
  ;; else
  (wmessage "ERROR: FUNCTION NOT EXITST global-undo-tree-mode"))

(provide 'vars)
