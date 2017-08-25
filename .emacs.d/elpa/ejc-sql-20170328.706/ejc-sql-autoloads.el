;;; ejc-sql-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (directory-file-name (or (file-name-directory #$) (car load-path))))

;;;### (autoloads nil "ejc-autocomplete" "ejc-autocomplete.el" (22820
;;;;;;  17357 130283 26000))
;;; Generated autoloads from ejc-autocomplete.el

(autoload 'ejc-owners-candidates "ejc-autocomplete" "\


\(fn)" nil nil)

(autoload 'ejc-tables-candidates "ejc-autocomplete" "\


\(fn)" nil nil)

(autoload 'ejc-colomns-candidates "ejc-autocomplete" "\


\(fn)" nil nil)

(autoload 'ejc-ac-setup "ejc-autocomplete" "\
Add the completion sources to the front of `ac-sources'.
This affects only the current buffer.

Check against following cases:
prefix-2.prefix-1.#
prefix-1.#
something#

\(fn)" t nil)

;;;***

;;;### (autoloads nil "ejc-direx" "ejc-direx.el" (22820 17357 366283
;;;;;;  32000))
;;; Generated autoloads from ejc-direx.el

(autoload 'ejc-direx:pop-to-buffer "ejc-direx" "\


\(fn)" t nil)

(autoload 'ejc-direx:switch-to-buffer "ejc-direx" "\


\(fn)" t nil)

;;;***

;;;### (autoloads nil "ejc-sql" "ejc-sql.el" (22820 17357 158283
;;;;;;  27000))
;;; Generated autoloads from ejc-sql.el

(autoload 'ejc-sql-mode "ejc-sql" "\
Toggle ejc-sql mode.

\(fn &optional ARG)" t nil)

(autoload 'ejc-create-menu "ejc-sql" "\


\(fn)" nil nil)

;;;***

;;;### (autoloads nil nil ("ejc-doc.el" "ejc-format.el" "ejc-interaction.el"
;;;;;;  "ejc-lib.el" "ejc-result-mode.el" "ejc-sql-pkg.el") (22820
;;;;;;  17357 466283 35000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; ejc-sql-autoloads.el ends here
