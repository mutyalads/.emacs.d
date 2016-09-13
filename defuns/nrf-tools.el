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

(defun nrf-tools/error-code-to-string (error-code)
  (interactive "nError code number: ")
  (message (nth error-code nrf-tools/error-code-list))
  )

(defun nrf-tools/nrfjprog (args)
  (interactive "snrfjprog: ")
  (shell-command (concat "nrfjprog " args))
  )

(defun nrf-tools/list-devices ()
  (interactive)
  (shell-command "nrfjprog -i")
  )

(provide 'nrf-tools)
