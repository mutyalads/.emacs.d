(setq logging-server-port 9020)
(setq logging-server-host "127.0.0.1")
(defun logging-listen-start nil
  (interactive)
  (make-network-process
   :name "listen"
   :buffer "*listen*"
   :family 'ipv4
   :host   logging-server-host
   :service logging-server-port
   :sentinel 'logging-listen-sentinel
   :filter 'logging-listen-filter
   :nowait 't
   :server 't
   )
  )

(defun logging-listen-stop nil
  (interactive)
  (delete-process "listen")
  )

(setq log-record-format
      '((length u32r)
        (data vec (length))
        )
      )

(defun logging-listen-filter (proc string)

  (message string)

  )

(defun logging-listen-sentinel (proc msg)
  (when (string= msg "connection broken by remote peer\n")
    (message (format "client %s has quit" proc))))


(provide 'log-streamer)
