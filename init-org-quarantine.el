;; ical export stuff
(setq org-icalendar-combined-agenda-file "/home/haml3t/org.ics"
      org-icalendar-timezone "America/New_York"
      org-agenda-default-appointment-duration 30 ;; minutes
      org-icalendar-alarm-time 10 ;; minutes
      org-icalendar-include-todo nil;; t ;; make TODO events for non-done todos (?)
      org-icalendar-use-deadline '(event-if-todo todo-due)
      org-icalendar-use-scheduled '(event-if-todo))

(defun gtd-export-agendas-and-calendar ()
  "Export scheduled tasks or those with set deadlines (that aren't \"DONE\") to an iCalendar file too."
  (interactive)
;  (gtd-mark-completed-exported-tasks-as-done)
  (org-store-agenda-views)
  ;; Iterate through every headline in the agenda files, looking for not-DONE tasks that
  ;; are scheduled or have deadlines, storing their starting character position if found.
  (let ((calendar-hash (make-hash-table :test 'equal))
	(calendar-items nil))
    (org-map-entries (lambda ()
		       (let ((scheduledp (org-get-scheduled-time (point) nil))
			     (deadlinep (org-get-deadline-time (point) nil))
			     (notdonep (not (equal "DONE" (org-get-todo-state))))
			     (filename (org-entry-get (point) "FILE")))
			 (when (and (or scheduledp
					deadlinep)
				    notdonep)
			   (puthash filename (cons (point) (gethash filename calendar-hash)) calendar-hash))))
		     nil 'agenda)
    ;; Turn the hash into an alist
    (maphash (lambda (key value)
	       (add-to-list 'calendar-items (cons key value)))
	     calendar-hash)
    ;; Build iCalendar export file, restricting the items to only those just
    ;; found. `calendar-items' is an alist where key is a file name and value a list of
    ;; buffer positions pointing to entries that should appear in the calendar.
    (apply 'org-icalendar--combine-files calendar-items (org-agenda-files t)))
  (org-save-all-org-buffers))

(defun export-org-agenda-to-gcal-local ()
  (interactive)
  (if (boundp 'org-agenda-default-appointment-duration)
      (progn
	(org-save-all-org-buffers)
	(gtd-export-agendas-and-calendar)
       (message (shell-command-to-string "sleep 1; mv /home/haml3t/org.ics /home/haml3t/org/org.ics")))
    (message "you must run org-agenda before using this function")))
(add-hook 'org-capture-mode-hook
	  (lambda ()
	    (set (make-local-variable
		  'org-complete-tags-always-offer-all-agenda-tags)
		 t)))

(setq org-agenda-sticky t)		;set org agendas so they persist

;; in (custom-set-variables)
 '(org-agenda-custom-commands
   (quote
    (("N" "Notes" tags "NOTE"
      ((org-agenda-overriding-header "Notes")
       (org-tags-match-list-sublevels t)))
     ("h" "Habits" agenda ""
      ((org-tags-match-list-sublevels
	(quote indented))
       (org-agenda-span 1)
       (org-agenda-tag-filter-preset
	(quote
	 ("+HABIT")))
       (org-agenda-overriding-header "Habits")))
     (" " "Agenda"
      ((agenda ""
	       ((org-agenda-overriding-header "DISCIPLINE: 7-5 HARMONY: 5-10")))
       (tags "REFILE"
	     ((org-agenda-overriding-header "Tasks to Refile")
	      (org-tags-match-list-sublevels nil)))
       (tags-todo "-CANCELLED/!"
		  ((org-agenda-overriding-header "Stuck Projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-stuck-projects))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (tags-todo "-HOLD-CANCELLED/!"
		  ((org-agenda-overriding-header "Projects")
		   (org-agenda-skip-function
		    (quote bh/skip-non-projects))
		   (org-tags-match-list-sublevels
		    (quote indented))
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (tags-todo "-CANCELLED/!NEXT"
		  ((org-agenda-overriding-header
		    (concat "Project Next Tasks"
			    (if bh/hide-scheduled-and-waiting-next-tasks "" " (including WAITING and SCHEDULED tasks)")))
		   (org-agenda-skip-function
		    (quote bh/skip-projects-and-habits-and-single-tasks))
		   (org-tags-match-list-sublevels t)
		   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-sorting-strategy
		    (quote
		     (todo-state-down effort-up category-keep)))))
       (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
		  ((org-agenda-overriding-header
		    (concat "Project Subtasks"
			    (if bh/hide-scheduled-and-waiting-next-tasks "" " (including WAITING and SCHEDULED tasks)")))
		   (org-agenda-skip-function
		    (quote bh/skip-non-project-tasks))
		   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (tags-todo "-REFILE-CANCELLED-WAITING-HOLD/!"
		  ((org-agenda-overriding-header
		    (concat "Standalone Tasks"
			    (if bh/hide-scheduled-and-waiting-next-tasks "" " (including WAITING and SCHEDULED tasks)")))
		   (org-agenda-skip-function
		    (quote bh/skip-project-tasks))
		   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-with-date bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-sorting-strategy
		    (quote
		     (category-keep)))))
       (tags-todo "-CANCELLED+WAITING|HOLD/!"
		  ((org-agenda-overriding-header
		    (concat "Waiting and Postponed Tasks"
			    (if bh/hide-scheduled-and-waiting-next-tasks "" " (including WAITING and SCHEDULED tasks)")))
		   (org-agenda-skip-function
		    (quote bh/skip-non-tasks))
		   (org-tags-match-list-sublevels nil)
		   (org-agenda-todo-ignore-scheduled bh/hide-scheduled-and-waiting-next-tasks)
		   (org-agenda-todo-ignore-deadlines bh/hide-scheduled-and-waiting-next-tasks)))
       (tags "NOTE"
	     ((org-agenda-overriding-header "Notes")
	      (org-tags-match-list-sublevels
	       (quote indented))))
       (tags "-REFILE/"
	     ((org-agenda-overriding-header "Tasks to Archive")
	      (org-agenda-skip-function
	       (quote bh/skip-non-archivable-tasks))
	      (org-tags-match-list-sublevels nil))))
      nil)
     ("p" "Process" tags "+REFILE" nil)
     ("O" "Morning"
      ((agenda ""
	       ((org-agenda-tag-filter-preset
		 (quote
		  ("+MORNING")))
		(org-agenda-hide-tags-regexp "miracle_morning\\|HABIT\\|MORNING\\|miracle_morning_30Day_LTC")))
       (tags "+mantra-ROOT"
	     ((org-agenda-tag-filter-preset
	       (quote
		("+MORNING")))
	      (org-agenda-overriding-header "Mantras")
	      (org-agenda-hide-tags-regexp "self\\|MORNING\\|affirmations\\|mantra")))
       (tags "+aspirational_word|+aspirational_phrase-ROOT"
	     ((org-agenda-overriding-header "Aspire to be")
	      (org-agenda-tag-filter-preset
	       (quote
		("+MORNING"))))))
      nil nil)
     ("W" "Weekly Review"
      ((tags "QUOTE"
	     ((org-agenda-hide-tags-regexp "weekly_review\\|HABIT\\|NOTE\\|QUOTE\\|Meditations")))
       (agenda ""
	       ((org-agenda-skip-scheduled-if-done nil)
		(org-agenda-span 1)
		(org-agenda-tag-filter-preset
		 (quote
		  ("+weekly_review")))
		(org-agenda-hide-tags-regexp "HABIT\\|weekly_review\\|weekly_review_section"))))
      nil nil))))
