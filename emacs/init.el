;; called from init.sh

;; generate init.el file in .emacs.d folder
(org-babel-tangle)

(defun gn/init ()
  "initialize emacs!"
  (gn/create-env))

(defun gn/create-env ()
  "creates env.el file which is used for environment variables"
  (unless (file-exists-p "~/config/emacs/env.el")
    (write-region ";; You can add environment variables in this file" nil "~/config/emacs/env.el")))

(gn/init)
