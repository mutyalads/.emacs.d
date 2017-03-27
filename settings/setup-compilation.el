(require 'ansi-color)

(setq compilation-scroll-output 'first-error)

(defun colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region (point-min) (point-max))))

(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(provide 'setup-compilation)
