(require 'cc-mode)

(setq c-default-style "linux")
(setq-default c-basic-offset 4)
(c-set-offset 'case-label '+)

(define-key c-mode-map  [(control tab)] 'company-complete)
(define-key c++-mode-map  [(control tab)] 'company-complete)

;; company-c-headers
(add-to-list 'company-backends 'company-c-headers)

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'c-mode-common-hook 'fci-mode)
(add-hook 'c-mode-common-hook 'auto-fill-mode)
(setenv "SDK_ROOT" "/home/thomsten/devel/SDK9")

(require 'cmake-project)

(provide 'setup-cc-mode)
