(require 'cc-mode)

(setq c-default-style "linux")
(setq-default c-basic-offset 4)
(c-set-offset 'case-label '+)

(define-key c-mode-map  [(control tab)] 'company-complete)
(define-key c++-mode-map  [(control tab)] 'company-complete)

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'c-mode-common-hook 'fci-mode)
(add-hook 'c-mode-common-hook 'auto-fill-mode)
;; (add-hook 'c-mode-common-hook 'irony-mode)


;; ;; replace the `completion-at-point' and `complete-symbol' bindings in
;; ;; irony-mode's buffers by irony-mode's function
;; (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map [remap completion-at-point]
;;     'irony-completion-at-point-async)
;;   (define-key irony-mode-map [remap complete-symbol]
;;     'irony-completion-at-point-async))
;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(setq company-clang-arguments ())
(add-to-list 'company-clang-arguments "-IC:/Users/ths1/devel/MESH/mesh-btle/mesh/include")
(add-to-list 'company-clang-arguments "-Ic:/Users/ths1/devel/MESH/mesh-btle/mesh/api")
(add-to-list 'company-clang-arguments "-Ic:/Users/ths1/devel/MESH/mesh-btle/mesh/models/pb_mesh/include")
(add-to-list 'company-clang-arguments "-Ic:/Users/ths1/devel/SDK/SDK_9.0.0_nrf51/components/device")
(add-to-list 'company-clang-arguments "-Ic:/Users/ths1/devel/SDK/SDK_9.0.0_nrf51/components/softdevice/s110/headers")
;; (setq cmake-ide-build-dir "C:/Users/ths1/devel/MESH/mesh-btle/build")
;; (cmake-ide-setup)


(require 'cmake-project)
(provide 'setup-cc-mode)
