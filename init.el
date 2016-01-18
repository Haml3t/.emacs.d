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

(add-to-list 'load-path (concat (getenv "HOME") "/org/"))
; (load "org-mode")

;; keybindings
(setq lisp-directory (getenv "LISP"))
(setq hostname (getenv "HOSTNAME"))
(setq org-env-dir (getenv "ORG"))
(global-set-key (kbd "M-z") 'zap-up-to-char)

(column-number-mode)

(global-visual-line-mode t)

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

;; that wizard's org config
;; (load "org-mode.el")
;; org-mode
					; (add-to-list 'load-path
;; (expand-file-name "cygdrive/c/cygwin64/home/Haml3t/org/lisp")) ;I dunno what this is supposed to be
(require 'org-habit)
(setq org-src-tab-acts-natively t)
(setq org-src-fontify-natively t)
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)
;; Standard key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cb" 'org-iswitchb)
;; Custom key bindings
(global-set-key (kbd "<f12>") 'org-agenda)
;; TODO states
(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d@)")
	      (sequence "WAITING(w@/!)" "|" "CANCELLED(c@/!)" "SOMEDAY/MAYBE(s)"))))
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
	      ("WAITING" ("WAITING" . t))
	      ("SOMEDAY/MAYBE" ("SOMEDAY_MAYBE" . t))
	      (done ("WAITING"))
	      ("TODO" ("WAITING") ("CANCELLED") )
	      ("NEXT" ("WAITING") ("CANCELLED") ("SOMEDAY_MAYBE") )
	      ("DONE" ("WAITING") ("CANCELLED") ))))
;; capture
(require 'org-capture) ;; for set-tags hook
(setq org-directory org-env-dir)
(add-to-list 'org-capture-before-finalize-hook 'org-set-tags)
;(setq org-default-notes-file "/cygdrive/c/cygwin64/home/Haml3t/org/refile.org")
(setq org-default-notes-file (concatenate 'string "~/org/refile_" hostname ".org" ))
;; I use C-c c to start capture mode
(global-set-key (kbd "C-c c") 'org-capture)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "TODO" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("n" "Note" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
	      ("j" "Journal" entry (file+datetree "diary.org")
	       "* %?\n%U\n" :clock-in t :clock-resume t)
	      ("w" "org-protocol" entry (file (concatenate 'string "refile_" hostname ".org"))
	       "* TODO Review %c\n%U\n" :immediate-finish t)
	      )))

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
(setq org-user-agenda-files (list org-directory))
(setq org-agenda-files (list org-directory))
;; Do not dim blocked tasks
(setq org-agenda-dim-blocked-tasks nil)

;; Compact the block agenda view
(setq org-agenda-compact-blocks t)

(setq org-agenda-auto-exclude-function 'bh/org-auto-exclude-function)

; Tags with fast selection keys
(setq org-tag-alist (quote ((:startgroup)
			    ("@ERRAND" . ?E)
			    ("@MuqManor" . ?M)
			    ("@205" . ?2)
			    ("@CCNY" . ?C)
			    (:endgroup)
			    (:startgrouptag)
			    ("@computers")
			    (:grouptags)
			    ("@X220")
			    ("@BATTLESTATION")
			    (:endgrouptag)
			    (:startgrouptag)
			    ("@X220")
			    (:grouptags)
			    ("@AdminPC")
			    ("@DUBSTEP")
			    (:endgrouptag)
			    (:startgrouptag)
			    ("@BATTLESTATION")
			    (:grouptags)
			    ("@YGGDRASIL")
			    ("@WIZZARD")
			    (:endgrouptag)
			    ("@computers" . ?p)
			    ("@X220" . ?X)
			    ("BATTLESTATION" . ?B)
			    ("@DUBSTEP" . ?D)
			    ("@WIZZARD" . ?W)
			    ("@YGGDRASIL" . ?Y)
			    ("WAITING" . ?w)
			    ("HOLD" . ?h)
			    ("eNABLEatCCNY" . ?e)
			    ("HandyNYC")
			    ("School" . ?s)
			    ("KINETIC". ?K)
			    ("SAM" . ?S)
			    ("ORG" . ?O)
			    ("NoInternet" . ?N)
			    ("NOTE" . ?n)
			    ("CALL" . ?c)
			    ("PROJECT_ROOT" . ?P)
			    ("AGENDA" . ?a)
			    ("FLAGGED" . ??))))

; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
; (setq org-agenda-tags-todo-honor-ignore-options t)

;; stuck projects
(setq org-stuck-projects (quote ("" nil nil "")))

(defvar bh/hide-scheduled-and-waiting-next-tasks t)

(defun bh/toggle-next-task-display ()
  (interactive)
  (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

;; clock stuff
;;
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

;; Archive setup
(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")

(defun bh/skip-non-archivable-tasks ()
  "Skip trees that are not available for archiving"
  (save-restriction
    (widen)
    ;; Consider only tasks with done todo headings as archivable candidates
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max))))
	  (subtree-end (save-excursion (org-end-of-subtree t))))
      (if (member (org-get-todo-state) org-todo-keywords-1)
	  (if (member (org-get-todo-state) org-done-keywords)
	      (let* ((daynr (string-to-int (format-time-string "%d" (current-time))))
		     (a-month-ago (* 60 60 24 (+ daynr 1)))
		     (last-month (format-time-string "%Y-%m-" (time-subtract (current-time) (seconds-to-time a-month-ago))))
		     (this-month (format-time-string "%Y-%m-" (current-time)))
		     (subtree-is-current (save-excursion
					   (forward-line 1)
					   (and (< (point) subtree-end)
						(re-search-forward (concat last-month "\\|" this-month) subtree-end t)))))
		(if subtree-is-current
		    subtree-end ; Has a date in this month or last month, skip it
		  nil))  ; available to archive
	    (or subtree-end (point-max)))
	next-headline))))
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

(server-start)
(setq server-name "emacs-server")

;; org-protocol
;; (add-to-list 'load-path "~/")
					; (org-agenda)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (lush)))
 '(custom-safe-themes
   (quote
    ("0820d191ae80dcadc1802b3499f84c07a09803f2cb90b343678bdb03d225b26b" "1ba463f6ac329a56b38ae6ac8ca67c8684c060e9a6ba05584c90c4bffc8046c3" default)))
 '(nil nil t)
 '(org-agenda-auto-exclude-function (quote bh/org-auto-exclude-function))
 '(org-agenda-compact-blocks t)
 '(org-agenda-custom-commands
   (quote
    (("N" "Notes" tags "NOTE"
      ((org-agenda-overriding-header "Notes")
       (org-tags-match-list-sublevels t)))
     ("h" "Habits" tags-todo "STYLE=\"habit\""
      ((org-agenda-overriding-header "Habits")
       (org-agenda-sorting-strategy
	(quote
	 (todo-state-down effort-up category-keep)))))
     (" " "Agenda"
      ((agenda "" nil)
       (tags-todo "-CANCELLED/!NEXT"
		  ((org-agenda-overriding-header
		    (concat "Project Next Tasks"
			    (if bh/hide-scheduled-and-waiting-next-tasks "" " (including WAITING and SCHEDULED tasks)")))
		   (org-tags-match-list-sublevels t)
		   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-sorting-strategy
		    (quote
		     (todo-state-down effort-up category-keep)))))
       (tags-todo "-CANCELLED+WAITING|HOLD/!"
		  ((org-agenda-overriding-header
		    (concat "Waiting and Postponed Tasks"
			    (if bh/hide-scheduled-and-waiting-next-tasks "" " (including WAITING and SCHEDULED tasks)")))
		   (org-agenda-skip-function
		    (quote bh/skip-non-tasks))
		   (org-tags-match-list-sublevels nil)
		   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
       (tags "-REFILE/"
	     ((org-agenda-overriding-header "Tasks to Archive")
	      (org-agenda-skip-function
	       (quote bh/skip-non-archivable-tasks))
	      (org-tags-match-list-sublevels nil))))
      nil)
     ("p" "Projects"
      ((agenda "" nil)
       (stuck ""
	      ((org-agenda-overriding-header "Stuck Projects")))
       (tags-todo "PROJECT={.}+PROJECT_ROOT-SUBPROJECT={.}"
		  ((org-agenda-overriding-header "Projects")))
       (tags-todo "SUBPROJECT={.}+PROJECT_ROOT"
		  ((org-agenda-overriding-header "Subprojects"))))
      nil nil)
     ("r" "Organize"
      ((tags "REFILE"
	     ((org-agenda-overriding-header "Refile")))
       (stuck ""
	      ((org-agenda-overriding-header "Stuck Projects"))))
      nil nil)
     ("o" "Someday/Maybe" tags-todo "SOMEDAY_MAYBE"
      ((org-agenda-overriding-header "Someday/Maybe"))))))
 '(org-agenda-dim-blocked-tasks nil)
 '(org-agenda-files (quote ("/home/haml3t/org")))
 '(org-agenda-show-inherited-tags (quote always))
 '(org-agenda-use-tag-inheritance t)
 '(org-babel-load-languages (quote ((emacs-lisp . t) (C . t))))
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-journal-dir "~/org/journal")
 '(org-log-into-drawer t)
 '(org-stuck-projects
   (quote
    ("+PROJECT_ROOT+PROJECT={.}+SUBPROJECT={.}/-TODO=\"DONE\"-TODO=\"SOMEDAY/MAYBE\""
     ("NEXT" "NEXTACTION" "DONE")
     nil "")))
 '(org-tags-exclude-from-inheritance (quote ("PROJECT_ROOT")))
 '(org-tags-match-list-sublevels t)
 '(org-use-property-inheritance t)
 '(org-use-tag-inheritance t)
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

(setq browse-url-browser-function 'browse-url-generic browse-url-generic-program "lynx")
;; bbdb and gnus
(load "~/.emacs.d/gnus-conf.el")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
