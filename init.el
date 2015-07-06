;http://www.emacswiki.org/emacs/EmacsNiftyTricks

;C-x r t STRING <ret> for fill rect w string
;C-x (
;macro
;C-x )
;Use 0 as argument to call-last-kbd-macro C-x e to execute the macro until an error occurs (e.g. because a search failed or the end of buffer has been reached ), i.e. C-u 0 C-x e.
;Alternatively, select a region, then use apply-macro-to-region-lines, which is bound to C-x C-k r. From the docstring: Apply last keyboard macro to all lines in the region. For each line that begins in the region, move to the beginning of the line, and run the last keyboard macro.

;(execute-kbd-macro (symbol-function 'foo)) ;to run a macro lisp-like
; (global-set-key '[(f1)] 'call-last-kbd-macro) ;for example

;; keybindings
(global-set-key (kbd "M-z") 'zap-up-to-char)

(column-number-mode)

(setq save-interprogram-paste-before-kill t) ;pretty much what it says on the box
;(setq ring-bell-function 'ignore)
(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)
(setq-default show-trailing-whitespace t)
(setq backup-directory-alist '(("." . "~/.saves")))
(windmove-default-keybindings 'meta)

(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

(global-set-key (kbd "<C-tab>") 'switch-window)

(defun save-macro (name)
  "save a macro. Take a name as argument
     and save the last defined macro under
     this name at the end of your .emacs"
  (interactive "Name of the macro :")  ; ask for the name of the macro
  (kmacro-name-last-macro name)         ; use this name for the macro
  (find-file user-init-file)            ; open ~/.emacs or other user init file
  (goto-char (point-max))               ; go to the end of the .emacs
  (newline)                             ; insert a newline
  (insert-kbd-macro name)               ; copy the macro
  (newline)                             ; insert a newline
  (switch-to-buffer nil))               ; return to the initial buffer

(defun org-summary-todo (n-done n-not-done)
       "Switch entry to DONE when all subentries are done, to TODO otherwise."
       (let (org-log-done org-log-states)   ; turn off logging
	 (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(require 'auto-complete)

(ac-config-default)

(require 'yasnippet)
(yas-global-mode 1)

;; compile & run c
(defun compile-and-run-c ()
  (interactive)
  (let ((this_buffer (buffer-name)))
    (with-current-buffer (eval this_buffer) (save-buffer))
    (shell-command
     (concat "gcc /cygdrive/h/Dropbox/home/Haml3t/code/c/" (eval this_buffer) " -o /cygdrive/h/Dropbox/home/Haml3t/code/c/" (substring (eval this_buffer) 0 -2) ".exe && /cygdrive/h/Dropbox/home/Haml3t/code/c/"(substring (eval this_buffer) 0 -2) ".exe"))))

(add-hook 'c-mode-hook (lambda () (local-set-key (kbd "M-c") 'compile-and-run-c)))


(require 'autopair)
(autopair-global-mode)

(require 'visual-regexp)
(define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
(define-key global-map (kbd "C-c m") 'vr/mc-mark)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)


(defun compile-and-run-haskell ()
  "Compile and execute a .hs haskell file, as long as no reading from stdin is req'd"
  (interactive)
  (shell-command
   (concat
     (concat "ghc -v0 -O2 --make " ; -dynamic for dynamic linking
	     (substring (buffer-file-name) 0 -3))
     (concat "; " (substring (buffer-file-name) 0 -3)))))
;also, cabal install <lib> --enable-shared --reinstall
;; flyspell

;; auto-compile TeX with pdflatex on write
(add-hook 'latex-mode-hook (lambda () (add-hook 'after-save-hook (message "laser") nil 'make-it-local)))

(latex-preview-pane-enable)

(setq align-rules-list '())

(global-linum-mode t)

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(define-key global-map (kbd "M-j")	'ace-jump-mode)
(add-hook 'matlab-mode-hook (lambda () (local-set-key (kbd "M-j") 'ace-jump-mode)))
(define-key global-map (kbd "M-a")	'align-regexp)


;;encrypted email?
;;(require 'epa-file)
;;(epa-file-enable)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
;; disable menu bar, scroll bar
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; zap-to-char
(defun zap-up-to-char (arg char)
 "Kill up to, but not including ARGth occurrence of CHAR.
Case is ignored if `case-fold-search' is non-nil in the current buffer.
Goes backward if ARG is negative; error if CHAR not found.
Ignores CHAR at point."
 (interactive "p\ncZap up to char: ")
 (let ((direction (if (>= arg 0) 1 -1)))
   (kill-region (point)
		(progn
		  (forward-char direction)
		  (unwind-protect
		      (search-forward (char-to-string char) nil nil arg)
		    (backward-char direction))
		  (point)))))
;; ido
(ido-mode 1)				;when creating new file, disable with c-f
;; org-mode
(define-key global-map (kbd "C-c a") 'org-agenda)
(require 'org)
(setq org-default-notes-file (concat org-directory "/refile.org"))
(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c l") 'org-store-link)
(setq org-todo-keywords
       '((sequence "TODO(t!)" "WAITING(w@/!)" "DECISION(e)" "|" "DONE(d!0)")))
(setq org-log-done 'time)
(setq org-log-done 'note)
;; save clock history across Emacs sessions
(setq org-clock-persist 'history)
     (org-clock-persistence-insinuate)

(defun xah-copy-file-path (&optional φdir-path-only-p)
  "Copy the current buffer's file path or dired path to `kill-ring'.
If `universal-argument' is called, copy only the dir path.
Version 2015-01-14
URL `http://ergoemacs.org/emacs/emacs_copy_file_path.html'"
  (interactive "P")
  (let ((fPath
	 (if (equal major-mode 'dired-mode)
	     default-directory
	   (buffer-file-name))))
    (kill-new
     (if (equal φdir-path-only-p nil)
	 fPath
       (file-name-directory fPath)))
    (message "File path copied: 「%s」" fPath)))

;; (autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
;;  (add-to-list
;;   'auto-mode-alist
;;   '("\\.m$" . matlab-mode))

;; (server-start)
;; (setq server-name "emacs-server")

					; (org-agenda)

(require 'nnir)

(setq gnus-posting-styles
      '(((header "to" "lhaml3t@gmail.com")
	 (address "lhaml3t@gmail.com"))
	((header "to" "d.m.sugarman@gmail.com")
	 (address "d.m.sugarman@gmail.com"))
	((header "cc" "lhaml3t@gmail.com")
	 (address "lhaml3t@gmail.com"))
	((header "cc" "d.m.sugarman@gmail.com")
	 (address "d.m.sugarman@gmail.com"))))
(setq bbdb/news-auto-create-p t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (lush)))
 '(custom-safe-themes
   (quote
    ("0820d191ae80dcadc1802b3499f84c07a09803f2cb90b343678bdb03d225b26b" "1ba463f6ac329a56b38ae6ac8ca67c8684c060e9a6ba05584c90c4bffc8046c3" default)))
 '(initial-buffer-choice "~/habits.txt")
 '(jabber-account-list
   (quote
    (("lhaml3t@gmail.com"
      (:network-server . "talk.google.com")
      (:port . 5223)
      (:connection-type . ssl)))))
 '(org-agenda-columns-add-appointments-to-effort-sum t)
 '(org-agenda-custom-commands
   (quote
    (("w" "Weekly Planning"
      ((agenda ""
	       ((org-agenda-span 7)
		(org-agenda-sorting-strategy
		 (quote
		  (time-up priority-down tag-up)))
		(org-agenda-start-on-weekday nil)))
       (alltodo ""
		((org-agenda-category-filter-preset
		  (quote nil)))))
      nil nil)
     ("d" "Daily agenda and all TODO's"
      ((agenda ""
	       ((org-agenda-span 1)
		(org-agenda-sorting-strategy
		 (quote
		  (time-up priority-down tag-up)))
		(org-deadline-warning-days 0)))
       (alltodo "" nil))
      nil nil)
     ("n" "Agenda and all TODO's"
      ((agenda "" nil)
       (alltodo "" nil))
      nil))))
 '(org-agenda-file-regexp "\\\\`[^.].*\\.org\\\\'\\\\[0-9]+")
 '(org-agenda-files
   (quote
    ("~/org/refile.org" "~/org/notes.org" "~/org/TODO.org" "org-journal-dir")))
 '(org-clock-idle-time 10)
 '(org-clock-into-drawer 2)
 '(org-columns-default-format
   "%25ITEM(Task) %TODO %Effort(Estimated Effort){:} %CLOCKSUM %3PRIORITY %TAGS")
 '(org-enforce-todo-checkbox-dependencies t)
 '(org-enforce-todo-dependencies t)
 '(org-global-properties nil)
 '(org-journal-dir "~/org/journal")
 '(org-log-into-drawer t)
 '(org-refile-targets (quote (("~/org/TODO.org" :maxlevel . 5))))
 '(org-use-property-inheritance t)
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.gmail.com")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-dimmed-todo-face ((t (:foreground "grey50")))))

(require 'edit-server)
(edit-server-start)

(defun save-and-compile-latex ()
  (interactive)
  (save-buffer)
  (shell-command
   (concat "pdflatex \"" (buffer-file-name) "\"")))

(add-hook 'LaTeX-mode-hook
	  (lambda () (local-set-key (kbd "M-c") 'save-and-compile-latex)))

(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "lynx")

(setq user-full-name "David Sugarman")
