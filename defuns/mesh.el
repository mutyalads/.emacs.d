(defvar mesh/verification-path "c:/Users/ths1/devel/MESH/verification/")

(defun mesh/run-build-script (args)
  (start-process-shell-command "Mesh Build" "*Shell Command Output*" (concat "cd " mesh/verification-path " && python fwk/build.py " args))
  (switch-to-buffer-other-window "*Shell Command Output*")
  )


(defun mesh/run-test-script (args)
  (interactive "sArgs: ")
  (start-process-shell-command "Mesh Test" "*Mesh Test*" (concat "cd " mesh/verification-path " && python fwk/sysTest.py " args))
  (switch-to-buffer "*Mesh Test*")
  (erase-buffer)
  )

;; (defun mesh/run-test-script (args)
;;   (start-process-shell-command "Mesh Test" "*Shell Command Output*" (concat "cd " mesh/verification-path " && python fwk/sysTest.py " args))
;;   (switch-to-buffer-other-window "*Shell Command Output*")
;;   )

(defun mesh/build-mbtle ()
  (interactive)
  (mesh/run-build-script "--repo mbtle ver --AccAdd 3")
  )

(defun mesh/run-test (testname)
  (interactive "sRun test: ")
  (mesh/run-test-script (concat "-t " testname))
  )

;(mesh/build-mbtle)

(defun mesh/run-python(args)
  (interactive "sPython args: ")
  (start-process-shell-command "Mesh Test" "*Mesh Test*" (concat "cd " mesh/verification-path " && python " args))
  (switch-to-buffer "*Mesh Test*")
  (erase-buffer)
  )


(provide 'mesh)
