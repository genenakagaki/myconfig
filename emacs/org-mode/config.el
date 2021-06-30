(use-package org)
(require 'org-id)

(setq org-return-follows-link t)

(add-hook 'org-mode-hook (lambda ()
                           ;; make the lines in the buffer wrap around the edges of the screen.
                           (visual-line-mode)
                           (org-indent-mode)))
(use-package valign)

(gn/leader-nvmap org-mode-map
  "e" 'org-ctrl-c-ctrl-c
  "bb" 'gn/org-open-scope
  )

(gn/leader-nmap org-mode-map
  "i" '(:ignore i :which-key "insert")
  "id" '(:ignore id :which-key "date")
  "id SPC" 'org-time-stamp
  "idi" 'org-time-stamp-inactive
  "idd" 'org-deadline
  "ids" 'org-schedule
  "il" 'org-insert-link
  "ii" 'org-id-get-create
  "it" 'org-insert-structure-template
  "iT" 'gn/org-insert-template
  "D" 'org-cut-subtree
  "y" '(:ignore y :which-key "yank")
  "yi" 'org-id-copy
  "yl" 'org-store-link
  "t" '(:ignore t :which-key "todo")
  "t SPC" 'org-todo
  "tn" 'gn/next-todo
  "tp" 'org-priority
  "T" '(:ignore T :which-key "toggle") 
  "Ti" 'org-toggle-inline-images
  "Tl" 'org-toggle-link-display
  "s" '(:ignore v :which-key "screen")
  "sl" 'org-toggle-link-display
  "si" 'org-toggle-inline-images
  "s" '(:ignore s :which-key "src")
  "st" 'org-babel-tangle
  "/" 'org-sparse-tree
  )

(general-define-key
 :states '(normal visual insert)
 :keymaps 'org-mode-map
 "C-<return>" 'gn/org-insert-new-item
 "C-h" 'gn/org-promote-tree
 "C-S-h" 'gn/org-promote
 "C-j" 'gn/org-move-tree-down
 "C-k" 'gn/org-move-tree-up
 "C-l" 'gn/org-demote-tree
 "C-S-l" 'gn/org-demote
 )

(general-nvmap
  :keymaps 'org-mode-map
  "J" 'org-next-visible-heading
  "K" 'org-previous-visible-heading)

(define-minor-mode gn/org-movement-mode
  "Minor mode for org movements"
  :lighter " gn/org-movement"
  )

;(general-nvmap org-mode-map
;  "C-k" 'org-previous-visible-heading
;  "C-j" 'org-next-visible-heading
;  )

(defun gn/org-insert-new-item ()
  "Inserts a new item (headings, checkboxes, or bullets)"
  (interactive)
  (evil-append-line 0)
  (cond ((org-at-heading-p) (org-insert-heading-respect-content)) 
        ((org-at-item-checkbox-p) (org-insert-todo-heading nil))
        ((org-at-item-p) (org-insert-item))))

(defun gn/org-promote ()
  "Moves item position (headings, checkboxes, or bullets)"
  (interactive)
  (cond ((org-at-heading-p) (org-do-promote))
        ((org-at-item-p) (org-outdent-item))))

(defun gn/org-promote-tree ()
  "Moves item position (headings, checkboxes, or bullets)"
  (interactive)
  (cond ((org-at-heading-p) (org-promote-subtree))
        ((org-at-item-p) (org-outdent-item-tree))))

(defun gn/org-demote ()
  "Demotes item (headings, lists)"
  (interactive)
  (cond ((org-at-heading-p) (org-do-demote))
        ((org-at-item-p) (org-indent-item))))

(defun gn/org-demote-tree ()
  "Demotes item (headings, lists)"
  (interactive)
  (cond ((org-at-heading-p) (org-demote-subtree))
        ((org-at-item-p) (org-indent-item-tree))))

(defun gn/org-demote-tree ()
  "Demotes item (headings, lists)"
  (interactive)
  (cond ((org-at-heading-p) (org-demote-subtree))
        ((org-at-item-p) (org-indent-item-tree))))

(defun gn/org-move-tree-up ()
  "Moves item up (headings, lists)"
  (interactive)
  (cond ((org-at-heading-p) (org-move-subtree-up))
        ((org-at-item-p) (org-move-item-up))))

(defun gn/org-move-tree-down ()
  "Moves item down (headings, lists)"
  (interactive)
  (cond ((org-at-heading-p) (org-move-subtree-down))
        ((org-at-item-p) (org-move-item-down))))

(defun gn/org-open-scope ()
  "Open subtree or block in new buffer"
  (interactive)
  (cond ((org-in-src-block-p) (org-edit-special))
        ((org-at-heading-p) (org-tree-to-indirect-buffer))))

(defvar gn/inbox-path "~/myworkflow/inbox.org"
  "Path to the inbox file")

(defvar gn/tasks-path "~/myworkflow/tasks.org"
  "Path to the tasks file")

(defvar gn/reference-path "~/myworkflow/reference.org"
  "Path to the reference file")

(defvar gn/incubator-path "~/myworkflow/incubator.org"
  "Path to the incubator file")

(defun gn/workflow-open-tasks ()
  "Open tasks file."
  (interactive)
  (find-file gn/tasks-path))

(defun gn/workflow-open-inbox ()
  "Open inbox file."
  (interactive)
  (find-file gn/inbox-path))

(defun gn/workflow-open-reference ()
  "Open reference file."
  (interactive)
  (find-file gn/reference-path))

(setq org-capture-templates
      '(("i" "Inbox" entry (file gn/inbox-path)
         "* %?")
        ))

(setq org-refile-use-outline-path 'file)

(setq org-refile-targets
      '((gn/inbox-path :level . 0)
        (gn/tasks-path :level . 0)
        (gn/reference-path :level . 0)
        (gn/incubator-path :level . 0)))

(general-nmap org-capture-mode-map
  [remap save-buffer] 'org-capture-finalize
  [remap kill-current-buffer] 'org-capture-kill)

(defun gntodo/add-todo (todo-name)
  ""
  (save-excursion
    (org-insert-todo-heading-respect-content)
    (gn/org-demote)
    (insert todo-name)
    ))

(defun gntodo/clarify-project-issue ()
  "Clarify project_issue task type"
  (org-set-tags "project_issue")
  (if (y-or-n-p "Can you delegate it?")
      (progn (org-set-tags "delegate")
             (gntodo/add-todo "Write down delegatee")
             (gntodo/add-todo "Delegate task"))
    (gntodo/add-todo "Plan task"))
  (gn/insert-heading-content "Why this issue needs to be addressed:
- "))

(defun gntodo/clarify-meeting ()
  "Clarify meeting task type"
  (org-set-tags "meeting")
  (gntodo/add-todo "Prepare for meeting")
  (gn/insert-heading-content "What this meeting is about:
- "))

(defun gntodo/clarify-reference ()
  "Clarify reference task type"
  (org-set-tags "reference")
  (gntodo/add-todo "Organize reference")
  (gntodo/add-todo "Add entry to reference file")
  (gn/insert-heading-content "Why this reference is needed:
- "))

(defun gntodo/clarify-future-project ()
  "Clarify future_project task type"
  (org-set-tags "future_project")
  (gntodo/add-todo "Write down project idea")
  (gntodo/add-todo "Add entry to incubator file")
  (gn/insert-heading-content "How this might be a future project:
- "))

(defvar gntodo/task-type
  '((tag-name "project_issue"
               clarify-function gntodo/clarify-project-issue)
    (tag-name "meeting"
               clarify-function gntodo/clarify-meeting)
    (tag-name "reference"
               clarify-function gntodo/clarify-reference)
    (tag-name "future_project"
               clarify-function gntodo/clarify-future-project)
    ))

(defun gntodo/clarify-inbox-item ()
  "Clarify item"
  (interactive)
  (when (not (org-on-heading-p))
    (error "You need to be on a heading to Clarify an item."))

  (if (y-or-n-p "Is item a task you can complete in 2 min?")
      (message "DO IT NOW!")
    (progn
      (when (y-or-n-p "Is item related to a project?")
        (org-set-tags-command))
      (->> gntodo/task-type
           (--map (plist-get it 'tag-name))
           (ivy-read "Choose type of item: ") 
           ((lambda (chosen-tag-name) 
              (-> gntodo/task-type
                  (->> (--first (string= chosen-tag-name (plist-get it 'tag-name))))
                  (plist-get 'clarify-function)
                  (funcall)
                  )))
           )
      ))
  (widen))

(defun gn/clarify-actionable-item ()
  ""
  (interactive)
  (if (y-or-n-p "Can you complete it in 2 min?")
      (progn (message "DO IT NOW!")
             (gn/next-todo)
             (gn/next-todo))
    (if (y-or-n-p "Can you delegate it?")
        (progn (gn/clarify-reason "Why does the task have to be done?")
               (org-set-tags ":delegate:")
               (gn/insert-subheading "TODO Delegate task")
               (org-previous-visible-heading 1)
               (org-priority))
      (progn (gn/clarify-reason "Why does the task have to be done?")
             (org-set-tags-command)
             (gn/insert-subheading "TODO Plan task")
             (org-previous-visible-heading 1)
             (org-priority)))))

(defun gn/clarify-nonactionable-item ()
  ""
  (interactive)
  (if (y-or-n-p "Do you need it for reference?")
      (gn/clarify-reason "Why do you need it?")
    (if (y-or-n-p "Is it potentially a future project?")
        (gn/clarify-reason "Why do you ")
      ())
    ()))

(defun gn/clarify-reason (question)
  "Prompt for a reason and inserts both question and answer under the heading"
  (interactive)
  (->> (read-string question)
    (concat question "\n- ")
    (gn/insert-heading-content)))

(defun gn/insert-heading-content (content)
  "Insert content under heading"
  (when (not (org-on-heading-p))
    (error "You need to be on a heading for this command."))
  (move-end-of-line 1)
  (insert (concat "\n" content)))

(defun gn/insert-subheading (heading-name)
  "Insert subheading under current heading"
  (interactive)
  (when (not (org-on-heading-p))
    (error "You need to be on a heading for this command."))
  (org-narrow-to-subtree)
  (let ((current-level (org-current-level)))
    (goto-char (point-max))
    (-> (+ current-level 1)
      (-repeat "*")
      (->> (--reduce (format "%s%s" acc it)))
      ((lambda (subheading-stars) (concat "\n" subheading-stars " " heading-name)))
      (insert)))
  (widen))


(defun gnorg/goto-toplevel-heading ()
  "Go to toplevel heading"
  (interactive)
  (outline-heading 100))

(setq org-todo-keywords
      '((sequence "TODO" "DOING" "|" "DONE")
        (sequence "ON-HOLD(o)" "SCHEDULED(s)" "WAITING(w)" "CANCELLED(c)")))

(defun gn/next-todo-string (current-todo)
  "Returns next todo"
  (cond ((or (equal current-todo "TODO")
             (equal current-todo "ON-HOLD")
             (equal current-todo "SCHEDULED")
             (equal current-todo "WAITING"))
         "DOING")
        ((equal current-todo "DOING")
         "DONE")))

(defun gn/current-todo-string ()
  (if (org-entry-is-todo-p)
      (-> (org-get-todo-state)
        substring-no-properties)
    nil))

(defun gn/next-todo ()
  "Toggle TODO states"
  (interactive)
  (org-todo (if (org-entry-is-todo-p) 
                (gn/next-todo-string (gn/current-todo-string))
              "TODO"))
  (if (equal (gn/current-todo-string) "DOING")
      (org-clock-in)
    (org-clock-out)))

(defun gn/current-task ()
  "Show current task"
  (interactive)
  (let ((current-task-point (gn/current-task-point)))
    (if (numberp current-task-point)
        (progn (gn/workflow-open-todo)
               (goto-char (current-task-point))
               (org-narrow-to-subtree))
      (error "Current task not found."))))

(defun gn/current-task-point ()
  "Returns point of current task"
  (save-window-excursion
    (gn/workflow-open-todo)
    (widen)
    (goto-char (point-min))
    (search-forward-regexp "^\* DOING " nil t)
    (beginning-of-line)
    (if (eq (point) (point-min))
        nil
      (point))))

(defun gn/next-task ()
  ""
  (interactive)
  (gn/workflow-open-inbox)
  (goto-char (point-min))
  (search-forward-regexp "^\* ")

  )

(evil-set-initial-state 'org-agenda-mode 'normal)

(setq org-agenda-files '("~/myworkflow/todo.org"))
(setq org-agenda-log-mode-items '(state))

(general-nmap org-src-mode-map
  [remap save-buffer] 'org-edit-src-exit
  [remap kill-current-buffer] 'org-edit-src-abort)

;; Don't confirm when evaluating src blocks
(setq org-confirm-babel-evaluate nil)

(defvar gn/org-template-path "~/todo/templates.org")

(defun gn/org-template ()
  ""
  (with-temp-buffer
    (insert-file-contents gn/org-template-path)
    (org-mode)
    (org-element-parse-buffer)))

(defun gn/org-template-headlines (max-headline-level)
  "Get org template headlines

MAX-HEADLINE-LEVEL is an integer that specifies how deep to search headlines"
  (org-element-map (gn/org-template) 'headline
    (lambda (h)
      (when (<= (org-element-property :level h)
                max-headline-level)
        h))))

(defvar gn/org-max-headline-level 2)

(defun gn/org-insert-template ()
  (interactive)
  (let ((headlines (gn/org-template-headlines gn/org-max-headline-level)))
    (->> headlines
         (-map (lambda
                 (headline)
                 (org-element-property :raw-value headline)))
         (completing-read "Select a template: ")
         ((lambda (headline-raw-value)
            (-first (lambda
                      (headline)
                      (string= headline-raw-value
                               (org-element-property :raw-value headline)))
                    headlines)))
         (org-element-interpret-data)
         ((lambda (headline)
            (save-excursion (insert headline)))))
    )
  )

(require 'ox-html)

(org-export-define-derived-backend 'gn-blog-post-vue 'html
  :options-alist '((:html_doctype "HTML_DOCTYPE" "HTML5" t)
                   (:html_container "HTML_CONTAINER" "div" t))
  :translate-alist '((template . gn/org-blog-post-template)))

                                        ;(org-publish-project "gn-publish" t)


                                        ;'(setq gn/test )
                                        ;'"./\\(?=.+?.\\(png\\|jpg\\)\\)" 
                                        ;'(replace-regexp-in-string "./\\(?=.+?png\\)" "something" "<img src='./tessting.png'")

(defun gn/org-blog-post-template (contents info)
  "Template for org vue export"
  (concat
   "<template>\n"
   "<div>\n"
   contents
   "</div>\n"
   "</template>\n"
   "<script>\n"
   "export default {\n"
   (format "title: '%s',\n"
           (org-export-data (plist-get info :title) info))
   "meta: [\n"
   (format "{name: 'description', content: '%s'},"
           (org-export-data (plist-get info :description) info))
   "],\n"
   "}\n"
   "</script>\n"
   ))

(defun gn/org-publish-as-blog-post
    (&optional async subtreep visible-only body-only ext-plist)
  (interactive)
  (org-export-to-buffer 'gn-blog-post-vue "*Org HTML Export*"
    async subtreep visible-only body-only ext-plist
    (lambda () (set-auto-mode t))))

(defun gn/org-publish-blog-post-interactive
    (&optional async subtreep visible-only body-only ext-plist)
  (interactive)
  (unless (file-directory-p pub-dir)
    (make-directory pub-dir t))
  (let* ((extension ".vue")
         (file (org-export-output-file-name extension subtreep))
         (org-export-coding-system org-html-coding-system))
    (org-export-to-file 'gn-blog-post-vue file
      async subtreep visible-only body-only ext-plist)))

(defun gn/org-publish-blog-post (plist filename pub-dir)
  (unless (file-directory-p pub-dir)
    (make-directory pub-dir t))
  (org-publish-org-to 'gn-blog-post-vue
                      filename
                      ".vue"
                      plist
                      pub-dir))

(provide 'gn-blog-post-vue)

(org-export-define-derived-backend 'gn-tummytracker-entry 'html
  :options-alist '((:html_doctype "HTML_DOCTYPE" "HTML5" t)
                   (:html_container "HTML_CONTAINER" "div" t))
  :translate-alist '((template . gn/tummytracker-entry-template)))

(defun gn/tummytracker-entry-template (contents info)
  "Template for org vue export"
  (concat
   "<template>\n"
   "<div>\n"
   contents
   "</div>\n"
   "</template>\n"
   "<script>\n"
   "export default {\n"
   "}\n"
   "</script>\n"
   ))

(defun gn/tummytracker-publish-org-interactive
    (&optional async subtreep visible-only body-only ext-plist)
  (interactive)
  (unless (file-directory-p pub-dir)
    (make-directory pub-dir t))
  (let* ((extension ".vue")
         (file (org-export-output-file-name extension subtreep))
         (org-export-coding-system org-html-coding-system))
    (org-export-to-file 'gn-tummytracker-entry file
      async subtreep visible-only body-only ext-plist)))

(defun gn/tummytracker-publish-org (plist filename pub-dir)
  (unless (file-directory-p pub-dir)
    (make-directory pub-dir t))
  (org-publish-org-to 'gn-tummytracker-entry
                      filename
                      ".vue"
                      plist
                      pub-dir))

(provide 'gn-tummytracker-entry)

(setq org-publish-project-alist
      '(
        ("gn-publish" :components ("gn-publish-org" "gn-publish-static"))
        ("gn-publish-org"
         :base-directory "~/things/blog-posts/"
         :base-extension "org"
         :publishing-directory "~/things/web/pages/"
         :recursive t
         :publishing-function gn/org-publish-blog-post
         :headline-levels 4
         :auto-preamble t
         )
        ("gn-publish-static"
         :base-directory "~/things/blog-posts/"
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf"
         :publishing-directory "~/things/web/static/"
         :recursive t
         :publishing-function org-publish-attachment
         )

        ("gn-tummytracker-publish"
         :base-directory "~/tummytracker/entry/"
         :base-extension "org"
         :publishing-directory "~/tummytracker/app/src/pages/entry/"
         :recursive t
         :publishing-function gn/tummytracker-publish-org
         :headline-levels 4
         :auto-preamble t)
        ))


