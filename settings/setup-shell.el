;; Setup shell

;; Note: Emacs runs .bashrc in *shell*
;; So mac users should ln -s .profile .bashrc

;; bash-completion

(autoload 'bash-completion-dynamic-complete
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
          'bash-completion-dynamic-complete)
(add-hook 'shell-command-complete-functions
          'bash-completion-dynamic-complete)

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

;; C-d to kill buffer if process is dead.

(defun comint-delchar-or-eof-or-kill-buffer (arg)
  (interactive "p")
  (if (null (get-buffer-process (current-buffer)))
      (kill-buffer)
    (comint-delchar-or-maybe-eof arg)))

(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map (kbd "C-d") 'comint-delchar-or-eof-or-kill-buffer)))


;; (if (eq system-type 'windows-nt)
;;     ;; Windows // Cygwin config
;;     (setenv "PATH" (concat "c:/cygwin64/bin;" (getenv "PATH")))
;;   (setq exec-path (cons "c:/cygwin64/bin/" exec-path))
;;   (require 'cygwin-mount)
;;   (cygwin-mount-activate)

;;                                         ;(require 'setup-cygwin)


;;   (add-hook 'comint-output-filter-functions
;;             'shell-strip-ctrl-m nil t)
;;   (add-hook 'comint-output-filter-functions
;;             'comint-watch-for-password-prompt nil t)
;;   (setq explicit-shell-file-name "bash.exe")
;;   (setq shell-file-name explicit-shell-file-name)
;;   (setq shell-command-switch "-c")
;;   )

;; (when (or (eq system-type 'windows-nt) (eq system-type 'msdos))
;;   (setenv "PATH" (concat "C:\\GNU\\gnuwin32\\bin;" (getenv "PATH")))
;;   (setq find-program "C:\\GNU\\gnuwin32\\bin\\find.exe"
;;         grep-program "C:\\GNU\\gnuwin32\\bin\\grep.exe"))

(provide 'setup-shell)
