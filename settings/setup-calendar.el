(require 'calendar-norway)
(require 'calfw)
(require 'calfw-org)
(require 'calfw-ical)

(setq calendar-holidays calendar-norway-raude-dagar)

(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; orgmode source
    )))

(provide 'setup-calendar)
