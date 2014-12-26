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

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map (kbd "M-<f6>") 'org-capture)

(setq org-agenda-files (list "~/Dropbox/NTNU/master/org/litteratursøk.org"
                             "~/Dropbox/NTNU/ntnu-todo.org"))

(defun org-mode-reftex-setup ()
  (load-library "reftex")
  (and (buffer-file-name) (file-exists-p (buffer-file-name))
       (progn
                                        ;enable auto-revert-mode to update reftex when bibtex file changes on disk
         (global-auto-revert-mode t)
         (reftex-parse-all)
                                        ;add a custom reftex cite format to insert links
         (reftex-set-cite-format
          '((?b . "[[bib:%l][%l-bib]]")
            (?n . "[[notes:%l][%l-notes]]")
            (?p . "[[papers:%l][%l-paper]]")
            (?t . "%t")
            (?h . "** %t\n:PROPERTIES:\n:Custom_ID: %l\n:END:\n[[papers:%l][%l-paper]]")))))
  (define-key org-mode-map (kbd "C-c )") 'reftex-citation)
  (define-key org-mode-map (kbd "C-c (") 'org-mode-reftex-search))

(defun org-mode-reftex-search ()
  ;;jump to the notes for the paper pointed to at from reftex search
  (interactive)
  (org-open-link-from-string (format "[[notes:%s]]" (first (reftex-citation t)))))

(setq org-link-abbrev-alist
      '(("bib" . "~/Dropbox/NTNU/master/refs.bib::%s")
        ("notes" . "~/Dropbox/NTNU/master/org/notes.org::#%s")
        ("papers" . "~/Dropbox/NTNU/master/papers/%s.pdf")))

(add-hook 'org-mode-hook 'org-mode-reftex-setup)

(provide 'setup-org)
