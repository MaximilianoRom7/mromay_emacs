


;; testing filter functions

(delq nil (mapcar #'(lambda(n) (if (eq 0 (% n 2)) n nil)) '(1 2 3)))

;; print the function as cons
(dolist (e (symbol-function 'a)) (message (symbol-name e)))
