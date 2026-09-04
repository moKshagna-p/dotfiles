;;; init.el --- Lean Purcell-inspired Emacs config + Evil + Vertico/Corfu -*- lexical-binding: t; -*-
;;; Commentary:
;;  Inspired by purcell/emacs.d but minimal (~1 file + early-init)
;;  Curated from emacs-tw/awesome-emacs top packages
;;  Emacs 30+ optimized, macOS friendly

;;; Code:

(let ((minver "28.1"))
  (when (version< emacs-version minver)
    (error "Requires Emacs %s or higher" minver)))

;; ── GC & perf ───────────────────────────────────────────────────────
(setq read-process-output-max (* 4 1024 1024))
(setq process-adaptive-read-buffering nil)
(setq jit-lock-defer-time 0)
(setq idle-update-delay 1.0)

;; Silence warnings
(setq warning-minimum-level :error)

;; ── Package bootstrap ───────────────────────────────────────────────
(require 'package)
(setq package-archives '(("melpa"  . "https://melpa.org/packages/")
                         ("gnu"    . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t
      use-package-always-defer nil
      use-package-verbose nil
      use-package-compute-statistics nil)

(use-package diminish :ensure t)
(use-package gcmh
  :diminish gcmh-mode
  :init (setq gcmh-high-cons-threshold (* 128 1024 1024))
  :config (gcmh-mode 1))

;; exec-path on macOS
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns))
  :init (setq exec-path-from-shell-arguments nil)
  :config (exec-path-from-shell-initialize))

;; ── Custom file ─────────────────────────────────────────────────────
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file) (load custom-file :noerror))

;; ── Defaults (Purcell's better defaults) ────────────────────────────
(setq-default
 indent-tabs-mode nil
 tab-width 4
 fill-column 80
 truncate-lines t
 require-final-newline t
 sentence-end-double-space nil
 confirm-nonexistent-file-or-buffer nil
 kill-whole-line t
 create-lockfiles nil
 make-backup-files nil
 auto-save-default t
 auto-save-visited-mode nil
 ring-bell-function 'ignore
 use-short-answers t
 dired-dwim-target t
 dired-recursive-copies 'always
 dired-recursive-deletes 'top
 delete-by-moving-to-trash t
 vc-follow-symlinks t
 find-file-visit-truename t
 help-window-select t
 use-dialog-box nil
 history-length 1000
 save-interprogram-paste-before-kill t
 mark-even-if-inactive nil
 kill-do-not-save-duplicates t
 completions-detailed t)

;; UTF-8
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

;; line numbers: relative in prog-mode
(setq display-line-numbers-type 'relative)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'conf-mode-hook #'display-line-numbers-mode)

;; hl-line
(add-hook 'prog-mode-hook #'hl-line-mode)

;; whitespace
(setq whitespace-style '(face trailing tabs tab-mark))
(add-hook 'prog-mode-hook #'whitespace-mode)

;; electric pairs & indent
(electric-pair-mode 1)
(electric-indent-mode 1)
(delete-selection-mode 1)
(global-auto-revert-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(show-paren-mode 1)
(column-number-mode 1)
(size-indication-mode 1)

;; scrolling
(setq scroll-margin 2
      scroll-conservatively 10000
      scroll-preserve-screen-position t
      auto-window-vscroll nil
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil)

;; ── macOS ───────────────────────────────────────────────────────────
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta
        mac-option-modifier 'super
        mac-right-option-modifier 'super
        ns-use-native-fullscreen t
        ns-pop-up-frames nil)
  ;; smooth scrolling
  (setq mac-mouse-wheel-smooth-scroll t)
  ;; font: SF Mono / JetBrains
  (when (member "JetBrains Mono" (font-family-list))
    (set-face-attribute 'default nil :family "JetBrains Mono" :height 130))
  (when (member "SF Mono" (font-family-list))
    (set-face-attribute 'default nil :family "SF Mono" :height 130)))

;; default font fallback
(when (member "JetBrains Mono" (font-family-list))
  (set-face-attribute 'default nil :font "JetBrains Mono-13"))

;; ── Theme ───────────────────────────────────────────────────────────
(use-package modus-themes
  :init
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-mixed-fonts t
        modus-themes-prompts '(bold)
        modus-themes-completions '((t . (extrabold))))
  :config
  (load-theme 'modus-vivendi :no-confirm)
  ;; toggle with F5
  (define-key global-map (kbd "<f5>") #'modus-themes-toggle))

;; Alternative: doom-themes if you prefer
(use-package doom-themes
  :disabled
  :config (load-theme 'doom-one :no-confirm))

(use-package solaire-mode
  :hook (after-init . solaire-global-mode))

;; ── Evil (vim) ──────────────────────────────────────────────────────
(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-undo-system 'undo-fu
        evil-search-module 'evil-search
        evil-ex-search-vim-style-regexp t
        evil-respect-visual-line-mode t)
  :config
  (evil-mode 1)
  ;; C-g to normal
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-visual-state-map (kbd "C-g") 'evil-normal-state)
  ;; Use visual lines
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-surround
  :after evil
  :config (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :after evil
  :bind (("M-;" . evilnc-comment-or-uncomment-lines)
         ("C-c c l" . evilnc-quick-comment-or-uncomment-to-the-line)))

(use-package undo-fu
  :config (setq undo-limit 400000
                undo-strong-limit 3000000))

(use-package undo-fu-session
  :config (undo-fu-session-global-mode 1))

(use-package evil-goggles
  :after evil
  :config (evil-goggles-mode 1)
  :custom (evil-goggles-duration 0.15))

;; ── Which-key & Helpful ─────────────────────────────────────────────
(use-package which-key
  :diminish
  :hook (after-init . which-key-mode)
  :custom (which-key-idle-delay 0.4))

(use-package helpful
  :bind (([remap describe-function] . helpful-callable)
         ([remap describe-variable] . helpful-variable)
         ([remap describe-key]      . helpful-key)
         ("C-c C-d" . helpful-at-point)))

;; ── General (SPC leader like Doom/Space) ───────────────────────────
(use-package general
  :after evil
  :config
  (general-create-definer leader
    :states '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (leader
    "f"  '(:ignore t :which-key "file")
    "ff" '(find-file :which-key "find file")
    "fr" '(consult-recent-file :which-key "recent")
    "fs" '(save-buffer :which-key "save")
    "fS" '(write-file :which-key "save as")
    "b"  '(:ignore t :which-key "buffer")
    "bb" '(consult-buffer :which-key "switch")
    "bd" '(kill-this-buffer :which-key "kill")
    "bn" '(next-buffer :which-key "next")
    "bp" '(previous-buffer :which-key "prev")
    "w"  '(:ignore t :which-key "window")
    "wh" '(evil-window-left :which-key "left")
    "wj" '(evil-window-down :which-key "down")
    "wk" '(evil-window-up :which-key "up")
    "wl" '(evil-window-right :which-key "right")
    "wv" '(evil-window-vsplit :which-key "vsplit")
    "ws" '(evil-window-split :which-key "split")
    "wd" '(evil-window-delete :which-key "delete")
    "p"  '(:ignore t :which-key "project")
    "pp" '(projectile-switch-project :which-key "switch")
    "pf" '(projectile-find-file :which-key "find file")
    "ps" '(projectile-ripgrep :which-key "search")
    "g"  '(:ignore t :which-key "git")
    "gg" '(magit-status :which-key "magit")
    "gb" '(magit-blame :which-key "blame")
    "s"  '(:ignore t :which-key "search")
    "ss" '(consult-line :which-key "line")
    "sg" '(consult-ripgrep :which-key "ripgrep")
    "o"  '(:ignore t :which-key "open")
    "op" '(treemacs :which-key "treemacs")
    "t"  '(:ignore t :which-key "toggle")
    "tt" '(consult-theme :which-key "theme")
    "tl" '(display-line-numbers-mode :which-key "line numbers")
    "q"  '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-terminal :which-key "quit")
    "SPC" '(execute-extended-command :which-key "M-x")
    ":"  '(evil-ex :which-key "ex")))

;; ── Vertico stack (Purcell uses vertico) ───────────────────────────
(use-package vertico
  :init (vertico-mode 1)
  :custom (vertico-cycle t))

(use-package vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode 1)
  :bind (:map minibuffer-local-map ("M-A" . marginalia-cycle)))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("C-c r" . consult-recent-file)
         ("C-c s" . consult-ripgrep)
         ("M-g g" . consult-goto-line)
         ("M-g i" . consult-imenu))
  :custom (consult-preview-key 'any))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings))
  :init (setq prefix-help-command #'embark-prefix-help-command))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package consult-projectile :after (consult projectile))

;; ── Corfu (Purcell's choice) ────────────────────────────────────────
(use-package corfu
  :init (global-corfu-mode 1)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-prefix 2)
  (corfu-auto-delay 0.15)
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'prompt)
  :bind (:map corfu-map
              ("TAB" . corfu-next)
              ([tab] . corfu-next)
              ("S-TAB" . corfu-previous)
              ([backtab] . corfu-previous)))

(use-package corfu-terminal
  :if (not (display-graphic-p))
  :after corfu
  :config (corfu-terminal-mode 1))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))

(use-package kind-icon
  :after corfu
  :custom (kind-icon-default-face 'corfu-default)
  :config (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; ── Avy / Navigation (awesome-emacs star) ───────────────────────────
(use-package avy
  :bind (("C-:" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("M-g w" . avy-goto-word-1)
         ("M-g l" . avy-goto-line)))

(use-package ace-window
  :bind ("M-o" . ace-window)
  :custom (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package pulsar
  :hook (after-init . pulsar-global-mode)
  :custom (pulsar-delay 0.055))

;; ── Editing utils ───────────────────────────────────────────────────
(use-package expand-region :bind ("C-=" . er/expand-region))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (require 'smartparens-config))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode))

(use-package ws-butler
  :diminish
  :hook (prog-mode . ws-butler-mode))

(use-package move-text
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

(use-package crux
  :bind (("C-a" . crux-move-beginning-of-line)
         ("C-c d" . crux-duplicate-current-line-or-region)
         ("C-k" . crux-smart-kill-line)))

;; ── Eglot + Flymake (Purcell's LSP) ─────────────────────────────────
(use-package eglot
  :hook ((python-mode python-ts-mode
          js-mode js-ts-mode typescript-mode typescript-ts-mode
          rust-mode rust-ts-mode go-mode go-ts-mode
          c-mode c-ts-mode c++-mode c++-ts-mode) . eglot-ensure)
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0)
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pyright-langserver" "--stdio"))))

(use-package flymake
  :hook (prog-mode . flymake-mode)
  :bind (("M-n" . flymake-goto-next-error)
         ("M-p" . flymake-goto-prev-error)))

(use-package flycheck :disabled) ; we use flymake per Purcell

;; ── Treesitter ──────────────────────────────────────────────────────
(use-package treesit-auto
  :if (and (fboundp 'treesit-available-p) (treesit-available-p))
  :custom (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode 1))

;; ── Project / Git ───────────────────────────────────────────────────
(use-package projectile
  :diminish
  :init (setq projectile-completion-system 'default
              projectile-switch-project-action #'projectile-dired)
  :config (projectile-mode 1)
  :bind-keymap ("C-c p" . projectile-command-map))

(use-package magit
  :bind ("C-x g" . magit-status)
  :custom (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package diff-hl
  :hook ((after-init . global-diff-hl-mode)
         (dired-mode . diff-hl-dired-mode)
         (magit-post-refresh . diff-hl-magit-post-refresh)))

(use-package treemacs
  :bind ("C-c t" . treemacs)
  :custom (treemacs-width 32))

(use-package treemacs-evil :after (treemacs evil))
(use-package treemacs-projectile :after (treemacs projectile))

;; ── Org ─────────────────────────────────────────────────────────────
(use-package org
  :hook (org-mode . visual-line-mode)
  :custom
  (org-ellipsis " ▾")
  (org-hide-emphasis-markers t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-startup-indented t)
  (org-log-done 'time)
  :bind (("C-c a" . org-agenda)
         ("C-c c" . org-capture)))

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :custom (org-modern-star 'replace))

;; ── Markdown / others ───────────────────────────────────────────────
(use-package markdown-mode :mode ("\\.md\\'" . gfm-mode))
(use-package yaml-mode)
(use-package dockerfile-mode)
(use-package terraform-mode)
(use-package go-mode)
(use-package rust-mode)
(use-package lua-mode)
(use-package nix-mode)
(use-package zig-mode)
(use-package just-mode)

;; ── Dired ───────────────────────────────────────────────────────────
(use-package dired
  :ensure nil
  :custom
  (dired-listing-switches "-alh --group-directories-first")
  (dired-auto-revert-buffer t)
  :hook (dired-mode . dired-hide-details-mode))

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package nerd-icons :if (display-graphic-p))
(use-package nerd-icons-dired :hook (dired-mode . nerd-icons-dired-mode))

;; ── Mode-line ───────────────────────────────────────────────────────
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 22)
  (doom-modeline-icon t)
  (doom-modeline-minor-modes nil))

;; ── Terminals ───────────────────────────────────────────────────────
(use-package vterm :if (not (eq system-type 'windows-nt)))

;; ── Performance restore ─────────────────────────────────────────────
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 16 1024 1024))
            (setq gc-cons-percentage 0.1)
            (message "Emacs ready in %s with %d GCs"
                     (format "%.2f sec" (float-time (time-subtract after-init-time before-init-time)))
                     gcs-done)))

;; ── Reload helper ───────────────────────────────────────────────────
(defun reload-init-file ()
  "Reload init.el and early-init.el workflow.
For early-init changes, does `restart-emacs'. Otherwise reloads init.el."
  (interactive)
  (if (y-or-n-p "Restart Emacs (needed for early-init)? ")
      (restart-emacs)
    (load-file (locate-user-emacs-file "init.el"))
    (message "init.el reloaded")))

(with-eval-after-load 'general
  (leader "q r" '(reload-init-file :which-key "reload config")
          "q R" '(restart-emacs :which-key "restart emacs")))

(global-set-key (kbd "C-c r") #'reload-init-file)

;; ── Load local overrides ────────────────────────────────────────────
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-local nil t)

(provide 'init)
;;; init.el ends here
