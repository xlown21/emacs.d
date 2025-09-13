;; -*- coding: utf-8; lexical-binding: t; -*-
;; basic gnu emacs settings. Everything in this file is for plain gnu emacs only.
;; for emacs 28 or later.
;; Version: 2024-08-21

;; Emacs: Init File Tutorial
;; http://xahlee.info/emacs/emacs/emacs_init_file.html

;;; Code:

(add-to-list 'load-path "~/.emacs.d/xah-fly-keys/")
(require 'xah-fly-keys)
;; specify a layout
(xah-fly-keys-set-layout "colemak")
(xah-fly-keys 1)
(global-set-key (kbd "<f8>") #'xah-fly-command-mode-activate)


(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

(setq scroll-margin 5
      scroll-conservatively 0
      scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)
(setq-default scroll-up-aggressively 0.01
      scroll-down-aggressively 0.01)


(require 'package)

;; Dodaj repozytoria
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;; Inicjalizacja systemu paczek
(package-initialize)

;; Upewnij się, że paczki są odświeżone
(unless package-archive-contents
  (package-refresh-contents))


(use-package diminish
  :ensure t)

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :config
  (which-key-mode +1))

(use-package company
  :ensure t
  :diminish company-mode
  :config
  (add-hook 'after-init-hook #'global-company-mode))

(use-package flycheck
  :ensure t
  :diminish flycheck-mode
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

(use-package vertico
  :ensure t
  :custom
  (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :ensure t
  :init
  (savehist-mode))

(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all)
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets"))

;; Git
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package git-gutter
  :ensure t
  :config
  (global-git-gutter-mode +1))


;; auto config treesiter
(use-package treesit-auto
  :ensure t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; LSP-MODE
(use-package lsp-mode
  :ensure t
  :hook ((python-mode . lsp)
         (python-ts-mode . lsp)
         (typescript-mode . lsp)
         (typescript-ts-mode . lsp)
         (js-mode . lsp)
         (js-ts-mode . lsp)
         (c-mode . lsp)
         (c-ts-mode . lsp)
         (c++-mode . lsp)
         (c++-ts-mode . lsp))
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; klawisze do lsp
  :config
  (setq lsp-enable-symbol-highlighting t
        lsp-enable-on-type-formatting t
        lsp-headerline-breadcrumb-enable t
        lsp-idle-delay 0.500))

;; LSP-UI (fancy UI do LSP)
(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-sideline-enable t
        lsp-ui-doc-position 'at-point))

;; HHHH------------------------------
;; UTF-8 as default encoding
;; http://xahlee.info/emacs/emacs/emacs_file_encoding.html
;; http://xahlee.info/emacs/emacs/emacs_encoding_decoding_faq.html

(set-language-environment "utf-8")
(set-default-coding-systems 'utf-8-unix)
(set-keyboard-coding-system 'utf-8-unix)
(set-terminal-coding-system 'utf-8-unix)

;; HHHH------------------------------
;; initial window and default window
;; http://xahlee.info/emacs/emacs/emacs_customize_default_window_size.html

(setq inhibit-startup-screen t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(background-color . "honeydew") default-frame-alist)

;; HHHH------------------------------
;;; real auto save

;; Emacs: Real Automatic Save File
;; http://xahlee.info/emacs/emacs/emacs_auto_save.html

;; (when (>= emacs-major-version 26)
;;   (auto-save-visited-mode 1)
;;   (setq auto-save-visited-interval 30) ; default 5
;;   )

(defun xah-save-all-unsaved ()
  "Save all unsaved files. no ask.
Version 2019-11-05"
  (interactive)
  (save-some-buffers t ))

(when (>= emacs-major-version 27)
  (setq after-focus-change-function 'xah-save-all-unsaved)
  ;; to undo this, run
  ;; (setq after-focus-change-function 'ignore)
  )

;; Emacs: auto-save (filename with #hashtag#)
;; http://xahlee.info/emacs/emacs/emacs_auto-save_backup.html
(setq auto-save-default nil)
(setq create-lockfiles nil)

;; HHHH------------------------------
;; Emacs: Bookmark Init
;; http://xahlee.info/emacs/emacs/emacs_bookmark_init.html

;; save bookmark on change
(setq bookmark-save-flag 1)

;; HHHH------------------------------
;; file related

;; auto refresh
;; http://xahlee.info/emacs/emacs/emacs_refresh_file.html
(global-auto-revert-mode 1)

;; Emacs: Open Recently Opened File
;; http://xahlee.info/emacs/emacs/emacs_recentf.html
(require 'recentf)
(recentf-mode 1)

(progn
  ;; (desktop-save-mode 1)
  (setq desktop-restore-frames t)
  (setq desktop-auto-save-timeout 300)
  (setq desktop-globals-to-save nil)
  ;; (setq desktop-globals-to-save '(desktop-missing-file-warning tags-file-name tags-table-list search-ring regexp-search-ring register-alist file-name-history))
  (setq desktop-save t))

;; HHHH------------------------------
;; user interface

(when (> emacs-major-version 26)
  (global-display-line-numbers-mode))

(column-number-mode 1)
(blink-cursor-mode 0)
;; (setq use-dialog-box nil)

(progn
  ;; no need to warn
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil)
  (put 'upcase-region 'disabled nil)
  (put 'downcase-region 'disabled nil)
  (put 'erase-buffer 'disabled nil)
  (put 'scroll-left 'disabled nil)
)

(setq mouse-highlight nil)

;; HHHH------------------------------
;; Emacs: Dired Customization
;; http://xahlee.info/emacs/emacs/emacs_dired_tips.html

;; copy, move, rename etc to the other pane
(setq dired-dwim-target t)

;; allow copy dir with subdirs
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)

(put 'dired-find-alternate-file 'disabled nil)

;; some goodies
(require 'dired-x)

;; HHHH------------------------------

;; remember cursor position
(when (>= emacs-major-version 25) (save-place-mode 1))

;; HHHH------------------------------
;;; editing related

;; make typing delete/overwrites selected text
(delete-selection-mode 1)

;; disable shift select
(setq shift-select-mode nil)

(electric-pair-mode 1)

;; for isearch-forward, make these equivalent: space newline tab hyphen underscore
(setq search-whitespace-regexp "[-_ \t\n]+")

(setq composition-break-at-point t)

(setq hippie-expand-try-functions-list
      '(
	try-expand-dabbrev
	try-expand-dabbrev-all-buffers
	;; try-expand-dabbrev-from-kill
	try-complete-lisp-symbol-partially
	try-complete-lisp-symbol
	try-complete-file-name-partially
	try-complete-file-name
	;; try-expand-all-abbrevs
	;; try-expand-list
	;; try-expand-line
	))

;; HHHH------------------------------
;; editing, mark

;; Emacs: Jump to Previous Position
;; http://xahlee.info/emacs/emacs/emacs_jump_to_previous_position.html

;; repeated C-u set-mark-command move cursor to previous mark in current buffer
(setq set-mark-command-repeat-pop t)

(setq mark-ring-max 10)
(setq global-mark-ring-max 10)

;; HHHH------------------------------
;;; rendering related for coding/editting

;; force line wrap to wrap at word boundaries
;; http://xahlee.info/emacs/emacs/emacs_toggle-word-wrap.html
(setq-default word-wrap t)

;; set highlighting brackets
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)

;; HHHH------------------------------
;; Emacs: Tab/Indent Setup
;; http://xahlee.info/emacs/emacs/emacs_tabs_space_indentation_setup.html

(electric-indent-mode 0)

(set-default 'tab-always-indent 'complete)

;; no mixed tab space
(setq-default indent-tabs-mode nil)
 ; gnu emacs at least 23.1 to 28 default is t

;; gnu emacs default to 8. tooo big. but problem of diff value is that some elisp source code in gnu emacs expected 8 to look nice, cuz they use mixed tab and space. but in golang, 8 is too much. also, python and others, standardize to 4
(setq-default tab-width 4)

(setq sentence-end-double-space nil )

;; HHHH------------------------------

;; load emacs 24's package system. Add MELPA repository.
(when (>= emacs-major-version 24)
  (require 'package)
  (add-to-list
   'package-archives
   '("melpa" . "https://melpa.org/packages/")
   t))

;; HHHH------------------------------

(progn
  ;; Make whitespace-mode with very basic background coloring for whitespaces.
  ;; http://xahlee.info/emacs/emacs/whitespace-mode.html
  (setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark newline-mark)))

  ;; Make whitespace-mode and whitespace-newline-mode use “¶” for end of line char and “▷” for tab.
  (setq whitespace-display-mappings
	;; all numbers are unicode codepoint in decimal. e.g. (insert-char 182 1)
	'((space-mark 32 [183] [46]) ; SPACE 32 「 」, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
	  (newline-mark 10 [182 10]) ; LINE FEED,
	  (tab-mark 9 [9655 9] [92 9]) ; tab
	  )))

;; HHHH------------------------------

(if (version< emacs-version "28.1")
    (defalias 'yes-or-no-p 'y-or-n-p)
  (setq use-short-answers t))

;; HHHH------------------------------

;; 2021-12-21. fuck Alan Mackenzie
;; Emacs Lisp Doc String Curly Quote Controversy
;; http://xahlee.info/emacs/misc/emacs_lisp_curly_quote_controversy.html
(setq text-quoting-style 'grave)

;; 2023-08-04 turn off byte compile warning on unescaped single quotes
(setq byte-compile-warnings '(not docstrings) )

(setq byte-compile-docstring-max-column 999)

;; HHHH------------------------------

;; up/down arrow move based on logical lines (newline char) or visual line
(setq line-move-visual nil)
;; default is t
;; http://xahlee.info/emacs/emacs/emacs_arrow_down_move_by_line.html

;; HHHH------------------------------

;; (global-tab-line-mode)

(tooltip-mode -1)

;; HHHH------------------------------

;; 2023-01-24 apache per dir config file
(add-to-list 'auto-mode-alist '("\\.htaccess\\'" . conf-unix-mode))

;; 2023-01-24 pdf mode is super slow. should use dedicated app
(add-to-list 'auto-mode-alist '("\\.pdf\\'" . fundamental-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company diminish flycheck git-gutter lsp-ui magit marginalia
             orderless tree-sitter-langs treesit-auto vertico
             yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
