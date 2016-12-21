;; Speed up on Windows! Pretty please!
;; http://stackoverflow.com/questions/2007329/emacs-23-1-50-1-hangs-ramdomly-for-6-8-seconds-on-windows-xp

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(when (eq system-type 'windows-nt)
  (setq w32-pipe-read-delay 0)
  (setq w32-get-true-file-attributes nil)
  )

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Set path to dependencies
;; (setq site-lisp-dir
;;       (expand-file-name "site-lisp" user-emacs-directory))

(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; Set up load path
;(add-to-list 'load-path site-lisp-dir)
(add-to-list 'load-path settings-dir)

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Set up appearance early
(require 'appearance)

;; Add external projects to load path
;; (dolist (project (directory-files site-lisp-dir t "\\w+"))
;;   (when (file-directory-p project)
;;     (add-to-list 'load-path project)))

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

(require 'iso-transl)

;; Setup packages
(require 'setup-package)


;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(anzu
     company
     helm
     helm-gtags
     helm-projectile
     helm-swoop
     projectile
     magit
     paredit
     move-text
     gist
     visual-regexp
     flycheck
     flx
     flx-ido
     yasnippet ; :todo: test
     smartparens ; :todo: test with latex
     ido-vertical-mode
     ido-at-point
     guide-key
     highlight-escape-sequences
     whitespace-cleanup-mode
;     git-commit-mode
     gitconfig-mode
     gitignore-mode
     auctex
     solarized-theme
     org-plus-contrib
     ido-ubiquitous
     ggtags
     cmake-project
     smooth-scrolling
     undo-tree
     dired-details
     find-file-in-project
     expand-region
     multiple-cursors
     jump-char
     multifiles
     fill-column-indicator
     browse-kill-ring
     smex
     calfw
     )))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; Lets start with a smattering of sanity
(require 'sane-defaults)

;; Setup environment variables from the user's shell.
(when is-mac
  (require-package 'exec-path-from-shell)
  (exec-path-from-shell-initialize))

;; guide-key
;; (require 'guide-key)
;; (setq guide-key/guide-key-sequence '("C-x r" "C-x 4" "C-x v" "C-x 8" "C-x +"))
;; (guide-key-mode 1)
;; (setq guide-key/recursive-key-sequence-flag t)
;; (setq guide-key/popup-window-position 'bottom)

;; Setup extensions
(eval-after-load 'ido '(require 'setup-ido))
(eval-after-load 'org '(require 'setup-org))
(eval-after-load 'dired '(require 'setup-dired))
(eval-after-load 'magit '(require 'setup-magit))
(eval-after-load 'grep '(require 'setup-rgrep))
(eval-after-load 'shell '(require 'setup-shell))

(require 'setup-yasnippet)
;; (require 'setup-perspective)
;; (require 'setup-paredit)
(require 'setup-ffip)

;; Font lock dash.el
(eval-after-load "dash" '(dash-enable-font-lock))

;; Default setup of smartparens
(require 'smartparens-config)
(setq sp-autoescape-string-quote nil)
(--each '(css-mode-hook
          restclient-mode-hook
          js-mode-hook
          java-mode
          ruby-mode
          markdown-mode
          groovy-mode
	  LaTeX-mode-hook
	  python-mode
          c-mode
          )
  (add-hook it 'turn-on-smartparens-mode))

;; Language specific setup files
(eval-after-load 'ruby-mode '(require 'setup-ruby-mode))
(eval-after-load 'markdown-mode '(require 'setup-markdown-mode))
(eval-after-load 'LaTeX-mode '(require 'setup-latex-mode))

;; Load stuff on demand
;; (autoload 'flycheck-mode "setup-flycheck" nil t)
;; (autoload 'auto-complete-mode "auto-complete" nil t)

;; Map files to modes
(require 'mode-mappings)

;; Highlight escape sequences
(require 'highlight-escape-sequences)
(hes-mode)
(put 'font-lock-regexp-grouping-backslash 'face-alias 'font-lock-builtin-face)

;; Visual regexp
(require 'visual-regexp)
(define-key global-map (kbd "M-&") 'vr/query-replace)
(define-key global-map (kbd "M-/") 'vr/replace)

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" user-emacs-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))

(require 'expand-region)
(require 'multiple-cursors)
(require 'delsel)
(require 'jump-char)
(require 'multifiles)

;; Fill column indicator
(require 'fill-column-indicator)
(setq fci-rule-color "#111122")

;; Browse kill ring
(require 'browse-kill-ring)
(setq browse-kill-ring-quit-action 'save-and-restore)

;; Smart M-x is smart
(require 'smex)
(smex-initialize)

;; Setup key bindings
(require 'key-bindings)

;; Misc
(require 'my-misc)
(when is-mac (require 'mac))
;;(when (eq system-type 'windows-nt) (require 'windows))

(require 'setup-helm)
(require 'setup-helm-gtags)
(require 'setup-ggtags)
(require 'setup-cedet)

;; company
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(delete 'company-semantic company-backends)
;; (delete 'company-clang company-backends)
(eval-after-load 'company '(add-to-list 'company-backends 'company-c-headers))
;; (eval-after-load 'company '(add-to-list 'company-backends 'company-irony-c-headers))
;; (eval-after-load 'company '(add-to-list 'company-backends 'company-irony))

(require 'setup-cc-mode)

;; Package: projejctile
(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)


(add-hook 'term-mode-hook (lambda ()
                            (setq yas-dont-activate t)))
;; Elisp go-to-definition with M-. and back again with M-,
;(autoload 'elisp-slime-nav-mode "elisp-slime-nav")
;(add-hook 'emacs-lisp-mode-hook (lambda () (elisp-slime-nav-mode t) (eldoc-mode 1)))

;; Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

;; Setup Calendar
(require 'setup-calendar)

;; Run at full power please
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
