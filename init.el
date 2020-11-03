					;http://www.emacswiki.org/emacs/EmacsNiftyTricks

					;C-x r t STRING <ret> for fill rect w string
;C-x (
;macro
;C-x )
;Use 0 as argument to call-last-kbd-macro C-x e to execute the macro until an error occurs (e.g. because a search failed or the end of buffer has been reached ), i.e. C-u 0 C-x e.
;Alternatively, select a region, then use apply-macro-to-region-lines, which is bound to C-x C-k r. From the docstring: Apply last keyboard macro to all lines in the region. For each line that begins in the region, move to the beginning of the line, and run the last keyboard macro.

;(execute-kbd-macro (symbol-function 'foo)) ;to run a macro lisp-like
; (global-set-key '[(f1)] 'call-last-kbd-macro) ;for example


;; smex org-checklist org-mime

(setq debug-on-error t)

;; (add-to-list 'load-path (concat (getenv "HOME") "/org/"))
(add-to-list 'load-path "/home/haml3t/org")
					; (load "org-mode")

(scroll-bar-mode -1)

(package-initialize)
;; load org elpa
(require 'package)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
;; load taskjuggler export
(require 'ox-taskjuggler)
;; load org-depend
(require 'org-depend)
;; keybindings
(setq lisp-directory (getenv "LISP"))
(setq hostname (getenv "HOSTNAME"))
(setq org-env-dir (getenv "ORG"))
(global-set-key (kbd "M-z") 'zap-up-to-char)

;; automatically update open buffers when changed on disk (from org edits & sync on phone or other computer)
(global-auto-revert-mode t)
(setq auto-revert-use-notify nil)		;automatically scan for changes every 5 seconds instead of relying on OS notifications

(column-number-mode)

(desktop-save-mode t)

(require 'epa-file)
(epa-file-enable)

(global-visual-line-mode t)

(if (file-exists-p abbrev-file-name) (quietly-read-abbrev-file))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; set font
(add-to-list 'default-frame-alist
	     '(font . "DejaVu Sans Mono-10"))

(setq save-interprogram-paste-before-kill t) ;pretty much what it says on the box
;; TRAMP
(setq tramp-default-method "ssh")
;(setq ring-bell-function 'ignore)
(fset 'yes-or-no-p 'y-or-n-p)
(show-paren-mode t)
(setq-default show-trailing-whitespace t)
(setq backup-directory-alist '(("." . "~/.saves")))
(windmove-default-keybindings 'meta)

(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

(global-set-key (kbd "<C-tab>") 'switch-window)
(global-set-key (kbd "C-x k") 'kill-this-buffer)

(global-hl-line-mode 1)
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

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


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
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

;; isearch

(add-hook 'isearch-mode-hook
	  (function
	   (lambda ()
	     (define-key isearch-mode-map "\C-h" 'isearch-mode-help)
	     (define-key isearch-mode-map "\C-t" 'isearch-toggle-regexp)
	     (define-key isearch-mode-map "\C-c" 'isearch-toggle-case-fold)
	     (define-key isearch-mode-map "\C-j" 'isearch-edit-string))))
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(defun org-taskjuggler-export-process-open ()
  (interactive)
  (org-taskjuggler-export)
  (shell-command
   (concat
    (concat "tj3 "
	    (substring (buffer-file-name) 0 -4))
    (concat ".tjp; firefox Plan.html"))))

;;(global-set-key (kbd "C-S-j") (switch-to-buffer "*-jabber-chat-Jane Cotler-*")
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

(setq align-rules-list '())

(global-linum-mode t)

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
(setq ace-jump-mode-case-fold t)

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
 (interactive "Zap up to char: ")
 (let ((direction (if (>= arg 0) 1 -1)))
   (kill-region (point)
		(progn
		  (forward-char direction)
		  (unwind-protect
		      (search-forward (char-to-string char) nil nil arg)
		    (backward-char direction))
		  (point)))))
;; ido
;; (setq ido-enable-flex-matching t)
;; (setq ido-everywhere t)
;; (ido-mode 1)				;when creating new file, disable with c-f
;; (setq ido-file-extensions-order '(".org" ".txt" ".tex" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))

;; helm

(require 'helm-config)
(require 'helm)
(setq helm-autoresize-max-height 30)
(helm-autoresize-mode 1)
(ido-mode -1)
(helm-mode 1)
(setq helm-mode-fuzzy-match t)
(setq	helm-semantic-fuzzy-match t)
(setq	helm-semantic-imenu-match t)
(setq	helm-completion-in-region-fuzzy-match t)
(setq	helm-split-window-in-side-p nil)
(setq	helm-ff-file-name-history-use-recentf t)
(setq   case-fold-search t)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-.") 'helm-semantic-or-imenu)

;; jabber
(add-to-list 'load-path lisp-directory)
;; (load "jabber_config.el")

;; that wizard's org config
;; (load "org-mode.el")
(load "org6.el")


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

(server-start)
(setq server-name "emacs-server")

;; org-protocol
(require 'org-protocol)
;; (add-to-list 'load-path "~/")
					; (org-agenda)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(case-fold-search t)
 '(custom-enabled-themes (quote (lush)))
 '(custom-safe-themes
   (quote
    ("d9aa334b2011d57c8ce279e076d6884c951e82ebc347adbe8b7ac03c4b2f3d72" "fa3bdd59ea708164e7821574822ab82a3c51e262d419df941f26d64d015c90ee" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "1d50bd38eed63d8de5fcfce37c4bb2f660a02d3dff9cbfd807a309db671ff1af" "e1ecb0536abec692b5a5e845067d75273fe36f24d01210bf0aa5842f2a7e029f" "d5d2ab76985738c142adbe6a35dc51c8d15baf612fdf6745c901856457650314" "07e3a1323eb29844e0de052b05e21e03ae2f55695c11f5d68d61fb5fed722dd2" "7f791f743870983b9bb90c8285e1e0ba1bf1ea6e9c9a02c60335899ba20f3c94" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "774aa2e67af37a26625f8b8c86f4557edb0bac5426ae061991a7a1a4b1c7e375" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "1ed5c8b7478d505a358f578c00b58b430dde379b856fbcb60ed8d345fc95594e" "0ad7f1c71fd0289f7549f0454c9b12005eddf9b76b7ead32a24d9cb1d16cbcbd" "6231254e74298a1cf8a5fee7ca64352943de4b495e615c449e9bb27e2ccae709" "d71aabbbd692b54b6263bfe016607f93553ea214bc1435d17de98894a5c3a086" "3577ee091e1d318c49889574a31175970472f6f182a9789f1a3e9e4513641d86" "bc836bf29eab22d7e5b4c142d201bcce351806b7c1f94955ccafab8ce5b20208" "1c8171893a9a0ce55cb7706766e57707787962e43330d7b0b6b0754ed5283cda" "8c757da4837dc5fe6effe9b8d2b8fd27ff1013fc8c22acf069d54b96268b7e96" "0820d191ae80dcadc1802b3499f84c07a09803f2cb90b343678bdb03d225b26b" "1ba463f6ac329a56b38ae6ac8ca67c8684c060e9a6ba05584c90c4bffc8046c3" default)))
 '(debug-on-error t)
 '(helm-follow-mode-persistent t)
 '(helm-source-names-using-follow
   (quote
    ("BWD_reporting.org" "BWD_personal.org" "BWD_systems.org" "refile_THESEUS.org" "BWD.org" "BWD_special_projects.org" "org-refile" "BWD_NanoWear.org")))
 '(jabber-chat-buffer-show-avatar nil)
 '(jabber-roster-line-format "%c %-25n %u %-8s  %S")
 '(nil nil t)
 '(org-agenda-auto-exclude-function (quote bh/org-auto-exclude-function))
 '(org-agenda-columns-add-appointments-to-effort-sum t)
 '(org-agenda-compact-blocks t)
 '(org-agenda-custom-commands
   (quote
    (("E" "pErsonal agenda and all TODOs"
      ((tags "HEADLINE+ACTIVE"
	     ((org-agenda-overriding-header "")))
       (tags-todo "GOAL+monthly"
		  ((org-agenda-overriding-header "Goals this month")))
       (agenda "" nil)
       (alltodo "" nil))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+PERSONAL")))))
     ("B" "BWD agenda & all TODOs"
      ((tags "HEADLINE+ACTIVE"
	     ((org-agenda-overriding-header "")))
       (agenda "" nil)
       (todo "NEXT" nil)
       (alltodo "" nil))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+BWD" "-SOMEDAY_MAYBE" "-HOLD" "-CANCELLED"))))
      nil)
     ("N" "Nanowear agenda & all TODOs"
      ((tags "HEADLINE+ACTIVE"
	     ((org-agenda-overriding-header "")))
       (agenda "" nil)
       (todo "NEXT" nil)
       (alltodo "" nil))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+Nanowear" "-SOMEDAY_MAYBE" "-HOLD" "-CANCELLED"))))
      nil)
     ("A" "ARM agenda & all TODOs"
      ((tags "HEADLINE+ACTIVE"
	     ((org-agenda-overriding-header "")))
       (agenda "" nil)
       (todo "NEXT" nil)
       (alltodo "" nil))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+ARM" "-SOMEDAY_MAYBE" "-HOLD" "-CANCELLED"))))
      nil)
     (" " "Agenda and all TODOs"
      ((agenda "" nil)
       (alltodo "" nil))
      ((org-agenda-tag-filter-preset
	(quote
	 ("-SOMEDAY/MAYBE")))))
     ("W" "WAITING items" todo "WAITING" nil)
     ("p" . "People agendas")
     ("pA" "Adriel Hernandez items"
      ((agenda "" nil)
       (tags-todo "AGENDA"
		  ((org-agenda-overriding-header "Adriel agenda items")))
       (tags-todo "\"-HOLD-CANCELLED/!\""
		  ((org-agenda-overriding-header "Adriel assigned/delegated projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (todo "HOLD"
	     ((org-agenda-overriding-header "Adriel project hopper")
	      (org-agenda-skip-function
	       (quote bh/skip-non-projects))
	      (org-tags-match-list-sublevels
	       (quote indented))))
       (tags-todo "\"-CANCELLED/!\""
		  ((org-agenda-overriding-header "Adriel stuck projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-stuck-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (todo "NEXT"
	     ((org-agenda-overriding-header "NEXT actions with/for Adriel")))
       (todo "WAITING"
	     ((org-agenda-overriding-header "Adriel items I'm waiting on"))))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+Adriel_Hernandez"))))
      nil)
     ("pk" "Kary-Liz Maldonado items"
      ((agenda "" nil)
       (tags-todo "AGENDA"
		  ((org-agenda-overriding-header "Kary agenda items")))
       (tags-todo "\"-HOLD-CANCELLED/!\""
		  ((org-agenda-overriding-header "Kary assigned/delegated projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (todo "HOLD"
	     ((org-agenda-overriding-header "Kary project hopper")
	      (org-agenda-skip-function
	       (quote bh/skip-non-projects))
	      (org-tags-match-list-sublevels
	       (quote indented))))
       (tags-todo "\"-CANCELLED/!\""
		  ((org-agenda-overriding-header "Kary stuck projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-stuck-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (todo "NEXT"
	     ((org-agenda-overriding-header "NEXT actions with/for Kary")))
       (todo "WAITING"
	     ((org-agenda-overriding-header "Kary items I'm waiting on"))))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+KaryLiz_Maldonado"))))
      nil)
     ("pI" "Ivan Nunez items"
      ((tags-todo "AGENDA"
		  ((org-agenda-overriding-header "Ivan agenda items")))
       (todo "NEXT"
	     ((org-agenda-overriding-header "NEXT actions with/for Ivan")))
       (todo "WAITING"
	     ((org-agenda-overriding-header "Ivan items I'm waiting on")))
       (tags-todo "GOAL+ROOT"
		  ((org-agenda-overriding-header "Goals committed to with Ivan"))))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+Ivan_Nunez" "-SOMEDAY_MAYBE" "-HOLD" "-CANCELLED"))))
      nil)
     ("pa" "Auralis items"
      ((tags-todo "AGENDA"
		  ((org-agenda-overriding-header "Auralis agenda items")))
       (todo "NEXT"
	     ((org-agenda-overriding-header "NEXT actions with/for Auralis")))
       (todo "WAITING"
	     ((org-agenda-overriding-header "Auralis items I'm waiting on")))
       (tags-todo "GOAL+ROOT"
		  ((org-agenda-overriding-header "Goals committed to with Auralis"))))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+Auralis_Herrero" "-SOMEDAY_MAYBE"))))
      nil)
     ("pi" "Itza Feliciano items"
      ((agenda "" nil)
       (tags-todo "AGENDA"
		  ((org-agenda-overriding-header "Itza agenda items")))
       (tags-todo "\"-HOLD-CANCELLED/!\""
		  ((org-agenda-overriding-header "Itza assigned/delegated projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (todo "HOLD"
	     ((org-agenda-overriding-header "Itza project hopper")
	      (org-agenda-skip-function
	       (quote bh/skip-non-projects))
	      (org-tags-match-list-sublevels
	       (quote indented))))
       (tags-todo "\"-CANCELLED/!\""
		  ((org-agenda-overriding-header "Itza stuck projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-stuck-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (todo "NEXT"
	     ((org-agenda-overriding-header "NEXT actions with/for Itza")))
       (todo "WAITING"
	     ((org-agenda-overriding-header "Itza items I'm waiting on"))))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+Itza_Feliciano"))))
      nil)
     ("pK" "KK Oliver items"
      ((agenda "" nil)
       (tags-todo "AGENDA"
		  ((org-agenda-overriding-header "KK agenda items")))
       (tags-todo "\"-HOLD-CANCELLED/!\""
		  ((org-agenda-overriding-header "KK assigned/delegated projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (todo "HOLD"
	     ((org-agenda-overriding-header "KK project hopper")
	      (org-agenda-skip-function
	       (quote bh/skip-non-projects))
	      (org-tags-match-list-sublevels
	       (quote indented))))
       (tags-todo "\"-CANCELLED/!\""
		  ((org-agenda-overriding-header "KK stuck projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-stuck-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (todo "NEXT"
	     ((org-agenda-overriding-header "NEXT actions with/for KK")))
       (todo "WAITING"
	     ((org-agenda-overriding-header "KK items I'm waiting on"))))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+KK_Oliver"))))
      nil)
     ("pm" "My BWD agenda---without delegated tasks/projects"
      ((agenda "" nil)
       (todo "NEXT" nil)
       (alltodo "" nil))
      ((org-agenda-tag-filter-preset
	(quote
	 ("+BWD" "-delegated_project"))))
      nil)
     ("r" "Notes to refile" tags "REFILE" nil)
     ("d" "Documentation tasks" tags-todo "documentation" nil)
     ("n" "All next actions for active projects" todo "NEXT"
      ((org-agenda-tag-filter-preset
	(quote
	 ("-SOMEDAY_MAYBE")))))
     ("e" "Effort ranked least to most" todo "NEXT"
      ((org-agenda-sorting-strategy
	(quote
	 (effort-up)))))
     ("P" "Projects" tags-todo "\"-HOLD-CANCELLED/!\""
      ((org-agenda-overriding-header "Projects")
       (org-agenda-skip-function
	(quote bh/skip-non-projects))
       (org-tags-match-list-sublevels
	(quote indented))
       (org-agenda-sorting-strategy
	(quote
	 (category-keep)))))
     ("s" "Stuck Projects" tags-todo "\"-CANCELLED/!\""
      ((org-agenda-overriding-header "Stuck Projects")
       (org-agenda-skip-function
	(quote bh/skip-non-stuck-projects))
       (org-agenda-sorting-strategy
	(quote
	 (category-keep)))))
     ("S" "Someday/Maybe" tags "TODO=\"SOMEDAY/MAYBE\""
      ((org-tags-match-list-sublevels
	(quote indented))))
     ("m" . "Meeting agendas")
     ("mm" "Weekly management meeting" todo ""
      ((org-agenda-overriding-header "Weekly Management Meeting Agenda Items")
       (org-agenda-tag-filter-preset
	(quote
	 ("+weekly_management_meeting" "+AGENDA")))))
     ("mn" "Weekly Nanowear call" todo ""
      ((org-agenda-overriding-header "Weekly Nanowear Agenda Items")
       (org-agenda-tag-filter-preset
	(quote
	 ("+weekly_Nanowear_call" "+AGENDA")))))
     ("g" . "Goals/committed projects")
     ("gI" "ISO quarterly meeting goals" tags "+ISO_quarterly_project" nil))))
 '(org-agenda-deadline-faces
   (quote
    ((1.0 quote
	  (:foreground "red"))
     (0.5 . org-upcoming-deadline)
     (0.0 . default))))
 '(org-agenda-include-diary t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday 1)
 '(org-agenda-sticky t)
 '(org-agenda-tags-column -120)
 '(org-agenda-time-grid
   (quote
    ((daily today require-timed)
     (800 1000 1200 1400 1600 1800 2000)
     "......" "----------------")))
 '(org-complete-tags-always-offer-all-agenda-tags t)
 '(org-default-notes-file "~/org/refile_THESEUS.org")
 '(org-export-backends (quote (ascii html icalendar latex taskjuggler)))
 '(org-habit-graph-column 100)
 '(org-protocol-default-template-key "w")
 '(org-tags-exclude-from-inheritance
   (quote
    ("PROJECT_ROOT" "SUBPROJECT_ROOT" "title" "ROOT" "crypt" "WAITING")))
 '(org-taskjuggler-default-global-properties
   "shift s40 \"Part time shift\" {
  workinghours wed, thu, fri off
}
flags tier1, note
")
 '(org-taskjuggler-default-reports
   (quote
    ("textreport report \"Plan\" {
  formats html
  header '== %title =='

  center -8<-
    [#Plan Plan] | [#Resource_Allocation Resource Allocation]
    ----
    === Plan ===
    <[report id=\"plan\"]>
    ----
    === Resource Allocation ===
    <[report id=\"resourceGraph\"]>
  ->8-
}

# A traditional Gantt chart with a project overview.
taskreport plan \"\" {
  headline \"Project Plan\"
  columns bsi, name, start, end, effort, chart
  rolluptask test, note
  hidetask note
  loadunit shortauto
  hideresource 1
}

# A graph showing resource allocation. It identifies whether each
# resource is under- or over-allocated for.
resourcereport resourceGraph \"\" {
  headline \"Resource Allocation Graph\"
  columns no, name, effort, weekly
  loadunit shortauto
  hidetask ~(isleaf() & isleaf_())
  sorttasks plan.start.up
}")))
 '(org-use-property-inheritance t)
 '(package-selected-packages
   (quote
    (gnuplot avy org-sticky-header doom-themes sqlup-mode helm-org-rifle fireplace visual-regexp rsense rainbow-delimiters lush-theme jabber iedit ido-hacks ido-gnus helm-bbdb gnus-spotlight gnorb ghci-completion ghc flymake-lua flycheck-hdevtools fish-mode f edit-server cl-generic bbdb-android autopair auto-complete-c-headers auto-complete-auctex auctex ace-window ace-jump-mode)))
 '(send-mail-function (quote smtpmail-send-it)))


(require 'edit-server)
(edit-server-start)

(defun save-and-compile-latex ()
  (interactive)
  (save-buffer)
  (shell-command
   (concat "pdflatex \"" (buffer-file-name) "\"")))

(add-hook 'LaTeX-mode-hook
	  (lambda () (local-set-key (kbd "M-c") 'save-and-compile-latex)))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome-stable")
;; bbdb and gnus
(load "~/.emacs.d/gnus-conf.el")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(rainbow-delimiters-depth-1-face ((t (:foreground "white"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "dark magenta"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "chocolate")))))
