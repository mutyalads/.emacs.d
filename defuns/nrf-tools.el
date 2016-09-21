(defvar nrf-tools/scripts-path "C:/Users/ths1/devel/MESH/mesh-btle/scripts/")
(defvar nrf-tools/mbtle-path   "C:/Users/ths1/devel/MESH/mesh-btle/")
(defvar nrf-tools/s110-softdevice-path "c:/Users/ths1/devel/SDK/SDK_9.0.0_nrf51/components/softdevice/s110/hex/s110_softdevice.hex")

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

(defvar nrf-tools/com-port-script "C:/Users/ths1/devel/scripts/com/com.py")

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
  (shell-command ("python " nrf-tools/com-port-script " -l"))
  )

(defun nrf-tools/start-gdb-session (segger-id elf-file)
  (interactive "sSegger ID: \nsELF file: ")
  )


(setq device-list '("680662336" "680462258"))
(setq hexfile-list (list (concat nrf-tools/mbtle-path "build/examples/pb_mesh_server/pb_mesh_server_s110.hex")))
(setq master-device "680667429")
(setq master-hexfile (concat nrf-tools/mbtle-path "build/examples/serial/serial_s110.hex"))

(defun nrf-tools/multi-device-program (device-list hexfile-list &optional master-device master-hexfile)
  (async-shell-command (concat "python -u "
                               (concat nrf-tools/scripts-path "multiprog.py")
                               " --hexfiles " (s-join " " hexfile-list)
                               " --devices " (s-join " " device-list)
                               (if master-hexfile (concat " --master_hex " master-hexfile))
                               (if master-device (concat " --master_id " master-device))))
  )
(nrf-tools/multi-device-program device-list hexfile-list master-device master-hexfile)
(nrf-tools/multi-device-program (list "680462258") hexfile-list)

(defun nrf-tools/run-interactive-aci ()
  (interactive)
  (make-comint "InteractiveACI" "python" nil (concat nrf-tools/scripts-path "interactive_pyaci/interactive_console.py") "-d" "COM65")
  )
(setq hexfile-list '("a" "b c r"))
(add-to-list 'hexfile-list nil)

(defun nrf-tools/start-rtt-com ()
  (interactive)
  (setq segger-list (split-string (shell-command-to-string "nrfjprog -i")))
  (setq hexfile-list (split-string (shell-command-to-string (concat "c:/cygwin64/bin/find.exe " nrf-tools/mbtle-path "build/" " -iname *.hex"))))
  (add-to-list 'hexfile-list "")
  (setq segger-id (completing-read "SEGGER ID: " segger-list nil t))
  (setq hexfile (completing-read "Hexfile: " hexfile-list nil nil ))
  (setq buffer-name (concat (file-name-nondirectory hexfile) ":" segger-id))
  (make-comint buffer-name "python" nil "-u" rtt-com-path segger-id hexfile)
  (switch-to-buffer (concat "*" buffer-name "*"))
  )


(provide 'nrf-tools)
