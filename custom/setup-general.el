(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-linum-mode t) ;; enable line numbers globally
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq gc-cons-threshold 100000000)
(setq inhibit-startup-message t)

(defalias 'yes-or-no-p 'y-or-n-p)


(use-package material-theme
  :ensure t
  :config (load-theme 'material t)) ;; load material theme


;; show unncessary whitespace that can mess up your diff
(add-hook 'prog-mode-hook
          (lambda () (interactive)
            (setq show-trailing-whitespace 1)))

;; use space to indent by default
(setq-default indent-tabs-mode nil)

;; set appearance of a tab that is represented by 4 spaces
(setq-default tab-width 4)

;; Compilation
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))

;; setup GDB
(setq
 ;; use gdb-many-windows by default
 gdb-many-windows t

 ;; Non-nil means display source file containing the main routine at startup
 gdb-show-main t
 )


(use-package company
  :ensure t
  :init
  (global-company-mode 1)
  (delete 'company-semantic company-backends)
  (setq company-idle-delay 0.05)
  (setq company-async-timeout 10) ;; set timeout to 10 seconds
  (setq company-minimum-prefix-length 0)
  (use-package company-c-headers
	:ensure t
	:init
	(add-to-list 'company-backends 'company-c-headers)
    ;;	(push 'company-rtags company-backends)
	:config
	(add-to-list 'company-c-headers-path-system "/usr/include/c++/5/"))

  (use-package helm-company
	:ensure t
	:config
	(progn
	  (define-key company-mode-map (kbd "C-:") 'helm-company)
	  (define-key company-active-map (kbd "C-:") 'helm-company)))
  :config
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
  (add-to-list 'auto-mode-alist '("\\.cu\\'" . c++-mode)) ;CUDA
  ;; QMake makefiles
  (add-to-list 'auto-mode-alist '("\\.pro\\'" . makefile-mode))
  )



;; Package: projejctile
(use-package projectile
  :ensure t
  :init
  (projectile-global-mode)
  (setq projectile-enable-caching t))

(use-package helm-projectile
  :ensure t
  :init
  (helm-projectile-on)
  (setq projectile-completion-system 'helm)
  (setq projectile-indexing-method 'alien)
  (setq projectile-switch-project-action 'helm-projectile-find-file)
  (setq projectile-switch-project-action 'helm-projectile))


;; Package zygospore
(use-package zygospore
  :ensure t
  :bind (("C-x 1" . zygospore-toggle-delete-other-windows)
         ("RET" .   newline-and-indent)))

  ; automatically indent when press RET

;; activate whitespace-mode to view all whitespace characters
(global-set-key (kbd "C-c w") 'whitespace-mode)
(windmove-default-keybindings)

(provide 'setup-general)
