(defun flash-n-reset ()
  (interactive)
  (when (not (get-buffer-process "*Flash-n-Reset*"))
    (start-process "flash-n-reset" "*Flash-n-Reset*" "python" "-u" "c:/Users/ths1/devel/scripts/flash-n-reset.py" "680328666" "c:/Users/ths1/devel/MESH/mesh-btle/build/examples/pb_mesh_client/pb_mesh_client.hex")
    (setq flash-n-reset-running t))

  (switch-to-buffer "*Flash-n-Reset*"))

(defun kill-flash-n-reset ()
  (interactive)
  (kill-buffer "*Flash-n-Reset*")
  )


(provide 'flash-n-reset)
