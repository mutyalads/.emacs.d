(require 'magit)

;; TODO:
;; - Add hook to refresh gtags on branch change

(when (eq system-type 'windows-nt)
  (setq exec-path (add-to-list 'exec-path "C:\\Program Files (x86)\\Git\\bin"))
  (setq magit-git-executable "C:\\Program Files (x86)\\Git\\bin\\git.exe"))

(add-hook 'magit-mode-hook 'magit-load-config-extensions)

(defun magit-save-and-exit-commit-mode ()
  (interactive)
  (save-buffer)
  (server-edit)
  (delete-window))

(defun magit-exit-commit-mode ()
  (interactive)
  (kill-buffer)
  (delete-window))

(eval-after-load "git-commit-mode"
  '(define-key git-commit-mode-map (kbd "C-c C-k") 'magit-exit-commit-mode))

;; C-c C-a to amend without any prompt

(defun magit-just-amend ()
  (interactive)
  (save-window-excursion
    (magit-with-refresh
     (shell-command "git --no-pager commit --amend --reuse-message=HEAD"))))

(eval-after-load "magit"
  '(define-key magit-status-mode-map (kbd "C-c C-a") 'magit-just-amend))

;; C-x C-k to kill file on line

(defun magit-kill-file-on-line ()
  "Show file on current magit line and prompt for deletion."
  (interactive)
  (magit-visit-item)
  (delete-current-buffer-file)
  (magit-refresh))

(define-key magit-status-mode-map (kbd "C-x C-k") 'magit-kill-file-on-line)

;; full screen magit-status

(defadvice magit-status (around magit-fullscreen activate)
  (window-configuration-to-register :magit-fullscreen)
  ad-do-it
  (delete-other-windows))

(defun magit-quit-session ()
  "Restores the previous window configuration and kills the magit buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :magit-fullscreen))

(define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

;; full screen vc-annotate

(defun vc-annotate-quit ()
  "Restores the previous window configuration and kills the vc-annotate buffer"
  (interactive)
  (kill-buffer)
  (jump-to-register :vc-annotate-fullscreen))

(eval-after-load "vc-annotate"
  '(progn
     (defadvice vc-annotate (around fullscreen activate)
       (window-configuration-to-register :vc-annotate-fullscreen)
       ad-do-it
       (delete-other-windows))

     (define-key vc-annotate-mode-map (kbd "q") 'vc-annotate-quit)))

;; ignore whitespace

(defun magit-toggle-whitespace ()
  (interactive)
  (if (member "-w" magit-diff-options)
      (magit-dont-ignore-whitespace)
    (magit-ignore-whitespace)))

(defun magit-ignore-whitespace ()
  (interactive)
  (add-to-list 'magit-diff-options "-w")
  (magit-refresh))

(defun magit-dont-ignore-whitespace ()
  (interactive)
  (setq magit-diff-options (remove "-w" magit-diff-options))
  (magit-refresh))

(define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)

;; Show blame for current line

(require-package 'git-messenger)
(global-set-key (kbd "C-x v p") #'git-messenger:popup-message)

;; Don't bother me with flyspell keybindings

(eval-after-load "flyspell"
  '(define-key flyspell-mode-map (kbd "C-.") nil))

(defun is-branch-jira-task (branch-name)
  (s-matches? "[A-Z]+-[0-9]+" branch-name))

(defun get-jira-task-from-branch (branch-name)
  (setq match (s-match "[A-Z]+-[0-9]+" branch-name))
  (if match
      (nth 0 match)))

(defun magit-add-jira-task-to-commit-hook ()
  (goto-char (point-min))
  (if (looking-at-p "[[:space:]]*$")
      (let ((current-branch (magit-get-current-branch)))
        (when (is-branch-jira-task current-branch)
          (insert (get-jira-task-from-branch current-branch) ": ")))))

(add-hook 'git-commit-mode-hook 'magit-add-jira-task-to-commit-hook)

(provide 'setup-magit)
