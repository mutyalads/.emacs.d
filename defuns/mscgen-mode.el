;; mscgen-mode.el -- Major mode for editing mscgen files
;; 
;; Author: Thomas Stenersen <stenersen.thomas@gmail.com>
;;
;; Blindly based on: https://github.com/josteink/mscgen-mode/blob/master/mscgen-mode.el
(defvar mscgen-indent-width 4 "Identation level")
(defvar mscgen-font "Inconsolata" "Font used for rendering")
(defun mscgen-indent-get ()
  "Indent current line of mscgen code."
  (beginning-of-line)
  (cond
   ((bobp)
    ;; simple case, indent to 0
    (indent-line-to 0))
   ((looking-at "^[ \t]*}[ \t]*$")
    ;; block closing, deindent relative to previous line
    (indent-line-to (save-excursion
                      (forward-line -1)
                      (if (looking-at "\\(^.*{[^}]*$\\)")
                          ;; previous line opened a block
                          ;; use same indentation
                          (current-indentation)
                        (max 0 (- (current-indentation) mscgen-indent-width))))))
   ;; other cases need to look at previous lines
   (t
    (indent-line-to (save-excursion
                      (forward-line -1)
                      (cond
                       ((looking-at "\\(^.*{[^}]*$\\)")
                        ;; previous line opened a block
                        ;; indent to that line
                        (+ (current-indentation) mscgen-indent-width))
                       ((and (not (looking-at ".*\\[.*\\].*"))
                             (looking-at ".*\\[.*")) ; TODO:PP : can be 1 regex
                        ;; previous line started filling
                        ;; attributes, intend to that start
                        (search-forward "[")
                        (current-column))
                       ((and (not (looking-at ".*\\[.*\\].*"))
                             (looking-at ".*\\].*")) ; TODO:PP : "
                        ;; previous line stopped filling
                        ;; attributes, find the line that started
                        ;; filling them and indent to that line
                        (while (or (looking-at ".*\\[.*\\].*")
                                   (not (looking-at ".*\\[.*"))) ; TODO:PP : "
                          (forward-line -1))
                        (current-indentation))
                       (t
                        ;; default case, indent the
                        ;; same as previous NON-BLANK line
                        ;; (or the first line, if there are no previous non-blank lines)
                        (while (and (< (point-min) (point))
                                    (looking-at "^\[ \t\]*$"))
                          (forward-line -1))
                        (current-indentation)) ))) )))

(defun mscgen-indent-line ()
  (interactive)
  (mscgen-indent-get)
  )



;;;; FONTIFICATION LEVELS

;; LEVEL 1 - keywords

(defconst mscgen-font-lock-keywords-1
  (let* (;; some keywords should only trigger when starting a line.
         ;; some keywords are OK almost anywhere, or at least treat them as such.
         (keywords '("label")))
    (list
     (cons keywords 'font-lock-keyword-face))))

;; used on level 3 for variables
(defconst mscgen-operators3 '("->" ">>" "-x" "-*" "=>" "=>>" "->>"))
;; used on level 2 for actual operator
(defconst mscgen-operators2 mscgen-operators3)

;; LEVEL 2 - operators

(defconst mscgen-font-lock-keywords-2
  (append mscgen-font-lock-keywords-1
          (let* (;; operators
                 (rx-operators (regexp-opt mscgen-operators2 t)))
            (list
             (cons rx-operators 'font-lock-comment-face)))))

;; LEVEL 3 - variables/actors

(defconst mscgen-font-lock-keywords-3 mscgen-font-lock-keywords-2)


(defcustom mscgen-font-lock-keywords "3 - Keywords, operators and variables"
  "Fontification level for `mscgen-mode'."
  :type '(choice (const "1 - Keywords") (const "2 - Keywords and operators") (const "3 - Keywords, operators and variables"))
  :group 'mscgen-mode)

(defun mscgen-get-font-lock-level ()
  "Gets the currently set font-lock level."

  (condition-case err
      (let* ((level-string (substring mscgen-font-lock-keywords 0 1))
             (level-num    (string-to-number level-string)))
        (cond ((= 1 level-num) mscgen-font-lock-keywords-1)
              ((= 2 level-num) mscgen-font-lock-keywords-2)
              (t               mscgen-font-lock-keywords-3)))
    (error
     mscgen-font-lock-keywords-3)))

(defun mscgen-compile-and-show-diagram ()
  (interactive)
  (save-buffer)
  (setq return
        (call-process
         "mscgen" 'nil 'nil 'nil
         "-F" mscgen-font
         "-Tpng" "-i" (buffer-name) "-o" (concat (substring (buffer-name) 0 -4) ".png"))
         )
  (if (> return 0)
    (message "Error \"%d\" rendering MSC..." return)
    )
  )

(defun mscgen-insert-label ()
  (interactive)
  (if (not (looking-at-p ".*;"))
      (end-of-line)
    (end-of-line)
    (delete-char -1)
    )
  (insert "[label=\"\"];")
  (backward-char 3)
  )

;;;###autoload
(define-derived-mode mscgen-mode fundamental-mode "mscgen-mode"
  "Major mode for editing msc(gen) files"

  (set (make-local-variable 'font-lock-defaults) (list (mscgen-get-font-lock-level)))

  (make-local-variable 'mscgen-indent-offset)
  (set (make-local-variable 'indent-line-function) 'mscgen-indent-line)

  (when (fboundp 'flycheck-mode-on-safe)
    (flycheck-mode-on-safe)))

(define-key mscgen-mode-map (kbd "C-c C-c") #'mscgen-compile-and-show-diagram)
(define-key mscgen-mode-map (kbd "C-c C-l") #'mscgen-insert-label)

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.msc$" . mscgen-mode))

(provide 'mscgen-mode)
