(require 'cc-mode)

(setq c-default-style "linux")
(setq-default c-basic-offset 2)
(c-set-offset 'case-label '+)

(define-key c-mode-map  [(control tab)] 'company-complete)
(define-key c++-mode-map  [(control tab)] 'company-complete)

;; company-c-headers
(add-to-list 'company-backends 'company-c-headers)

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)

(require 'cmake-project)

(provide 'setup-cc-mode)
