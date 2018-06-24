(setq user-mail-address "dsugarman@bwdefense.com"
      user-full-name "David Sugarman")

(setq gnus-select-method
      '(nnimap "BWDMail"
	       (nnimap-address "outlook.office365.com")
	       (nnimap-server-port "imaps") ; or 993
	       (nnimap-stream ssl)))

(setq smtpmail-smtp-server "smtp.office365.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")

;; Server name: smtp.office365.com
;; Port: 587
;; Encryption method: STARTTLS

    (setq send-mail-function		'smtpmail-send-it
	  message-send-mail-function	'smtpmail-send-it
	  smtpmail-smtp-server		"smtp.office365.com")
;; (defun my-message-mode-setup ()
;;        (setq fill-column 72)
;;        (turn-on-auto-fill))
;;      (add-hook 'message-mode-hook 'my-message-mode-setup)
