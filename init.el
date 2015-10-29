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

;; org-mode
					; (add-to-list 'load-path (expand-file-name "cygdrive/c/cygwin64/home/Haml3t/org/lisp")) ;I dunno what this is supposed to be
(require 'org-habit)
(setq org-src-tab-acts-natively t)
(setq org-src-fontify-natively t)
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
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d@)")
	      (sequence "WAITING(w@/!)" "HOLD(h@/!)" "DELEGATED(D@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))
(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
	      ("WAITING" ("WAITING" . t))
	      ("HOLD" ("WAITING") ("HOLD" . t))
	      ("DELEGATED" ("DELEGATED" . t))
	      (done ("WAITING") ("HOLD"))
	      ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
	      ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))
;; capture
(setq org-directory org-env-dir)
;(setq org-default-notes-file "/cygdrive/c/cygwin64/home/Haml3t/org/refile.org")
(setq org-default-notes-file (concatenate 'string "~/org/refile_" hostname ".org" ))
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
(setq org-agenda-files (list org-directory))
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
			    ("@MuqManor" . ?M)
			    ("@205" . ?2)
			    ("@CCNY" . ?C)
			    ("@x220" . ?x)
			    (:endgroup)
			    ("WAITING" . ?w)
			    ("HOLD" . ?h)
			    ("e-NABLE" . ?E)
			    ("School" . ?s)
			    ("@YGGDRASIL" . ?y)
			    ("SAM" . ?S)
			    ("ORG" . ?O)
			    ("NoInternet" . ?N)
			    ("NOTE" . ?n)
			    ("CANCELLED" . ?c)
			    ("FLAGGED" . ??))))

; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

; For tag searches ignore tasks with scheduled and deadline dates
; (setq org-agenda-tags-todo-honor-ignore-options t)

;; stuck projects
(setq org-stuck-projects (quote ("" nil nil "")))

(defun bh/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
	  (subtree-end (save-excursion (org-end-of-subtree t)))
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(forward-line 1)
	(while (and (not has-subtask)
		    (< (point) subtree-end)
		    (re-search-forward "^\*+ " subtree-end t))
	  (when (member (org-get-todo-state) org-todo-keywords-1)
	    (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun bh/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
			      (point))))
    (save-excursion
      (bh/find-project-task)
      (if (equal (point) task)
	  nil
	t))))

(defun bh/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
	  (subtree-end (save-excursion (org-end-of-subtree t)))
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(forward-line 1)
	(while (and (not has-subtask)
		    (< (point) subtree-end)
		    (re-search-forward "^\*+ " subtree-end t))
	  (when (member (org-get-todo-state) org-todo-keywords-1)
	    (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
	(is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun bh/list-sublevels-for-projects-indented ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels 'indented)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun bh/list-sublevels-for-projects ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels t)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defvar bh/hide-scheduled-and-waiting-next-tasks t)

(defun bh/toggle-next-task-display ()
  (interactive)
  (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

(defun bh/skip-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
	  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		 (has-next ))
	    (save-excursion
	      (forward-line 1)
	      (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
		(unless (member "WAITING" (org-get-tags-at))
		  (setq has-next t))))
	    (if has-next
		nil
	      next-headline)) ; a stuck project, has subtasks but no next task
	nil))))

(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
	  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		 (has-next ))
	    (save-excursion
	      (forward-line 1)
	      (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
		(unless (member "WAITING" (org-get-tags-at))
		  (setq has-next t))))
	    (if has-next
		next-headline
	      nil)) ; a stuck project, has subtasks but no next task
	next-headline))))

(defun bh/skip-non-projects ()
  "Skip trees that are not projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (if (save-excursion (bh/skip-non-stuck-projects))
      (save-restriction
	(widen)
	(let ((subtree-end (save-excursion (org-end-of-subtree t))))
	  (cond
	   ((bh/is-project-p)
	    nil)
	   ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
	    nil)
	   (t
	    subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun bh/skip-non-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((bh/is-task-p)
	nil)
       (t
	next-headline)))))

(defun bh/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       (t
	nil)))))

(defun bh/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits, single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
	next-headline)
       ((and bh/hide-scheduled-and-waiting-next-tasks
	     (member "WAITING" (org-get-tags-at)))
	next-headline)
       ((bh/is-project-p)
	next-headline)
       ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
	next-headline)
       (t
	nil)))))

(defun bh/skip-project-tasks-maybe ()
  "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	   (next-headline (save-excursion (or (outline-next-heading) (point-max))))
	   (limit-to-project (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((bh/is-project-p)
	next-headline)
       ((org-is-habit-p)
	subtree-end)
       ((and (not limit-to-project)
	     (bh/is-project-subtree-p))
	subtree-end)
       ((and limit-to-project
	     (bh/is-project-subtree-p)
	     (member (org-get-todo-state) (list "NEXT")))
	subtree-end)
       (t
	nil)))))

(defun bh/skip-project-tasks ()
  "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       ((bh/is-project-subtree-p)
	subtree-end)
       (t
	nil)))))

(defun bh/skip-non-project-tasks ()
  "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	   (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((bh/is-project-p)
	next-headline)
       ((org-is-habit-p)
	subtree-end)
       ((and (bh/is-project-subtree-p)
	     (member (org-get-todo-state) (list "NEXT")))
	subtree-end)
       ((not (bh/is-project-subtree-p))
	subtree-end)
       (t
	nil)))))

(defun bh/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       (t
	nil)))))

(defun bh/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (bh/is-subproject-p)
	nil
      next-headline)))

;; clock stuff
;;
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
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

(setq bh/keep-clock-running nil)

(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
	   (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
	   (bh/is-project-p))
      "TODO"))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/punch-in (arg)
  "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
	     (tags (org-with-point-at marker (org-get-tags-at))))
	(if (and (eq arg 4) tags)
	    (org-agenda-clock-in '(16))
	  (bh/clock-in-organization-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
      ; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
	  (org-clock-in '(16))
	(bh/clock-in-organization-task-as-default)))))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
	(widen)
	(while (and (not parent-task) (org-up-heading-safe))
	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	    (setq parent-task (point))))
	(if parent-task
	    (org-with-point-at parent-task
	      (org-clock-in))
	  (when bh/keep-clock-running
	    (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/organization-task-id 'marker)
    (org-clock-in '(16))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
	     (not org-clock-clocking-in)
	     (marker-buffer org-clock-default-task)
	     (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

(require 'org-id)
(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))

(defun bh/clock-in-last-task (arg)
  "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
	 (cond
	  ((eq arg 4) org-clock-default-task)
	  ((and (org-clock-is-active)
		(equal org-clock-default-task (cadr org-clock-history)))
	   (caddr org-clock-history))
	  ((org-clock-is-active) (cadr org-clock-history))
	  ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
	  (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

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
 '(org-babel-load-languages (quote ((emacs-lisp . t) (C . t))))
 '(org-journal-dir "~/org/journal")
 '(org-log-into-drawer t)
 '(org-stuck-projects
   (quote
    ("+TODO=\"TODO\"/-somedayMaybe-DONE"
     ("NEXT" "NEXTACTION")
     ("somedayMaybe")
     "")))
 '(org-use-property-inheritance t)
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
 '(org-agenda-dimmed-todo-face ((t (:foreground "grey50")))))
