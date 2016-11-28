(setq rtt-com-path "c:/Users/ths1/devel/scripts/rtt_com/rtt_com.py")

(defun send-rtt-command (process cmd)
  (process-send-string process cmd))

(defun start-rtt-com (buffer-name device-id hexfile)
  (make-comint buffer-name
               "python" nil "-u" rtt-com-path device-id hexfile)
  )
;; (defun start-rtt-com (device-id hexfile)
;;   (start-process-shell-command (concat "RTT-COM-" device-id)
;;                                (concat "RTT-COM-" device-id)
;;                                "python"
;;                                "-u"
;;                                rtt-com-path
;;                                device-id
;;                                hexfile)
;;   )

(require 'ansi-color)

(defadvice display-message-or-buffer (before ansi-color activate)
  "Process ANSI color codes in shell output."
  (let ((buf (ad-get-arg 0)))
    (and (bufferp buf)
         (string= (buffer-name buf) "*Shell Command Output*")
         (with-current-buffer buf
           (ansi-color-apply-on-region (point-min) (point-max))))))

(setq build-folder "C:/Users/ths1/devel/MESH/mesh-btle/build/")

(defun start-pb-mesh-client (segger-id)
  (interactive)
  (setq buffer-name (concat "serial.hex:" segger-id))
  (start-rtt-com buffer-name segger-id (concat build-folder "examples/pb_mesh_client/51_pb_mesh_client.hex"))
  (setq buffer-name (concat "*" buffer-name "*"))
  (add-to-list 'rtt-com/buffers buffer-name)
  (switch-to-buffer buffer-name)
  )

(defun start-pb-mesh-server (segger-id)
  (interactive)
  (setq buffer-name (concat "pb_mesh_server.hex:" segger-id))
  (start-rtt-com buffer-name segger-id (concat build-folder "examples/pb_mesh_server/51_pb_mesh_server.hex"))
  (setq buffer-name (concat "*" buffer-name "*"))
  (add-to-list 'rtt-com/buffers buffer-name)
  (switch-to-buffer buffer-name)
  )

(defun send-rtt-command-interactive ()
  (interactive)
  (send-rtt-command "*PB-MESH-CLIENT*" (concat (read-string "Send RTT command: ") "\n"))
  )

;; (send-rtt-command (concat "*RTT-COM-" client-id "*") "p\n")

;; (shell-command "nrfjprog -i" "*compilation*")
;; (shell-command "nrfjprog -s 680328666 -r")
;; (shell-command "nrfjprog -s 680217338 -r")
;; (shell-command "nrfjprog -s 680387005 -r")

;; (setq server-id "680667429")
;; (setq client-id "680387005")
;; (setq provisionee-id "680662336")

;; (setq server-id "680387005")
;; (setq client-id "680328666")
;; (setq provisionee-id "680217338")
;; (setq provisionee-id "680386516")

;; (delete-other-windows)

;; 680662336
;; 680462258
;;(start-rtt-buffer "680662336" "c:/Users/ths1/devel/MESH/mesh-btle/build/examples/pb_mesh_server/pb_mesh_server.hex")
;;(start-rtt-buffer "680462258" "c:/Users/ths1/devel/MESH/mesh-btle/build/examples/pb_mesh_server/pb_mesh_server.hex")
(defun start-rtt-buffer (segger-id hexfile)
  (interactive "sSegger ID: \nsHexfile: ")
  (start-rtt-com
   (concat (file-name-nondirectory hexfile) ":" segger-id) segger-id hexfile)
  (switch-to-buffer (concat "*" (file-name-nondirectory hexfile) ":" segger-id "*"))
  )

(defun volatile-kill-buffer (buffer)
  (switch-to-buffer buffer)
  (set-buffer-modified-p nil)
  (kill-buffer buffer)
  )

(defun get-segger-ids ()
  "Get a list of segger IDs of all devices connected."
  (interactive)
  (split-string (shell-command-to-string "nrfjprog -i"))
  )

(dolist (item (split-string (shell-command-to-string "nrfjprog -i")))
        (message  "Segger ID: %s" item))


;; (start-pb-mesh-server segger-id)
(setq rtt-com/buffers 'nil)
(defun kill-rtt-buffers ()
  (interactive)
  (dolist (buffer rtt-com/buffers)
    (volatile-kill-buffer buffer))
  (setq rtt-com/buffers 'nil)
  (delete-other-windows)
  )
;; (kill-rtt-buffers)

(defun start-pb-mesh-test ()
  (interactive)
  (if rtt-com/buffers
      (kill-rtt-buffers)
    )
  (setq rtt-com/segger-ids (get-segger-ids))
  (setq it 0)
  (dolist (segger-id rtt-com/segger-ids)
    (when (= it 0)
      (start-pb-mesh-client segger-id)
      (split-window-horizontally))
    (when (> it 0)
      (start-pb-mesh-server segger-id)
      (when (< it (1- (length rtt-com/segger-ids)))
        (split-window-vertically))
      )
    (if (eq it 4)
        (progn
          (balance-windows)
          (make-frame)
          ;; (other-frame 1)
          ;; (split-window-horizontally)
          )
      (other-window 1)
      )
    (setq it (1+ it))
    )
  (balance-windows))

;; (comint-run "C:/Users/ths1/devel/MESH/mesh-btle/build/examples/pb_mesh_client/pb_mesh_client.hex")
(define-derived-mode fundamental-ansi-mode fundamental-mode "fundamental ansi"
  "Fundamental mode that understands ansi colors."
  (require 'ansi-color)
  (ansi-color-apply-on-region (point-min) (point-max)))

(add-to-list 'comint-output-filter-functions 'ansi-color-process-output)
(provide 'rtt-com)
