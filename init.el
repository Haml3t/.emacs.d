1;http://www.emacswiki.org/emacs/EmacsNiftyTricks

;C-x r t STRING <ret> for fill rect w string
;C-x (
;macro
;C-x )
;Use 0 as argument to call-last-kbd-macro C-x e to execute the macro until an error occurs (e.g. because a search failed or the end of buffer has been reached ), i.e. C-u 0 C-x e.
;Alternatively, select a region, then use apply-macro-to-region-lines, which is bound to C-x C-k r. From the docstring: Apply last keyboard macro to all lines in the region. For each line that begins in the region, move to the beginning of the line, and run the last keyboard macro.

;(execute-kbd-macro (symbol-function 'foo)) ;to run a macro lisp-like
; (global-set-key '[(f1)] 'call-last-kbd-macro) ;for example

;; keybindings
(setq lisp-directory (getenv "LISP"))
(setq hostname (getenv "HOSTNAME"))
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
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)				;when creating new file, disable with c-f
(setq ido-file-extensions-order '(".org" ".txt" ".tex" ".py" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))

;; jabber
(add-to-list 'load-path lisp-directory)
(load "jabber_config.el")

;; org-mode
(add-to-list 'load-path (expand-file-name "cygdrive/c/cygwin64/home/Haml3t/org/lisp")) ;I dunno what this is supposed to be
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)
;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
;; Custom key bindings
(global-set-key (kbd "<f12>") 'org-agenda)
;; agenda files
;; (setq org-agenda-files '("cygdrive/c/cygwin64/home/Haml3t/org"))
;; TODO states
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
	      ("WAITING" ("WAITING" . t))
	      ("HOLD" ("WAITING") ("HOLD" . t))
	      (done ("WAITING") ("HOLD"))
	      ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
;; capture
(setq org-directory "/cygdrive/c/cygwin64/home/Haml3t/org")
;(setq org-default-notes-file "/cygdrive/c/cygwin64/home/Haml3t/org/refile.org")
(setq org-default-notes-file (concatenate 'string "/cygdrive/c/cygwin64/home/Haml3t/org/refile_" hostname ".org" ))
;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c") 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "TODO" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("r" "Respond" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
	      ("n" "Note" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("j" "Journal" entry (file+datetree "diary.org")
	       "* %?\n%U\n" :clock-in t :clock-resume t)
	      ("w" "org-protocol" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* TODO Review %c\n%U\n" :immediate-finish t)
	      ("m" "Meeting" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
	      ("p" "Phone call" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
	      ("h" "Habit" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
;; Remove empty LOGBOOK drawers on clock out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at "LOGBOOK" (point))))

(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)
;; refile
; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
				 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)


;;;; agenda stuff
(setq org-agenda-files (quote ("~/org")))
;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

;; Custom agenda command definitions
(setq org-agenda-custom-commands
      (quote (("N" "Notes" tags "NOTE"
	       ((org-agenda-overriding-header "Notes")
		(org-tags-match-list-sublevels t)))
	      ("h" "Habits" tags-todo "STYLE=\"habit\""
	       ((org-agenda-overriding-header "Habits")
		(org-agenda-sorting-strategy
		 '(todo-state-down effort-up category-keep))))
	      (" " "Agenda"
	       ((agenda "" nil)
		(tags "REFILE"
		      ((org-agenda-overriding-header "Tasks to Refile")
		       (org-tags-match-list-sublevels nil)))
		(tags-todo "-CANCELLED/!"
			   ((org-agenda-overriding-header "Stuck Projects")
			    (org-agenda-skip-function 'bh/skip-non-stuck-projects)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-HOLD-CANCELLED/!"
			   ((org-agenda-overriding-header "Projects")
			    (org-agenda-skip-function 'bh/skip-non-projects)
			    (org-tags-match-list-sublevels 'indented)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-CANCELLED/!NEXT"
			   ((org-agenda-overriding-header (concat "Project Next Tasks"
								  (if bh/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'bh/skip-projects-and-habits-and-single-tasks)
			    (org-tags-match-list-sublevels t)
			    (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(todo-state-down effort-up category-keep))))
		(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
			   ((org-agenda-overriding-header (concat "Project Subtasks"
								  (if bh/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'bh/skip-non-project-tasks)
			    (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
			   ((org-agenda-overriding-header (concat "Standalone Tasks"
								  (if bh/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'bh/skip-project-tasks)
			    (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-sorting-strategy
			     '(category-keep))))
		(tags-todo "-CANCELLED+WAITING|HOLD/!"
			   ((org-agenda-overriding-header (concat "Waiting and Postponed Tasks"
								  (if bh/hide-scheduled-and-waiting-next-tasks
								      ""
								    " (including WAITING and SCHEDULED tasks)")))
			    (org-agenda-skip-function 'bh/skip-non-tasks)
			    (org-tags-match-list-sublevels nil)
			    (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
			    (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
		(tags "-REFILE/"
		      ((org-agenda-overriding-header "Tasks to Archive")
		       (org-agenda-skip-function 'bh/skip-non-archivable-tasks)
		       (org-tags-match-list-sublevels nil))))
	       nil))))

(defun bh/org-auto-exclude-function (tag)
  "Automatic task exclusion in the agenda with / RET"
  (and (cond
	((string= tag "hold")
	 t)
	((string= tag "farm")
	 t))
       (concat "-" tag)))

(setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)

; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
			    ("@errand" . ?e)
			    ("@Muq Manor" . ?M)
			    ("@205" . ?2)
			    ("@CCNY" . ?C)
			    ("@GILGAMESH" . ?G)
			    (:endgroup)
			    ("WAITING" . ?w)
			    ("HOLD" . ?h)
			    ("e-NABLE" . ?E)
			    ("School" ?s)
			    ("SAM" ?S)
			    ("ORG" . ?O)
			    ("No Internet" . ?N)
			    ("NOTE" . ?n)
			    ("CANCELLED" . ?c)
			    ("FLAGGED" . ??))))

; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
; (setq org-agenda-tags-todo-honor-ignore-options t)

;; some stuff?
(defun org-summary-todo (n-done n-not-done)
       "Switch entry to DONE when all subentries are done, to TODO otherwise."
       (let (org-log-done org-log-states)   ; turn off logging
	 (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
;; end of org stuff
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
 '(org-agenda-file-regexp "[^.].*\\.org")
; '(org-agenda-files
 ;  (quote
  ;  ("/cygdrive/c/cygwin64/home/Haml3t/org/refile.org" "/cygdrive/c/cygwin64/home/Haml3t/org/e-NABLE.org" "/cygdrive/c/cygwin64/home/Haml3t/org/TODO.org")))
 '(org-journal-dir "~/org/journal")
 '(org-log-into-drawer t)
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
