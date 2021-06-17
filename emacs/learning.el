(setq flowers '(violet buttercup))
(setq more-flowers (cons 'something (cons 'hana flowers)))
(setcar more-flowers 'fish)
kill-ring
(nth 2 kill-ring)

(set-face-background 'mode-line "#000")

max-lisp-eval-depth
max-spec‘max-specpdl-size’
max-specpdl-size

(defun testsearch (string)
  ""
  (interactive "s")
  (let ((searchresult (search-forward string)))
    (if (< searchresult (point-max))
        (message "found!")
      (message "not found")
    )
  ))

(defun gntest()
  ""
  (cons 'bird1 '())
  (cons )

(defun gntest ()
  "hell"
  (interactive)
  (save-restriction
    (widen)
    (save-excursion
      (message (buffer-substring 1 60))
      ))
  )

(defun multiply-by-seven (number)
  "Multiply by seven"
  (interactive "p")
  (message "the result is %d" (* 7 number)))

(point-min)
(buffer-substring 143 160)(stringp 'hello)
(let ((birch 3)
      pine
      fir
      (oak "some"))
  (message "here are %d variables with %s, %s, and %s value."
           birch pine fir oak))

(point-min)
(multiply-by-seven 5)
(if 0
    "hello")

(test)

(defun test (&optional number)
  "test"
  (if (and number (<= fill-column number))
      (message "in then")
    (message "in else"))
  )

fill-column
(beginning-of-buffer)

(test 70)


(defun simplified-end-of-buffer (buffer-name)
  "a fun"
  (interactive (list (read-string "Enter the buffer name: ")))
  (if (get-buffer buffer-name)
      (message "buffer exists!!")
    (message "buffer does not exists!")))
