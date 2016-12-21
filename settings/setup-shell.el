;; Setup shell

;; Note: Emacs runs .bashrc in *shell*
;; So mac users should ln -s .profile .bashrc

;; bash-completion

(when (not (eq system-type 'windows-nt))
  (autoload 'bash-completion-dynamic-complete
    "bash-completion"
    "BASH completion hook")
  (add-hook 'shell-dynamic-complete-functions
            'bash-completion-dynamic-complete)
  (add-hook 'shell-command-complete-functions
            'bash-completion-dynamic-complete)
  )
;; tab-completion for shell-command
;; (require 'shell-command)
;; (shell-command-completion-mode)
;; (require 'bash-completion)
;; (bash-completion-setup)

(eval-after-load "shell"
  '(define-key shell-mode-map (kbd "TAB") #'company-complete))
(add-hook 'shell-mode-hook #'company-mode)

;; (setq ansi-color-names-vector
;;       ["black" "red" "green" "yellow" "PaleBlue" "magenta" "cyan" "white"])

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name
        "C:\\Program Files (x86)\\Git\\bin\\sh.exe"))
(setq shell-file-name explicit-shell-file-name)

;; C-d to kill buffer if process is dead.

(defun comint-delchar-or-eof-or-kill-buffer (arg)
  (interactive "p")
  (if (null (get-buffer-process (current-buffer)))
      (kill-buffer)
    (comint-delchar-or-maybe-eof arg)))

(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map (kbd "C-d") 'comint-delchar-or-eof-or-kill-buffer)))

(provide 'setup-shell)
