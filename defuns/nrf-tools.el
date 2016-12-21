(setq nrf-tools/scripts-path "C:/dev/scripts/")
(setq nrf-tools/com-port-script "C:/dev/scripts/com/com.py")
(setq nrf-tools/mbtle-path   "c:/dev/mesh/verification/mod/mbtle/")
(setq nrf-tools/s110-softdevice-path "c:/dev/mesh/verification/mod/mbtle/lib/softdevice/s110/hex/s110_softdevice.hex")
(setq nrf-tools/s130-softdevice-path "c:/dev/mesh/verification/mod/mbtle/lib/softdevice/s130/hex/s130_nrf51_2.0.1_softdevice.hex")

(setq nrf-tools/error-code-list
      '("NRF_SUCCESS"
        "NRF_ERROR_SVC_HANDLER_MISSING"
        "NRF_ERROR_SOFTDEVICE_NOT_ENABLED"
        "NRF_ERROR_INTERNAL"
        "NRF_ERROR_NO_MEM"
        "NRF_ERROR_NOT_FOUND"
        "NRF_ERROR_NOT_SUPPORTED"
        "NRF_ERROR_INVALID_PARAM"
        "NRF_ERROR_INVALID_STATE"
        "NRF_ERROR_INVALID_LENGTH"
        "NRF_ERROR_INVALID_FLAGS"
        "NRF_ERROR_INVALID_DATA"
        "NRF_ERROR_DATA_SIZE"
        "NRF_ERROR_TIMEOUT"
        "NRF_ERROR_NULL"
        "NRF_ERROR_FORBIDDEN"
        "NRF_ERROR_INVALID_ADDR"
        "NRF_ERROR_BUSY")
      )
(setq nrf-tools/event-code-list
      '(
        "NRF_MESH_EVT_MESSAGE_RECEIVED: A message has been received."
        "NRF_MESH_EVT_TX_COMPLETE: Transmission completed."
        "NRF_MESH_EVT_IV_UPDATE_NOTIFICATION: An IV update was performed."
        "NRF_MESH_EVT_UNPROVISIONED_RECEIVED: Received an unprovisioned node beacon."
        "NRF_MESH_EVT_PROV_LINK_ESTABLISHED: Provisioning link established."
        "NRF_MESH_EVT_PROV_LINK_REQUEST: Provisioning link establishment request received."
        "NRF_MESH_EVT_PROV_LINK_CLOSED: Provisioning link lost."
        "NRF_MESH_EVT_PROV_OUTPUT_REQUEST: Provisioning output request."
        "NRF_MESH_EVT_PROV_INPUT_REQUEST: Provisioning input request."
        "NRF_MESH_EVT_PROV_STATIC_REQUEST: Provisioning static data request."
        "NRF_MESH_EVT_PROV_OOB_PUBKEY_REQUEST: OOB public key requested."
        "NRF_MESH_EVT_PROV_CAPS_RECEIVED: Provisionee capabilities received."
        "NRF_MESH_EVT_PROV_COMPLETE: Provisioning completed."
        "NRF_MESH_EVT_PROV_ECDH_REQUEST: ECDH calculation requested."
        "NRF_MESH_EVT_PROV_FAILED: Provisioning failed message received."
        "NRF_MESH_EVT_KEY_REFRESH_START: Key refresh procedure initiated. An SMGAP key transfer is to be expected."
        "NRF_MESH_EVT_KEY_REFRESH_END: Key refresh procedure completed."
        "NRF_MESH_EVT_DFU_REQ_RELAY: DFU request for this node to be the relay of a transfer."
        "NRF_MESH_EVT_DFU_REQ_SOURCE: DFU request for this node to be the source of a transfer."
        "NRF_MESH_EVT_DFU_START: DFU transfer starting."
        "NRF_MESH_EVT_DFU_END: DFU transfer ended."
        "NRF_MESH_EVT_DFU_BANK_AVAILABLE: DFU bank available."
        "NRF_MESH_EVT_DFU_FIRMWARE_OUTDATED: The device firmware is outdated, according to a trusted source."
        "NRF_MESH_EVT_DFU_FIRMWARE_OUTDATED_NO_AUTH: The device firmware is outdated, according to an un-authenticated source."
        "NRF_MESH_EVT_SAR_FAILED: SAR session failed."
        "NRF_MESH_EVT_PING: Ping event."
        "NRF_MESH_EVT_PONG: Pong event."
        "NRF_MESH_EVT_REMOTE_UUID: Remote UUID received event."
        "NRF_MESH_EVT_REMOTE_PROV_STATUS: Remote provisioning error. "
        )
      )
(setq nrf-tools/pb-mesh-server-event-code-list
      '(
        "PB_MESH_SERVER_EVENT_SCAN_START"
        "PB_MESH_SERVER_EVENT_SCAN_START_FILTER"
        "PB_MESH_SERVER_EVENT_SCAN_CANCEL"
        "PB_MESH_SERVER_EVENT_SCAN_REPORT_STATUS"
        "PB_MESH_SERVER_EVENT_LINK_OPEN"
        "PB_MESH_SERVER_EVENT_LINK_ESTABLISHED"
        "PB_MESH_SERVER_EVENT_LINK_CLOSE"
        "PB_MESH_SERVER_EVENT_LINK_CLOSED"
        "PB_MESH_SERVER_EVENT_LINK_STATUS"
        "PB_MESH_SERVER_EVENT_UNPROV_UUID"
        "PB_MESH_SERVER_EVENT_PACKET_TRANSFER"
        "PB_MESH_SERVER_EVENT_LOCAL_ACK"
        "PB_MESH_SERVER_EVENT_LOCAL_PACKET"
        "PB_MESH_SERVER_EVENT_TRANSFER_STATUS"
        "PB_MESH_SERVER_EVENT_TX_FAILED"
        )
      )

(defun nrf-tools/pb-mesh-server-event-code-to-string (event-code)
  (interactive "nEvent code number: ")
  (message (nth event-code nrf-tools/pb-mesh-server-event-code-list))
  )
(defun nrf-tools/error-code-to-string (error-code)
  (interactive "nError code number: ")
  (message (nth error-code nrf-tools/error-code-list))
  )

(defun nrf-tools/event-code-to-string (event-code)
  (interactive "nEvent code number: ")
  (message (nth event-code nrf-tools/event-code-list))
  )

(defun nrf-tools/nrfjprog (args)
  (interactive "snrfjprog: ")
  (shell-command (concat "nrfjprog " args))
  )

(defun nrf-tools/list-devices ()
  (interactive)
  (shell-command "nrfjprog -i")
  )

(defun nrf-tools/reset-all-devices ()
  (interactive)
  (dolist (device (split-string (shell-command-to-string "nrfjprog -i")))
    (nrf-tools/nrfjprog (concat "-s " device " -r"))
    )
  )

(defun nrf-tools/list-com-ports ()
  (interactive)
  (shell-command (concat "python " nrf-tools/com-port-script " -l"))
  )

(defun nrf-tools/start-gdb-session (segger-id elf-file)
  (interactive "sSegger ID: \nsELF file: ")
  )


;; (setq device-list '("680662336" "680462258"))
;; (setq hexfile-list (list (concat nrf-tools/mbtle-path "build/examples/pb_mesh_server/pb_mesh_server.hex")))
;; (setq master-device "680667429")
;; (setq master-hexfile (concat nrf-tools/mbtle-path "build/examples/serial/serial_s110.hex"))

(defun nrf-tools/multi-device-program (device-list hexfile-list &optional master-device master-hexfile)
  (async-shell-command (concat "python -u "
                               (concat nrf-tools/scripts-path "multiprog.py")
                               " --hexfiles " (s-join " " hexfile-list)
                               " --devices " (s-join " " device-list)
                               (if master-hexfile (concat " --master_hex " master-hexfile))
                               (if master-device (concat " --master_id " master-device))))
  )
;;(nrf-tools/multi-device-program device-list hexfile-list master-device master-hexfile)
;;(nrf-tools/multi-device-program (list "680462258") hexfile-list)

(defun nrf-tools/run-interactive-aci ()
  (interactive)
  (make-comint "InteractiveACI" "python" nil (concat nrf-tools/mbtle-path "scripts/" "interactive_pyaci/interactive_console.py") "-d" "COM11" "--no-logfile")
  )

(setq nrf-tools/rtt-buffers '())

(defun nrf-tools/send-rtt ()
  (interactive)
  (defvar send-rtt-history 'nil)
  (if (s-matches? "\\*[a-z_.]*hex:[0-9]*\\*" (buffer-name (current-buffer)))
      (setq buffer (buffer-name (current-buffer)))
    (setq buffer (completing-read "RTT Buffer: " nrf-tools/rtt-buffers nil t nil send-rtt-history))
    )
  (send-string buffer (concat (read-string "RTT Command: ") "\n"))
  )

(defun nrf-tools/reset-device ()
  (interactive)
  (defvar reset-device-history 'nil)
  (if (s-matches? "\\*[a-z0-9_.]*hex:[0-9]*\\*" (buffer-name (current-buffer)))
      (setq device (s-left 9 (s-right 10 (buffer-name (current-buffer)))))
    (setq device (completing-read "Device: " (split-string (shell-command-to-string "nrfjprog -i")) nil t nil reset-device-history))
    )
  (call-process-shell-command (concat "nrfjprog -s " device " -r &") nil 0)
  )

(defun nrf-tools/open-rtt-buffers ()
  (interactive)
  (delete-other-windows)
  (setq it 0)
  ;; (split-window-horizontally)
  ;; (other-window 1)
  (dolist (rtt-buffer nrf-tools/rtt-buffers)
    (if (= it 0)
        (switch-to-buffer rtt-buffer)
      (progn
        (if (= it 1)
            (split-window-vertically)
          (split-window-horizontally))
        (other-window 1)
        (switch-to-buffer rtt-buffer)
        )
      )
    (setq it (+ it 1))
    )
  (balance-windows)
  )

(defun nrf-tools/start-rtt-buffer (segger-id hexfile)
  (setq buffer-name (concat (file-name-nondirectory hexfile) ":" segger-id))
  (make-comint buffer-name "python" nil "-u" rtt-com-path segger-id hexfile)
  (add-to-list 'nrf-tools/rtt-buffers (concat "*" buffer-name "*"))
  )

(setq light-ctrl-slaves (list "680662336" "680667429" "680462258"))

(defun light-ctrl-test ()
  (interactive)
  (setq light-ctrl-master "681443724")
  (setq light-ctrl-slaves (list "680662336" "680667429" "680462258"))
  (nrf-tools/kill-rtt-buffers)
  (delete-other-windows)
  (dolist (light-ctrl-slave light-ctrl-slaves)
    (nrf-tools/start-rtt-buffer light-ctrl-slave (concat nrf-tools/mbtle-path "build/examples/light_ctrl/light_ctrl_slave.hex")))
  (nrf-tools/start-rtt-buffer light-ctrl-master (concat nrf-tools/mbtle-path "build/examples/light_ctrl/light_ctrl_master.hex"))
  (nrf-tools/open-rtt-buffers)
  )

(defun nrf-tools/start-rtt-com ()
  (interactive)
  (setq segger-list-w-com (split-string (shell-command-to-string "python c:/dev/scripts/jlink_comports_get.py") "\n"))
  (setq hexfile-list (split-string (shell-command-to-string (concat "C:/MinGW/msys/1.0/bin/find.exe " nrf-tools/mbtle-path "build/" " -iname *.hex"))))
  (setq segger-argument-list segger-list-w-com)
  (add-to-list 'segger-argument-list "All")
  (setq segger-id (completing-read "SEGGER ID: " segger-argument-list nil t))
  (setq hexfile (completing-read "Hexfile: " hexfile-list nil nil ))
  (if (s-equals? "All" segger-id)
      (dolist (segger-id segger-list)
        (nrf-tools/start-rtt-buffer segger-id hexfile)
        )
    (nrf-tools/start-rtt-buffer (subseq segger-id 0 9) hexfile)
    )
  ;; (nrf-tools/open-rtt-buffers)
  )


(defun nrf-tools/start-rtt-listener ()
  (interactive)
  (setq segger-list (split-string (shell-command-to-string "nrfjprog -i")))
  (setq segger-argument-list segger-list)
  (add-to-list 'segger-argument-list "All")
  (setq segger-id (completing-read "SEGGER ID: " segger-argument-list nil t))
  (if (s-equals? "All" segger-id)
      (dolist (segger-id segger-list)
        (nrf-tools/start-rtt-buffer segger-id nil)
        )
    (nrf-tools/start-rtt-buffer segger-id nil)
    )
  (nrf-tools/open-rtt-buffers)
  )

(defun nrf-tools/kill-rtt-buffers ()
  (interactive)
  (dolist (buffer nrf-tools/rtt-buffers)
    (kill-buffer buffer)
    )
  (setq nrf-tools/rtt-buffers '())
  )

(define-minor-mode nrf-mode
  "Minor mode for interacting with nRF5x devices"
  :lighter " nRF"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-c n l") 'nrf-tools/list-devices)
            (define-key map (kbd "C-c n c") 'nrf-tools/start-rtt-com)
            (define-key map (kbd "C-c n r") 'nrf-tools/reset-device)
            (define-key map (kbd "C-c n s") 'nrf-tools/send-rtt)
            map))

(add-hook 'comint-mode-hook (lambda () (nrf-mode)))



(provide 'nrf-tools)


