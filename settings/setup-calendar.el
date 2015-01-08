(when (require 'calendar-norway nil 'noerror)
  (print "Running...")
  ;; Localise date format, weekdays, months, lunar/solar names:
  (calendar-norway-common-settings)
  ;; Show days where you don't have to work:
  (setq calendar-holidays calendar-norway-raude-dagar))

;; (copy-face 'default 'calendar-iso-week-header-face)
;; (set-face-attribute 'calendar-iso-week-header-face nil
;;                     :foreground "lightblue")


;; (setq calendar-intermonth-header
;;       (propertize "WK"                  ; or e.g. "KW" in Germany
;;                   'font-lock-face 'calendar-iso-week-header-face))

;; (setq calendar-intermonth-text
;;       '(propertize
;;         (format "%2d"
;;                 (car
;;                  (calendar-iso-from-absolute
;;                   (calendar-absolute-from-gregorian (list month day year)))))
;;         'font-lock-face 'calendar-iso-week-face))

(require 'calfw)
(require 'calfw-org)
(require 'calfw-ical)

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; orgmode source
    )))
(provide 'setup-calendar)
