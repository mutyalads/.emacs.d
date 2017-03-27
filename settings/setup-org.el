;; This org-mode setup is a mish-mash of a lot of stuff. Mostly inpsired by:
;; http://doc.norang.ca/org-mode.html
(require 'org)
(require 'ox)
(require 'ox-confluence)


;; ;; Test github sync
;; (mapc 'load
;;       '("org-element" "os" "os-bb" "os-github" "os-rmine"))

(when (eq system-type 'windows-nt)
  (add-to-list 'exec-path "C:/Program Files (x86)/Aspell/bin/")
  )
(setq ispell-program-name "aspell")
(setq ispell-personal-dictionary "~/.ispell")
(require 'ispell)

(add-hook 'org-mode-hook 'turn-on-flyspell 'append)
(add-hook 'org-mode-hook 'visual-line-mode 'append)

(setq browse-url-browser-function 'browse-url-generic)

(setq org-latex-listings t)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
'(org-file-apps
  (quote
   ((auto-mode . emacs)
    ("\\.mm\\'" . default)
    ("\\.x?html?\\'" . "midori %s")
    ("\\.pdf\\'" . default))))

(defun myorg-update-parent-cookie ()
  (when (equal major-mode 'org-mode)
    (save-excursion
      (ignore-errors
        (org-back-to-heading)
        (org-update-parent-todo-statistics)))))

(defadvice org-kill-line (after fix-cookies activate)
  (myorg-update-parent-cookie))

(defadvice kill-whole-line (after fix-cookies activate)
  (myorg-update-parent-cookie))


(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-startup-indented 1)


(setq org-directory "~/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map (kbd "C-c h") 'org-capture) ; "org husk"

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file (concat org-directory "/refile.org"))
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/Dropbox/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "REVIEW(r)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" )
              (sequence "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("REVIEW" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("REVIEW" ("WAITING") ("CANCELLED") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

(setq org-agenda-files (list org-directory
                             (concat org-directory "/mesh")))
(defun thomsten/org-begin-type (str)
  (insert (concat "#+BEGIN_" str "\n\n" "#+END_" str))
  (forward-line -1))

(defun thomsten/org-begin-quote ()
  (interactive)
  (thomsten/org-begin-type "QUOTE"))

(defun thomsten/org-begin-src ()
  (interactive)
  (thomsten/org-begin-type "SRC"))


;; Using visual notifications :)
;; Requires mplayer
(require 'notify-popup)
(setq
 appt-message-warning-time 15 ;; warn 15 min in advance
 appt-display-mode-line t     ;; show in the modeline
 appt-display-format 'window) ;; use our func
(appt-activate 1)              ;; active appt (appointment notification)
(display-time)                 ;; time display is required for this...

;; update appt each time agenda opened
(add-hook 'org-finalize-agenda-hook 'org-agenda-to-appt)

(defun appt-display (min-to-app new-time msg)
  (notify-popup (format "Appointment in %s minute(s)" min-to-app) msg
                "face-monkey"))
(setq appt-disp-window-function (function appt-display))
(defun appt-delete ())
(setq appt-delete-window-function (function appt-delete))

;; '(org-agenda-sorting-strategy
;;   (quote
;;    ((agenda time-up habit-down priority-down category-keep) ;; this was originally: (agenda habit-down time-up priority-down category-keep)
;;     (todo priority-down category-keep)
;;     (tags priority-down category-keep)
;;     (search category-keep))))

(setq org-journal-dir (concat org-directory "/personal/journal"))
(setq org-journal-file-format "journal_%Y_%m_%d.org")
(setq org-journal-enable-encryption 't)
(require 'org-crypt)
(require 'org-journal)

(provide 'setup-org)

