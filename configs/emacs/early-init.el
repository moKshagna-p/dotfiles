;;; early-init.el --- Early startup  -*- lexical-binding: t; -*-
;;; Commentary:  Performance and UI before package init (Purcell-inspired)

;;; Code:

;; Disable package.el at startup - we bootstrap in init.el
(setq package-enable-at-startup nil)

;; Performance: raise GC during startup, restore after
(setq gc-cons-threshold (* 128 1024 1024))
(setq gc-cons-percentage 0.6)

;; Native-comp warnings
(setq native-comp-async-report-warnings-errors 'silent)

;; UI - disable before frame creation for faster startup
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq tool-bar-mode nil
      scroll-bar-mode nil
      menu-bar-mode nil)

;; No startup screen / messages
(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      inhibit-startup-message t
      initial-scratch-message nil)

;; Frame
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

;; Don't compact font caches (better perf)
(setq inhibit-compacting-font-caches t)

(provide 'early-init)
;;; early-init.el ends here
