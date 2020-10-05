(deftheme Lush_with_org_faces
  "Created 2020-09-10.")

(custom-theme-set-variables
 'Lush_with_org_faces
 '(case-fold-search t)
 '(custom-safe-themes (quote ("d9aa334b2011d57c8ce279e076d6884c951e82ebc347adbe8b7ac03c4b2f3d72" "fa3bdd59ea708164e7821574822ab82a3c51e262d419df941f26d64d015c90ee" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "1d50bd38eed63d8de5fcfce37c4bb2f660a02d3dff9cbfd807a309db671ff1af" "e1ecb0536abec692b5a5e845067d75273fe36f24d01210bf0aa5842f2a7e029f" "d5d2ab76985738c142adbe6a35dc51c8d15baf612fdf6745c901856457650314" "07e3a1323eb29844e0de052b05e21e03ae2f55695c11f5d68d61fb5fed722dd2" "7f791f743870983b9bb90c8285e1e0ba1bf1ea6e9c9a02c60335899ba20f3c94" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "774aa2e67af37a26625f8b8c86f4557edb0bac5426ae061991a7a1a4b1c7e375" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "1ed5c8b7478d505a358f578c00b58b430dde379b856fbcb60ed8d345fc95594e" "0ad7f1c71fd0289f7549f0454c9b12005eddf9b76b7ead32a24d9cb1d16cbcbd" "6231254e74298a1cf8a5fee7ca64352943de4b495e615c449e9bb27e2ccae709" "d71aabbbd692b54b6263bfe016607f93553ea214bc1435d17de98894a5c3a086" "3577ee091e1d318c49889574a31175970472f6f182a9789f1a3e9e4513641d86" "bc836bf29eab22d7e5b4c142d201bcce351806b7c1f94955ccafab8ce5b20208" "1c8171893a9a0ce55cb7706766e57707787962e43330d7b0b6b0754ed5283cda" "8c757da4837dc5fe6effe9b8d2b8fd27ff1013fc8c22acf069d54b96268b7e96" "0820d191ae80dcadc1802b3499f84c07a09803f2cb90b343678bdb03d225b26b" "1ba463f6ac329a56b38ae6ac8ca67c8684c060e9a6ba05584c90c4bffc8046c3" default)))
 '(debug-on-error t)
 '(helm-follow-mode-persistent t)
 '(helm-source-names-using-follow (quote ("BWD_reporting.org" "BWD_personal.org" "BWD_systems.org" "refile_THESEUS.org" "BWD.org" "BWD_special_projects.org" "org-refile" "BWD_NanoWear.org")))
 '(nil nil)
 '(org-agenda-auto-exclude-function (quote bh/org-auto-exclude-function))
 '(org-agenda-columns-add-appointments-to-effort-sum t)
 '(org-agenda-compact-blocks t)
 '(org-agenda-custom-commands (quote (("E" "PErsonal agenda and all TODOs" ((tags "HEADLINE+ACTIVE" ((org-agenda-overriding-header ""))) (agenda "" nil) (alltodo "" nil)) ((org-agenda-tag-filter-preset (quote ("+PERSONAL"))))) ("B" "BWD agenda & all TODOs" ((tags "HEADLINE+ACTIVE" ((org-agenda-overriding-header ""))) (agenda "" nil) (todo "NEXT" nil) (alltodo "" nil)) ((org-agenda-tag-filter-preset (quote ("+BWD" "-SOMEDAY_MAYBE" "-HOLD" "-CANCELLED")))) nil) (" " "Agenda and all TODOs" ((agenda "" nil) (alltodo "" nil)) ((org-agenda-tag-filter-preset (quote ("-SOMEDAY/MAYBE"))))) ("W" "WAITING items" todo "WAITING" nil) ("p" . "People agendas") ("pA" "Adriel Hernandez items" ((agenda "" nil) (tags-todo "AGENDA" ((org-agenda-overriding-header "Adriel agenda items"))) (tags-todo "\"-HOLD-CANCELLED/!\"" ((org-agenda-overriding-header "Adriel assigned/delegated projects") (org-agenda-skip-function (quote bh/skip-non-projects)) (org-tags-match-list-sublevels (quote indented)) (org-agenda-sorting-strategy (quote (category-keep))))) (todo "HOLD" ((org-agenda-overriding-header "Abel project hopper") (org-agenda-skip-function (quote bh/skip-non-projects)) (org-tags-match-list-sublevels (quote indented)))) (tags-todo "\"-CANCELLED/!\"" ((org-agenda-overriding-header "Adriel stuck projects") (org-agenda-skip-function (quote bh/skip-non-stuck-projects)) (org-tags-match-list-sublevels (quote indented)) (org-agenda-sorting-strategy (quote (category-keep))))) (todo "NEXT" ((org-agenda-overriding-header "NEXT actions with/for Abel"))) (todo "WAITING" ((org-agenda-overriding-header "Abel items I'm waiting on")))) ((org-agenda-tag-filter-preset (quote ("+Adriel_Hernandez")))) nil) ("pK" "Kary-Liz Maldonado items" ((agenda "" nil) (tags-todo "AGENDA" ((org-agenda-overriding-header "Kary agenda items"))) (tags-todo "\"-HOLD-CANCELLED/!\"" ((org-agenda-overriding-header "Kary assigned/delegated projects") (org-agenda-skip-function (quote bh/skip-non-projects)) (org-tags-match-list-sublevels (quote indented)) (org-agenda-sorting-strategy (quote (category-keep))))) (todo "HOLD" ((org-agenda-overriding-header "Kary project hopper") (org-agenda-skip-function (quote bh/skip-non-projects)) (org-tags-match-list-sublevels (quote indented)))) (tags-todo "\"-CANCELLED/!\"" ((org-agenda-overriding-header "Kary stuck projects") (org-agenda-skip-function (quote bh/skip-non-stuck-projects)) (org-tags-match-list-sublevels (quote indented)) (org-agenda-sorting-strategy (quote (category-keep))))) (todo "NEXT" ((org-agenda-overriding-header "NEXT actions with/for Kary"))) (todo "WAITING" ((org-agenda-overriding-header "Kary items I'm waiting on")))) ((org-agenda-tag-filter-preset (quote ("+KaryLiz_Maldonado")))) nil) ("pI" "Ivan Nunez items" ((tags-todo "AGENDA" ((org-agenda-overriding-header "Ivan agenda items"))) (todo "NEXT" ((org-agenda-overriding-header "NEXT actions with/for Ivan"))) (todo "WAITING" ((org-agenda-overriding-header "Ivan items I'm waiting on"))) (tags-todo "GOAL+ROOT" ((org-agenda-overriding-header "Goals committed to with Ivan")))) ((org-agenda-tag-filter-preset (quote ("+Ivan_Nunez" "-SOMEDAY_MAYBE" "-HOLD" "-CANCELLED")))) nil) ("pa" "Auralis items" ((tags-todo "AGENDA" ((org-agenda-overriding-header "Auralis agenda items"))) (todo "NEXT" ((org-agenda-overriding-header "NEXT actions with/for Auralis"))) (todo "WAITING" ((org-agenda-overriding-header "Auralis items I'm waiting on"))) (tags-todo "GOAL+ROOT" ((org-agenda-overriding-header "Goals committed to with Auralis")))) ((org-agenda-tag-filter-preset (quote ("+Auralis_Herrero" "-SOMEDAY_MAYBE")))) nil) ("pm" "My BWD agenda---without delegated tasks/projects" ((agenda "" nil) (todo "NEXT" nil) (alltodo "" nil)) ((org-agenda-tag-filter-preset (quote ("+BWD" "-delegated_project")))) nil) ("r" "Notes to refile" tags "REFILE" nil) ("d" "Documentation tasks" tags-todo "documentation" nil) ("n" "All next actions for active projects" todo "NEXT" ((org-agenda-tag-filter-preset (quote ("-SOMEDAY_MAYBE"))))) ("e" "Effort ranked least to most" todo "NEXT" ((org-agenda-sorting-strategy (quote (effort-up))))) ("P" "Projects" tags-todo "\"-HOLD-CANCELLED/!\"" ((org-agenda-overriding-header "Projects") (org-agenda-skip-function (quote bh/skip-non-projects)) (org-tags-match-list-sublevels (quote indented)) (org-agenda-sorting-strategy (quote (category-keep))))) ("s" "Stuck Projects" tags-todo "\"-CANCELLED/!\"" ((org-agenda-overriding-header "Stuck Projects") (org-agenda-skip-function (quote bh/skip-non-stuck-projects)) (org-agenda-sorting-strategy (quote (category-keep))))) ("S" "Someday/Maybe" tags "TODO=\"SOMEDAY/MAYBE\"" ((org-tags-match-list-sublevels (quote indented)))) ("mm" "Weekly management meeting" todo "" ((org-agenda-overriding-header "Weekly Management Meeting Agenda Items") (org-agenda-tag-filter-preset (quote ("+@weekly_management_meeting" "+AGENDA"))))))))
 '(org-agenda-deadline-faces (quote ((1.0 quote (:foreground "red")) (0.5 . org-upcoming-deadline) (0.0 . default))))
 '(org-agenda-include-diary t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday 1)
 '(org-agenda-sticky t)
 '(org-agenda-tags-column -120)
 '(org-agenda-time-grid (quote ((daily today require-timed) (800 1000 1200 1400 1600 1800 2000) "......" "----------------")))
 '(org-complete-tags-always-offer-all-agenda-tags t)
 '(org-default-notes-file "~/org/refile_THESEUS.org")
 '(org-export-backends (quote (ascii html icalendar latex taskjuggler)))
 '(org-habit-graph-column 100)
 '(org-protocol-default-template-key "w")
 '(org-tags-exclude-from-inheritance (quote ("PROJECT_ROOT" "SUBPROJECT_ROOT" "title" "ROOT" "crypt" "WAITING")))
 '(org-taskjuggler-default-global-properties "shift s40 \"Part time shift\" {
  workinghours wed, thu, fri off
}
flags tier1, note
")
 '(org-taskjuggler-default-reports (quote ("textreport report \"Plan\" {
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
 '(package-selected-packages (quote (gnuplot avy org-sticky-header doom-themes sqlup-mode helm-org-rifle fireplace visual-regexp rsense rainbow-delimiters lush-theme jabber iedit ido-hacks ido-gnus helm-bbdb gnus-spotlight gnorb ghci-completion ghc flymake-lua flycheck-hdevtools fish-mode f edit-server cl-generic bbdb-android autopair auto-complete-c-headers auto-complete-auctex auctex ace-window ace-jump-mode)))
 '(send-mail-function (quote smtpmail-send-it)))

(custom-theme-set-faces
 'Lush_with_org_faces
 '(rainbow-delimiters-depth-1-face ((t (:foreground "white"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "dark magenta"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "green"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "chocolate")))))

(provide-theme 'Lush_with_org_faces)
