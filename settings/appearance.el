(setq visible-bell t
      font-lock-maximum-decoration t
      color-theme-is-global t
      truncate-partial-width-windows nil)

;; Highlight current line
(global-hl-line-mode 1)

;; Set custom theme path
(setq custom-theme-directory (concat user-emacs-directory "themes"))

(if (eq system-type 'windows-nt)
    (setq thomsten/default-font "-outline-Consolas-normal-normal-normal-mono-13-*-*-*-m-0-iso8859-1"))

(when (eq system-type 'gnu/linux)
    (setq thomsten/presentation-font "-unknown-Ubuntu Mono-normal-normal-normal-*-22-*-*-*-*-*-iso8859-1")
    (setq thomsten/default-font "-unknown-Ubuntu Mono-normal-normal-normal-*-13-*-*-*-*-*-iso8859-1")
    )

(dolist
    (path (directory-files custom-theme-directory t "\\w+"))
  (when (file-directory-p path)
    (add-to-list 'custom-theme-load-path path)))

(setq thomsten/current-theme nil)

;(set-face-attribute 'default nil :font thomsten/default-font)

;; Default theme
(defun use-presentation-theme ()
  (interactive)
  (disable-theme thomsten/current-theme)
  (load-theme 'leuven)
  (setq thomsten/current-theme 'leuven)
  (when (boundp 'thomsten/presentation-font)
    (set-face-attribute 'default nil :font thomsten/presentation-font)))

(defun use-default-theme ()
  (interactive)
  (use-light-theme))

(defun use-default-black-theme ()
  (interactive)
  (disable-theme thomsten/current-theme)
  (load-theme 'default-black)
  (setq thomsten/current-theme 'default-black)
  (when (boundp 'thomsten/default-font)
    (set-face-attribute 'default nil :font thomsten/default-font)))

(defun use-light-theme ()
  (interactive)
  (disable-theme thomsten/current-theme)
  (load-theme 'leuven)
  (setq thomsten/current-theme 'leuven)
  (when (boundp 'thomsten/default-font)
    (set-face-attribute 'default nil :font thomsten/default-font)))

(defun use-zen-theme ()
  (interactive)
  (disable-theme thomsten/current-theme)
  (load-theme 'zenburn)
  (setq thomsten/current-theme 'zenburn)
  (when (boundp 'thomsten/default-font)
    (set-face-attribute 'default nil :font thomsten/default-font)))

(defun use-seti-theme ()
  (interactive)
  (disable-theme thomsten/current-theme)
  (load-theme 'seti)
  (setq thomsten/current-theme 'seti)
  (when (boundp 'thomsten/default-font)
    (set-face-attribute 'default nil :font thomsten/default-font)))

(defun toggle-presentation-mode ()
  (interactive)
  (if (string= (frame-parameter nil 'font) thomsten/default-font)
      (use-presentation-theme)
    (use-default-theme)))

(global-set-key (kbd "C-<f9>") 'toggle-presentation-mode)

(use-default-theme)

;; Don't defer screen updates when performing operations
(setq redisplay-dont-pause t)

;; Highlight matching parentheses when the point is on them.
(show-paren-mode 1)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (tooltip-mode -1)
  (blink-cursor-mode -1))

;; Make zooming affect frame instead of buffers
(require 'zoom-frm)

;; Unclutter the modeline
(require 'diminish)
(eval-after-load "yasnippet" '(diminish 'yas-minor-mode))
(eval-after-load "eldoc" '(diminish 'eldoc-mode))
(eval-after-load "paredit" '(diminish 'paredit-mode))
(eval-after-load "tagedit" '(diminish 'tagedit-mode))
(eval-after-load "elisp-slime-nav" '(diminish 'elisp-slime-nav-mode))
(eval-after-load "smartparens" '(diminish 'smartparens-mode))
(eval-after-load "guide-key" '(diminish 'guide-key-mode))

(defmacro rename-modeline (package-name mode new-name)
  `(eval-after-load ,package-name
     '(defadvice ,mode (after rename-modeline activate)
        (setq mode-name ,new-name))))


(defun thomsten/fci-enabled-p () (symbol-value 'fci-mode))

(defvar thomsten/fci-mode-suppressed nil)
(make-variable-buffer-local 'thomsten/fci-mode-suppressed)

(defadvice popup-create (before suppress-fci-mode activate)
  "Suspend fci-mode while popups are visible"
  (let ((fci-enabled (thomsten/fci-enabled-p)))
    (when fci-enabled
      (setq thomsten/fci-mode-suppressed fci-enabled)
      (turn-off-fci-mode))))

(defadvice popup-delete (after restore-fci-mode activate)
  "Restore fci-mode when all popups have closed"
  (when (and thomsten/fci-mode-suppressed
             (null popup-instances))
    (setq thomsten/fci-mode-suppressed nil)
    (turn-on-fci-mode)))

(defun split-in-three ()
  (interactive)
  (split-window-horizontally)
  (split-window-horizontally)
  (balance-windows))

(provide 'appearance)
