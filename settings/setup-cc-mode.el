(require 'cc-mode)

(setq c-default-style "linux")
(setq-default c-basic-offset 4)
(c-set-offset 'case-label '+)

(define-key c-mode-map  [(control tab)] 'company-complete)
(define-key c++-mode-map  [(control tab)] 'company-complete)

;; hs-minor-mode for folding source code
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(setq-default
 whitespace-line-column 100
 whitespace-style       '(face lines-tail))
(add-hook 'c-mode-common-hook #'whitespace-mode)
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
(add-to-list 'company-clang-arguments "-IC:/dev/mesh/verification/mod/mbtle/mesh/include/core")
(add-to-list 'company-clang-arguments "-IC:/dev/mesh/verification/mod/mbtle/mesh/include/dfu")
(add-to-list 'company-clang-arguments "-IC:/dev/mesh/verification/mod/mbtle/mesh/include/host")
(add-to-list 'company-clang-arguments "-IC:/dev/mesh/verification/mod/mbtle/mesh/include/prov")
(add-to-list 'company-clang-arguments "-Ic:/dev/mesh/verification/mod/mbtle/mesh/api")
(add-to-list 'company-clang-arguments "-Ic:/dev/mesh/verification/mod/mbtle/mesh/models/pb_mesh/include")
(add-to-list 'company-clang-arguments "-Ic:/dev/mesh/verification/mod/mbtle/lib/softdevice/s130/headers")
(add-to-list 'company-clang-arguments "-Ic:/dev/mesh/verification/mod/mbtle/mesh/api")
(add-to-list 'company-clang-arguments "-Ic:/dev/mesh/verification/mod/unity/src")
;; (setq cmake-ide-build-dir "C:/Users/ths1/devel/MESH/mesh-btle/build")
;; (cmake-ide-setup)


(require 'cmake-project)
(provide 'setup-cc-mode)
