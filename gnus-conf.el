(setq user-mail-address "lhaml3t@gmail.com"
      user-full-name    "David Sugarman")

(require 'nnir)

(setq gnus-select-method
      '(nnimap "gmail"
	       (nnimap-address "imap.gmail.com")
	       (nnimap-server-port "imaps")
	       (nnimap-stream ssl)
	       )
      )

(setq smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]"
      )

;(add-to-list 'gnus-secondary-select-methods '(nntp "news.gnus.org"))
(require 'smtpmail)
(require 'starttls)

(defun gnutls-available-p ()
  "Function redefined in order not to use built-in GnuTLS support"
  nil)
(setq starttls-gnutls-program "gnutls-cli")
(setq starttls-use-gnutls t)
;(setq smtpmail-stream-type 'starttls)
;(setq smtpmail-smtp-server "posteo.de")
(setq smtpmail-smtp-service 587) ;;587(starttls) or 465(tls/ssl)
;(setq starttls-extra-arguments '("--priority" "NORMAL:%COMPAT"))

(setq smtpmail-stream-type 'ssl
      smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 465)

(setq send-mail-function 'smtpmail-send-it
      message-send-mail-function 'smtpmail-send-it)
;;;;;;;;; bbdb
(require 'bbdb)
(bbdb-initialize)
;(setq bbdb-print-tex-path "~/.emacs.d/bbdb/bbdb-3.1.2/tex")

(bbdb-initialize 'gnus)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(setq bbdb-file "~/.emacs.d/bbdb.db")
(setq bbdb/news-auto-create-p t)
(setq gnus-posting-styles
      '(((header "to" "lhaml3t@gmail.com")
	 (address "lhaml3t@gmail.com"))
	((header "to" "d.m.sugarman@gmail.com")
	 (address "d.m.sugarman@gmail.com"))
	((header "cc" "lhaml3t@gmail.com")
	 (address "lhaml3t@gmail.com"))
	((header "cc" "d.m.sugarman@gmail.com")
	 (address "d.m.sugarman@gmail.com"))))
