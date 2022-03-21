(setq ring-bell-function 'ignore) ;; Disable the ring bell
(setq inhibit-startup-screen t)   ;; Disable Startup screen
;;run in home directory find . -name "*~" -delete
(setq backup-by-copying t        ;;Backup setup
      backup-directory-alist '(("." . "~/.emacsbackups"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
(global-auto-revert-mode t)

(show-paren-mode 1)
(setq show-paren-highlight-openparen t)
(setq show-paren-when-point-in-periphery t)
(setq show-paren-delay nil) ;; Show Matching Parenthesis without delay

(setq x-stretch-cursor t)   ;; Make cursor the width of the character it is under
(setq load-prefer-newer t)
(setq sentence-end-double-space nil)

(desktop-save-mode 1) ;; Save sessions between Emacs sessions
(setq desktop-restore-eager 3)
(save-place-mode 1) ;; Opens the File in the last position that it was closed.
(setq-default save-place-forget-unreadable-files nil) ;; Optimization for nfs.
(setq require-final-newline nil)

(mouse-wheel-mode t)  ;; Mouse scrolling in terminal
(blink-cursor-mode 0) ;; No blinking Cursor
(delete-selection-mode t) ;; Highlighting Text and typing deletes the text like other editors
(xterm-mouse-mode t)
(column-number-mode t)    ;; Column Number in modeline
(global-visual-line-mode 1)

(setq-default x-select-enable-clipboard t ;; Copy/Paste to clipboard with C-w/C-y
	      x-select-enable-primary t)

;;Shows the path to the file that is opened in the current buffer on the frame title
(setq frame-title-format
      '((:eval (if (buffer-file-name)
		   (buffer-file-name)
		 "%b"))))


(put 'erase-buffer 'disabled nil)  ;; Erases whole buffer.
(put 'upcase-region 'disabled nil) ;; Upper case disable.
(put 'set-goal-column 'disabled nil);;Doesnt reset cursor's column when changing line
(setq auto-window-vscroll nil) ;; Improves general performance when scrolling fast
;;Folding mode built-in emacs, i should search for a good folding plugin though
(add-hook 'prog-mode-hook #'hs-minor-mode)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(global-hl-line-mode)

;;Disable Scroll-bar
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode 0))
(fset 'yes-or-no-p 'y-or-n-p)

;;Package.el is available after version 24 of Emacs, check for older systems like CentOS
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "http://melpa.org/packages/")
   )
  (package-initialize))

(setq-default use-package-always-ensure t ; Auto-download package if not exists
	      use-package-verbose nil ; Don't report loading details
	      use-package-expand-minimally t  ; make the expanded code as minimal as possible
	      use-package-enable-imenu-support t) ; Let imenu finds use-package definitions

;;Install use-package for the first time that emacs starts on a new system.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (eval-when-compile (require 'use-package)))
;; I should consider checking straight.el

(require 'bind-key)

(use-package spacemacs-theme
  :ensure t
  :no-require t
  :init (load-theme 'spacemacs-dark t))

(use-package which-key
  :ensure t
  :init (which-key-mode))

(use-package keycast
  :ensure t
  :init (keycast-mode))

(use-package gcmh
  :ensure t
  :config
  (gcmh-mode 1))

(use-package color-identifiers-mode
  :ensure t
  :init (add-hook 'after-init-hook 'global-color-identifiers-mode))

;;Different Color for every matching {}()[]
(use-package rainbow-delimiters
  :ensure t
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package helm
  :demand t
  :ensure t
  :init
  (require 'helm-config)
  (helm-mode 1)
  (helm-adaptive-mode 1)
  (helm-autoresize-mode t)
  (setq helm-ff-skip-boring-files t)
  (setq helm-quick-update t)
  (setq helm-ff-file-name-history-use-recentf t)
  :bind(
	("C-x C-f" . helm-find-files)
	("C-x b" . helm-buffers-list) ;; Pressing C-c a shows "boring buffers"
	("M-x" . helm-M-x)
	("C-s" . helm-swoop)
	)
  :init
  (define-key helm-find-files-map (kbd "<C-backspace>") 'backward-kill-word)
  (define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
  (define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-z") #'helm-select-action))

(use-package helm-swoop
  :ensure t
  :init
  (setq helm-swoop-speed-or-color t))


(use-package flycheck-pos-tip
  :ensure t)

(use-package flycheck
  :ensure t
  :init
  (add-hook 'after-init-hook #'global-flycheck-mode)
  (with-eval-after-load 'flycheck
    (flycheck-pos-tip-mode))
  ;; (setq flycheck-check-syntax-automatically '(mode-enabled new-line))
  ;;Raises the limit of flycheck errors that can be displayed in a single buffer, useful when using clang-analyzer.
  (setq flycheck-checker-error-threshold 5000)
  (progn
    (define-fringe-bitmap 'my-flycheck-fringe-indicator
      (vector #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00011100
	      #b00111110
	      #b00111110
	      #b00111110
	      #b00011100
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000
	      #b00000000))

    (flycheck-define-error-level 'error
      :severity 2
      :overlay-category 'flycheck-error-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-error)

    (flycheck-define-error-level 'warning
      :severity 1
      :overlay-category 'flycheck-warning-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-warning)

    (flycheck-define-error-level 'info
      :severity 0
      :overlay-category 'flycheck-info-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-info)))


(use-package company
  :ensure t
  ;;Special Case in python to shift to the left use C-C <
  :bind("TAB" . company-indent-or-complete-common)
  :init (add-hook 'after-init-hook 'global-company-mode)
  :config
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (push 'company-files company-backends))

(use-package yasnippet
  :ensure t
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

(use-package smartparens
  :ensure t
  :bind(("M-]" . sp-unwrap-sexp))
  :init
  (require 'smartparens-config)
  (smartparens-global-mode t)
  (add-hook 'prog-mode-hook 'turn-on-smartparens-strict-mode)
  (setq sp-escape-quotes-after-insert nil))

(use-package whitespace
  :init
  (setq whitespace-line-column 120)
  (setq whitespace-style '(trailing))
  (global-whitespace-mode))

(use-package ethan-wspace
  :ensure t
  :config
  (setq mode-require-final-newline 'nil)
  (add-hook 'after-save-hook 'ethan-wspace-clean-all)
  (global-ethan-wspace-mode 1))


(use-package aggressive-indent
  :ensure t
  :init
  (add-hook 'c-mode-hook 'aggressive-indent-mode)
  (add-hook 'c++-mode-hook 'aggressive-indent-mode)
  :config
  (add-to-list
   'aggressive-indent-dont-indent-if
   '(and (derived-mode-p 'c++-mode 'c-mode)
	 (null (string-match "\\([;{}]\\|\\b\\(if\\|for\\|while\\)\\b\\)"
			     (thing-at-point 'line))))))

(use-package lua-mode
  :ensure t)

(use-package doom-modeline
  :ensure t
  :init(doom-modeline-mode 1))

(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-auto-guess-root t)
  :hook
  (c-mode . lsp)
  (c++-mode . lsp)
  (lsp-mode . lsp-enable-which-key-integration)
  :config
  (lsp-ensure-server 'clangd))

(use-package lsp-ui
  :ensure t)

(define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
(define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references)
