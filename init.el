(require 'cl)
(setq tls-checktrust t)

(setq python (or (executable-find "py.exe")
                 (executable-find "python")
                 ))

(let ((trustfile
       (replace-regexp-in-string
        "\\\\" "/"
        (replace-regexp-in-string
         "\n" ""
         (shell-command-to-string (concat python " -m certifi"))))))
  (setq tls-program
        (list
         (format "gnutls-cli%s --x509cafile %s -p %%p %%h"
                 (if (eq window-system 'w32) ".exe" "") trustfile)))
  (setq gnutls-verify-error t)
  (setq gnutls-trustfiles (list trustfile)))


(require 'package)
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

(when (not package-archive-contents)
    (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(global-linum-mode t) ;; enable line numbers globally
(setq auto-save-default nil)
(setq make-backup-files nil)

(defalias 'yes-or-no-p 'y-or-n-p)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-minimum-prefix-length 0)
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

(setq-default tab-width 4)

(use-package smartparens-config
    :ensure smartparens
    :init
	(smartparens-global-mode t)
	:config
    (show-smartparens-global-mode t))

(use-package iedit
  :ensure t)


(use-package material-theme
   :ensure t
   :config (load-theme 'material t)) ;; load material theme

(use-package undo-tree
  :ensure t
  :init
  (global-undo-tree-mode 1))
  (global-set-key (kbd "C-z") 'undo)
  ;;make ctrl-Z redo
  (defalias 'redo 'undo-tree-redo)
  (global-set-key (kbd "C-S-z") 'redo)

(use-package volatile-highlights
  :ensure
  :init
  (volatile-highlights-mode t))


(use-package yasnippet
  :defer t
  :init
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  :config
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  (define-key yas-minor-mode-map (kbd "TAB") nil)
  (define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)
  (yas-global-mode 1)
  ;; (add-to-list 'yas-snippet-dirs "~/.emacs.d/yasnippet/")
  (yas-reload-all)
)


(use-package helm
  :ensure t
  :init
  (progn
  	(require 'helm-config)
    (require 'helm-grep)
  	(require 'helm-eshell)
  	;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
  	;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
  	;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
  	(global-set-key (kbd "C-c h") 'helm-command-prefix)
  	(global-unset-key (kbd "C-x c"))
  	(when (executable-find "curl")
  	  (setq helm-google-suggest-use-curl-p t))
  	(setq helm-split-window-in-side-p       t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line nil
	  helm-display-header-line nil)
  	(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)	
  	)
  :config
  
  (helm-autoresize-mode 1)
  (setq helm-autoresize-max-height 0
  helm-autoresize-min-height 20
  helm-M-x-fuzzy-match t ;; optional fuzzy matching for helm-M-x
  helm-buffers-fuzzy-matching t
  helm-recentf-fuzzy-match    t
  helm-semantic-fuzzy-match t
  helm-imenu-fuzzy-match    t
  helm-locate-fuzzy-match t
  helm-apropos-fuzzy-match t
  helm-lisp-fuzzy-completion t)


  (helm-mode 1)
  
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-c r") 'helm-recentf)
  (global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
  (global-set-key (kbd "C-c h o") 'helm-occur)

  (global-set-key (kbd "C-c h w") 'helm-wikipedia-suggest)
  (global-set-key (kbd "C-c h g") 'helm-google-suggest)

  (global-set-key (kbd "C-c h x") 'helm-register)
    ;; (global-set-key (kbd "C-x r j") 'jump-to-register)

  (define-key 'help-command (kbd "C-f") 'helm-apropos)
  (define-key 'help-command (kbd "r") 'helm-info-emacs)
  (define-key 'help-command (kbd "C-l") 'helm-locate-library)
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z
  	;; (add-hook 'eshell-mode-hook
    ;;       #'(lambda ()
    ;;           (define-key eshell-mode-map (kbd "C-c C-l")  'helm-eshell-history)))
  	;; (define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring)
  	(define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)
)

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

(use-package swiper-helm
  :ensure t)

(use-package helm-swoop				
      :bind (("C-s" . helm-swoop)
             ("C-c s" . helm-multi-swoop-all))
	  :init
	  (setq helm-swoop-pre-input-function
			(lambda () ""))
      :config
      ;; When doing isearch, hand the word over to helm-swoop
      (define-key isearch-mode-map (kbd "M-i") 'helm-swoop-from-isearch)

      ;; From helm-swoop to helm-multi-swoop-all
      (define-key helm-swoop-map (kbd "M-i") 'helm-multi-swoop-all-from-helm-swoop)

      ;; Save buffer when helm-multi-swoop-edit complete
      (setq helm-multi-swoop-edit-save t)

      ;; If this value is t, split window inside the current window
      (setq helm-swoop-split-with-multiple-windows t)

      ;; Split direcion. 'split-window-vertically or 'split-window-horizontally
      (setq helm-swoop-split-direction 'split-window-vertically)

      ;; If nil, you can slightly boost invoke speed in exchange for text color
      (setq helm-swoop-speed-or-color t))

(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)
  ;; (use-package flycheck-clangcheck
  ;; 	:ensure t
  ;; 	:init
  ;; 	(defun my-select-clangcheck-for-checker ()
  ;; 	  "Select clang-check for flycheck's checker."
  ;; 	  (flycheck-set-checker-executable 'c/c++-clangcheck
  ;; 									   "/usr/bin/clang-check")
  ;; 	  (flycheck-select-checker 'c/c++-clangcheck))
  ;; 	(add-hook 'c-mode-hook #'my-select-clangcheck-for-checker)
  ;; 	(add-hook 'c++-mode-hook #'my-select-clangcheck-for-checker)
  ;; 	;; enable static analysis
  ;; 	(setq flycheck-clangcheck-analyze t))
  :config
  (use-package helm-flycheck
	:ensure t
	:init (define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck)))

;; (use-package cc-mode
;;   :ensure t
;;   :config
;;   (define-key c-mode-map  [(tab)] 'company-complete)
;;   (define-key c++-mode-map  [(tab)] 'company-complete)
;;   (set 'company-clang-arguments (list "-std=c++11")))

;; (use-package rtags
;;   :ensure t
;;   :init
;;    (define-key c-mode-base-map (kbd "M-.")
;;     (function rtags-find-symbol-at-point))
;;    (define-key c-mode-base-map (kbd "M-,")
;;     (function rtags-find-references-at-point))
;;   ;; install standard rtags keybindings. Do M-. on the symbol below to
;;   ;; jump to definition and see the keybindings.
;;    (rtags-enable-standard-keybindings)
;;    (setq rtags-use-helm t)
;;    (setq rtags-autostart-diagnostics t)
;;    (rtags-diagnostics)
;;    (setq rtags-completions-enabled t)
;;    (use-package flycheck-rtags
;; 	:ensure t
;; 	:config
;; 	(defun my-flycheck-rtags-setup ()
;; 	  (flycheck-select-checker 'rtags)
;; 	  (setq-local flycheck-highlighting-mode nil) ;; RTags creates more accurate overlays.
;; 	  (setq-local flycheck-check-syntax-automatically nil))
;; 	(add-hook 'c-mode-hook #'my-flycheck-rtags-setup)
;; 	(add-hook 'c++-mode-hook #'my-flycheck-rtags-setup)
;; 	(add-hook 'objc-mode-hook #'my-flycheck-rtags-setup))
;;   (use-package helm-rtags
;; 	:ensure t
;; 	:config
;; 	(setq rtags-display-result-backend 'helm)))


(use-package company
  :ensure t
  :init
  (global-company-mode 1)
  (setq company-idle-delay 0.05)
  (setq company-async-timeout 10) ;; set timeout to 10 seconds
  (setq company-clang-arguments '("-I/work/UnrealEngine/Runtime/Core/Public/")) 
  (setq company-minimum-prefix-length 0)
  (use-package company-c-headers
	:ensure t
	:init
	(add-to-list 'company-backends 'company-c-headers)
;;	(push 'company-rtags company-backends)
	:config
	(add-to-list 'company-c-headers-path-system "/usr/include/c++/5/")
	(add-to-list 'company-c-headers-path-user "/work/UnrealEngine/Runtime/Core/Public/"))

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



;; ((c++-mode (eval setq company-clang-arguments (append 
;;                                                company-clang-arguments
;;                                                '("-I/work/UnrealEngine/Runtime/**")))))

(use-package ycmd
  :ensure t
  :init
  (set-variable 'ycmd-server-command '("python" "/home/mneumann/work/ycmd/ycmd/"))
  (set-variable 'ycmd-startup-timeout 15)
  :config
  (global-ycmd-mode)
  (set-variable 'ycmd-extra-conf-handler 'load)

  (use-package company-ycmd
	:ensure t
	:init
	(company-ycmd-setup))
  (use-package flycheck-ycmd
	:ensure t
	:config
	(flycheck-ycmd-setup))
  (require 'ycmd-eldoc)
  (add-hook 'ycmd-mode-hook 'ycmd-eldoc-setup)
  )


;; (use-package auto-complete
;;   :ensure t
;;   :init
;;   (use-package ac-helm
;; 	:ensure t
;; 	:config
;; 	(global-set-key (kbd "C-:") 'ac-complete-with-helm)
;; 	(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm))
;;   (use-package ac-c-headers
;; 	:ensure t
;; 	:config
;; 	(add-to-list 'ac-sources 'ac-source-c-headers)
;; 	(add-to-list 'ac-sources 'ac-source-c-header-symbols t))
;;   :config
;;   (ac-config-default))


;; (use-package irony
;;   :ensure t
;;   :init
;;   (use-package company-irony
;; 	:ensure t
;; 	:config)
;;   (use-package company-irony-c-headers
;; 	:ensure t
;; 	:config
;; 	(add-to-list
;; 	 'company-backends '(company-irony-c-headers company-irony)))
;;   (setq-default irony-cdb-compilation-databases '(irony-cdb-clang-complete
;;                                                   irony-cdb-libclang))
;;   :config
;;   (add-hook 'c++-mode-hook 'irony-mode)
;;   (add-hook 'c-mode-hook 'irony-mode)
;;   (add-hook 'objc-mode-hook 'irony-mode)
;;   (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map [remap completion-at-point]
;;     'irony-completion-at-point-async)
;;   (define-key irony-mode-map [remap complete-symbol]
;;     'irony-completion-at-point-async))

;;   (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;;   (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;;   (add-hook 'irony-mode-hook 'company-irony-setup-begin-commands)
;;   (add-to-list 'company-backends 'company-irony)
;;   (use-package irony-eldoc
;; 	:ensure t
;; 	:config
;; 	(add-hook 'irony-mode-hook 'irony-eldoc))
;;   (use-package flycheck-irony
;; 	:ensure t
;; 	:config
;; 	(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
;;   )


;; (use-package clang-format
;;   :ensure t
;;   :after cc-mode
;;   :defines c-mode-base-map
;;   :bind (:map c-mode-base-map ("C-S-f" . clang-format-region)))


;; (require 'semantic)
;; (global-semanticdb-minor-mode 1)
;; (global-semantic-idle-scheduler-mode 1)
;; (semantic-mode 1)
;; (require 'semantic/ia)
;; (require 'semantic/bovine/gcc)
;; (semantic-add-system-include "~/linux/kernel")
;; (semantic-add-system-include "~/linux/include")
;; (semantic-add-system-include "/user/include")
;; (semantic-add-system-include "/user/include/boost")
;; (semantic-add-system-include "/work/UnrealEngine/Runtime")

;; (global-ede-mode t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
