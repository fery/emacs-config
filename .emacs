;;
;; .emacs --- My personal Emacs startup script
;;
;; Original By Jorge Calás Lozano.
;; Modified By Jorge Dias
;;
;; Emacs should be compiled from CVS in order to make it work correctly with
;; nXhtml and ruby mode. At least in debian based, emacs-snapshot is broken.
;;
;; cvs -d:pserver:anonymous@cvs.sv.gnu.org:/sources/emacs co emacs
;; cd emacs
;;
;; Read the INSTALL file
;;
;; Verify you have Xfonts support if you want pretty fonts and other
;; dependencies: txinfo, libgif-dev, libxpm-dev (Images), libgpmg1-dev
;; (Mouse Support)
;;
;; wajig install libxfont-dev libxfont1 txinfo libgif-dev libxpm-dev libgpmg1-dev
;;
;; ./configure
;;
;; make
;; sudo make install
;;
;; Set Monospace font
;;
;; echo "Emacs.font: Monospace-10" >> ~/.Xresources
;; xrdb -merge ~/.Xresources
;;
;; /usr/local/bin/emacs
;; /usr/local/bin/emacsclient

;;;;;;;;;;;;;;;;;;
;; EMACS SERVER ;;
;;;;;;;;;;;;;;;;;;

;; Only start emacs-server it is not already started
(when (and
       (> emacs-major-version 22)
       (or (not (boundp 'server-process))
	   (not (eq (process-status server-process) 'listen))))
  (server-start))

;; Set font
;;(if (>= emacs-major-version 23)
;;  (set-default-font "BitStream Vera Sans Mono-12"))

;; Share clipboard with other X applications
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;; Set coding system to UTF-8
(prefer-coding-system 'utf-8)

;; Type y/n instead of yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; C-v & M-v return to original position
(setq scroll-preserve-screen-position 1)

(setq default-directory "~/apps/DPT")

;; Get back font antialiasing
(push '(font-backend xft x) default-frame-alist)


;; Enable disabled features
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'capitalize-region 'disabled nil)

;; Frame title bar formatting to show full path of file
(setq-default
 frame-title-format
 (list '((buffer-file-name " %f" (dired-directory
                                  dired-directory
                                  (revert-buffer-function " %b"
                                  ("%b - Dir:  " default-directory)))))))
(setq-default
 icon-title-format
 (list '((buffer-file-name " %f" (dired-directory
                                  dired-directory
                                  (revert-buffer-function " %b"
                                  ("%b - Dir:  " default-directory)))))))

;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir
  (concat "/tmp/emacs_autosaves/" (user-login-name) "/"))
(make-directory autosave-dir t)
(setq auto-save-file-name-transforms `(("\\(?:[^/]*/\\)*\\(.*\\)" ,(concat autosave-dir "\\1") t)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The backup-directory-alist
;; list contains regexp=>directory mappings; filenames matching a regexp are
;; backed up in the corresponding directory. Emacs will mkdir it if necessary.)
(defvar backup-dir (concat "/tmp/emacs_backups/" (user-login-name) "/"))
(setq backup-directory-alist (list (cons "." backup-dir)))

;; disable menu bar
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
;; disable scroll bars
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; disable toolbars
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;; disable tooltips
(if (fboundp 'tooltip-mode) (tooltip-mode -1))

;; don't show startup message
(setq inhibit-startup-message t)

;; don't bother about abbrev-file
;;(quietly-read-abbrev-file)

;; show line and column numbers
(line-number-mode t)
(column-number-mode t)

;; enable font-locking globally
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; set default tramp mode
(setq tramp-default-method "ssh")

;; use regexp while searching
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)

;; enlarge and shrink windows (C-+/C-x -)
(global-set-key (kbd "C-+") 'enlarge-window)
(global-set-key (kbd "C-x -") 'shrink-window)

(global-set-key (kbd "C-c b") 'browse-url)

;; ido-mode
(setq ido-use-filename-at-point t)
(setq ido-enable-flex-matching t)
(ido-mode t)
(ido-everywhere t)
(add-hook 'ido-setup-hook 'custom-ido-extra-keys)
(defun custom-ido-extra-keys ()
  "Add my keybindings for ido."
  (define-key ido-completion-map "\C-n" 'ido-next-match)
  (define-key ido-completion-map "\C-p" 'ido-prev-match)
  (define-key ido-completion-map " "    'ido-exit-minibuffer))

;; add library dirs to load-path
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")
(add-to-list 'load-path "~/.emacs.d/elisp/ruby-mode")
(add-to-list 'load-path "~/.emacs.d/elisp/ri-emacs")
(add-to-list 'load-path "~/.emacs.d/elisp/yaml-mode")
(add-to-list 'load-path "~/.emacs.d/elisp/rinari")
(add-to-list 'load-path "~/.emacs.d/elisp/git-emacs")
(add-to-list 'load-path "~/.emacs.d/elisp/haml-mode")
(add-to-list 'load-path "~/.emacs.d/elisp/emacs-wget")
(add-to-list 'load-path "~/.emacs.d/elisp/erlang")
(add-to-list 'load-path "~/.emacs.d/elisp/gist")
(add-to-list 'load-path "~/.emacs.d/elisp/flymake")
(add-to-list 'load-path "~/.emacs.d/elisp/rhtml")
(add-to-list 'load-path "~/.emacs.d/elisp/javascript")
;; add more here as needed

(require 'textmate)
(textmate-mode)


;; emacs-wget
;; http://pop-club.hp.infoseek.co.jp/emacs/emacs-wget/emacs-wget-0.5.0.tar.gz
;; Download, uncompress and move to ~/.emacs.d/elisp/emacs-wget
;; run make
(autoload 'wget "wget" "wget interface for Emacs." t)
(autoload 'wget-web-page "wget" "wget interface to download whole web page." t)
(setq wget-download-directory-filter 'wget-download-dir-filter-regexp)
(setq wget-download-directory
      '(("\\.\\(jpe?g\\|png\\)$" . "~/Downloads/wget/pictures")
	("\\.el$" . "~/.emacs.d/elisp")
	("." . "~/Downloads/wget")))
(global-set-key (kbd "C-c w") 'wget)


;; Kills live buffers, leaves some emacs work buffers
;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-some-buffers (&optional list)
  "For each buffer in LIST, kill it silently if unmodified. Otherwise ask.
LIST defaults to all existing live buffers."
  (interactive)
  (if (null list)
      (setq list (buffer-list)))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and (not (string-equal name ""))
           ;(not (string-equal name "*Messages*"))
          ;; (not (string-equal name "*Buffer List*"))
           ;(not (string-equal name "*buffer-selection*"))
           ;(not (string-equal name "*Shell Command Output*"))
           (not (string-equal name "*scratch*"))
           (/= (aref name 0) ? )
           (if (buffer-modified-p buffer)
               (if (yes-or-no-p
                    (format "Buffer %s has been edited. Kill? " name))
                   (kill-buffer buffer))
             (kill-buffer buffer))))
    (setq list (cdr list))))

;; icomplete
;; preview command completion when writing in Minibuffer
;; this is part of emacs
(icomplete-mode 1)

;; icomplete+
;; Extensions to icomplete
;; http://www.emacswiki.org/cgi-bin/wiki/download/icomplete+.el (wget)
(eval-after-load "icomplete" '(progn (require 'icomplete+)))



(mouse-wheel-mode t)
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)
(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)
(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)

;; anything
(require 'anything)



;; color-theme
;; http://download.gna.org/color-theme/color-theme-6.6.0.tar.gz (wget)
;; uncompress and move to ~/.emacs.d/elisp/color-theme
(require 'color-theme)
(color-theme-initialize)
;; http://edward.oconnor.cx/config/elisp/color-theme-hober2.el (wget)
(load-file "~/.emacs.d/elisp/color-theme/color-theme-library.el")
(color-theme-billw)

;(require 'color-theme-hober2)
;(color-theme-hober2)

;; ri-ruby
;; http://rubyforge.org/projects/ri-emacs/
;;
;; cd ~/.emacs.d/elisp
;; cvs -d :pserver:anonymous@rubyforge.org:/var/cvs/ri-emacs login # Press ENTER for password
;; cvs -d :pserver:anonymous@rubyforge.org:/var/cvs/ri-emacs checkout ri-emacs
;;
;; C-h r
(setq ri-ruby-script "/home/jorge/.emacs.d/elisp/ri-emacs/ri-emacs.rb")
(autoload 'ri "ri-ruby" nil t)
(global-set-key (kbd "C-h r") 'ri)

;; ruby-test  run test/specs for ruby projects
;; http://www.emacswiki.org/cgi-bin/emacs/download/ruby-test.el (wget)
;;
;; C-x C-SPC => run this test/spec
;; C-x t     => run tests/specs in this file
;; C-c t     => toggle between specification and implementation
(require 'ruby-test)

;; rdebug from ruby-debug-extras-0.10.1 (not working as desire)
;;
;; Read http://groups.google.com/group/emacs-on-rails/browse_thread/thread/dfaa224905b51487
;; http://rubyforge.iasi.roedu.net/files/ruby-debug/ruby-debug-extra-0.10.1.tar.gz (wget)
;;(require 'rdebug)

;; rinari
;; http://github.com/eschulte/rinari
(require 'rinari)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(setq rinari-browse-url-func 'browse-url-generic)

;; ruby-mode
;; ruby-mode from ruby-lang svn
;;
;; svn co http://svn.ruby-lang.org/repos/ruby/trunk/misc/ ~/.emacs.d/elisp/ruby-mode
(setq auto-mode-alist (append '(("\\.rb$" . ruby-mode)) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))

;; add file types to ruby-mode
;; (add-to-list 'auto-mode-alist '("\.treetop$" . ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\.thor$" . ruby-mode))

;; inf-ruby
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-hook 'ruby-mode-hook '(lambda () (inf-ruby-keys) ))

;; ruby-electric
(require 'ruby-electric)
(add-hook 'ruby-mode-hook (lambda () (ruby-electric-mode t)))


;; use exuberant-ctags
;;
;; Generate file with:
;;   ctags-exuberant -a -e -f TAGS --tag-relative -R app lib vendor
(setq rinari-tags-file-name "TAGS")

;; nXhtml
(load "~/.emacs.d/elisp/nxhtml/autostart.el")
(require 'mumamo-fun)
(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 'submode-colored
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)

;; js2-mode (javascript IDE)
;; http://code.google.com/p/js2-mode/
;;(autoload 'js2-mode "js2" nil t)
;;(add-to-list 'auto-mode-alist '("\.js$" . js2-mode))

;; haml-mode and & sass-mode
;; http://github.com/nex3/haml/
(require 'haml-mode)
(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\.haml$" . haml-mode))
(add-to-list 'auto-mode-alist '("\.sass$" . sass-mode))

;; yaml-mode
;; http://svn.clouder.jp/repos/public/yaml-mode/trunk/
(autoload 'yaml-mode "yaml-mode" "Yaml editing mode")
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
	  '(lambda () (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; yasnippets
;; http://code.google.com/p/yasnippet/
(require 'yasnippet)
;; (add-to-list 'yas/extra-mode-hooks 'ruby-mode-hook)
(yas/initialize)
(setq yas/text-popup-function
      'yas/dropdown-list-popup-for-template)
(yas/load-directory "~/.emacs.d/snippets/defaults")
(yas/load-directory "~/.emacs.d/snippets/contrib-snippets")
(yas/load-directory "~/.emacs.d/snippets/yasnippets-rails/rails-snippets")
(yas/load-directory "~/.emacs.d/snippets/my-snippets")

;; git-emacs
;; http://github.com/tsgates/git-emacs
(require 'git-emacs)

;; textile-mode
;; http://dev.nozav.org/scripts/textile-mode.el
(require 'textile-mode)
(add-to-list 'auto-mode-alist '("\\.textile\\'" . textile-mode))

;; pastie
;; http://www.emacswiki.org/cgi-bin/wiki/download/pastie.el (wget)
(require 'pastie)

;; lorem-ipsum
;; http://www.emacswiki.org/cgi-bin/wiki/download/lorem-ipsum.el (wget)
(require 'lorem-ipsum)

;; tree-top
;; http://github.com/hornbeck/public_emacs/tree/master/treetop.el
(require 'treetop-mode)

;; po-mode
;; Part of the gettext package, you can grab it at http://gnuftp.spegulo.be/gettext/
;;
;; po-mode+
;; Adds some extensions to po-mode
;; http://www.emacswiki.org/cgi-bin/wiki/po-mode+.el/download/po-mode+.el (wget)
(autoload 'po-mode "po-mode+"
  "Major mode for translators to edit PO files" t)
(setq auto-mode-alist (cons '("\\.po\\'\\|\\.po\\." . po-mode)
			    auto-mode-alist))

;; (autoload 'po-find-file-coding-system "po-compat")
;; (modify-coding-system-alist 'file "\\.po\\'\\|\\.po\\."
;; 			    'po-find-file-coding-system)

;; keep scrolling in compilation result buffer
(setq compilation-scroll-output t)

;; emacs-compile font-lock tweaks to get a pretty rspec result output
(add-to-list 'compilation-mode-font-lock-keywords
	     '("^\\([[:digit:]]+\\) examples?, \\([[:digit:]]+\\) failures?\\(?:, \\([[:digit:]]+\\) pendings?\\)?$"
	       (0 '(face nil message nil help-echo nil mouse-face nil) t)
	       (1 compilation-info-face)
	       (2 (if (string= "0" (match-string 2))
		      compilation-info-face
		    compilation-error-face))
	       (3 compilation-info-face t t)))

;; smart-compile
;; http://homepage.mac.com/zenitani/comp-e.html
(autoload 'smart-compile "smart-compile")
(setq smart-compile-alist
      '(("/programming/guile/.*c$" .    "gcc -Wall %f `guile-config link` -o %n")
        ("\\.c\\'"              .       "gcc -Wall %f -lm -o %n")
        ("\\.[Cc]+[Pp]*\\'"     .       "g++ -Wall %f -lm -o %n")
        ("\\.java$"             .       "javac %f")
	("_spec\\.rb$"          .       "spec %f")
	("\\.rb$"               .       "ruby %f")
	("\\.pl$"               .       "perl %f")
        (emacs-lisp-mode        .       (emacs-lisp-byte-compile))
        (html-mode              .       (browse-url-of-buffer))
        (html-helper-mode       .       (browse-url-of-buffer))
        ("\\.skb$"              .       "skribe %f -o %n.html")
        (haskell-mode           .       "ghc -o %n %f")
        (asy-mode               .       (call-interactively 'asy-compile-view))
        (muse-mode              .       (call-interactively 'muse-project-publish))))
(global-set-key (kbd "<f9>") 'smart-compile)

;; erlang-mode
(setq erlang-root-dir "/usr/lib/erlang")
(setq exec-path (cons "/usr/lib/erlang/bin" exec-path))
(require 'erlang-start)

;; gist-support
(require 'gist)

;; autotest support
(setq autotest-use-ui t)
(require 'autotest)

;; magit support. Source: git clone git://gitorious.org/magit/mainline.git
;;(require 'magit)
;;global-set-key (kbd "C-c m") 'magit-status)
;;;;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOMIZATIONS FILE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(setq custom-file "~/.emacs.d/customizations.el")
(load custom-file 'noerror)
(setq ansi-color-for-comint-mode t)

;; Set column width to 80
(setq fill-column 80)

;; delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; My functions
(defun rinari-merb-generate-tags()
  (interactive)
  (let ((my-tags-file (concat (rinari-merb-root) "TAGS"))
	(root (rinari-merb-root)))
    (message "Regenerating TAGS file: %s" my-tags-file)
    (if (file-exists-p my-tags-file)
	(delete-file my-tags-file))
    (shell-command
     (format "find -L %s -regex \".+rb$\" | xargs ctags-exuberant -a -e -f %s"
	     root my-tags-file))
    (if (get-file-buffer my-tags-file)
	 (kill-buffer (get-file-buffer my-tags-file)))
    (visit-tags-table my-tags-file)))

(defun rinari-generate-tags()
  (interactive)
  (let ((my-tags-file (concat (rinari-root) "TAGS"))
	(root (rinari-root)))
    (message "Regenerating TAGS file: %s" my-tags-file)
    (if (file-exists-p my-tags-file)
	(delete-file my-tags-file))
    (shell-command
     (format "find -L %s -regex \".+rb$\" | xargs ctags-exuberant -a -e -f %s"
	     root my-tags-file))
    (if (get-file-buffer my-tags-file)
	 (kill-buffer (get-file-buffer my-tags-file)))
    (visit-tags-table my-tags-file)))

(defun haml-convert-rhtml-file (rhtmlFile hamlFile)
  "Convierte un fichero rhtml en un haml y abre un nuevo buffer"
  (interactive "fSelect rhtml file: \nFSelect output (haml) file: ")
  (let ((comando (concat "/usr/bin/html2haml -r "
                         rhtmlFile
                         " "
                         hamlFile)))
    (shell-command comando)
    (find-file hamlFile)))

(defun haml-convert-region (beg end)
  "Convierte la región seleccionada a código haml"
  (interactive "r")
  (let ((comando "/usr/bin/html2haml -r -s"))
  (shell-command-on-region beg end comando (buffer-name) t)))

(defun haml-to-html-region (beg end)
  "Convierte la región seleccionada a código html"
  (interactive "r")
  (let ((comando "/usr/bin/haml -s -c"))
  (shell-command-on-region beg end comando (buffer-name) t)))

(defun haml-convert-buffer ()
  "Convierte el buffer seleccionado a código haml"
  (interactive)
  (let ((nuevoarchivo
	 (replace-regexp-in-string "r?html\\(.erb\\)?$" "haml"
				   (buffer-file-name))))
     (haml-convert-region (point-min) (point-max))
     (write-file nuevoarchivo)))

(defun sass-convert-region (beg end)
  "Convierte la región seleccionada a código sass"
  (interactive "r")
  (let ((comando "/usr/bin/css2sass -s"))
  (shell-command-on-region beg end comando (buffer-name) t)))


;; flymake
(require 'flymake)

;; I don't like the default colors :)
(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")

;; Feature request: have flymake create its temp files in the system temp file directory instead of in the same directory as the file. When using it with Ruby on Rails and autotest, autotest sees the temp file and tries to do something with it and dies, forcing me to restart it, thus killing the magic of autotest. Putting flymake’s temp files elsewhere seems like the easiest way to dodge this.
;;
;; I second the above request. I know there are workarounds for autotest, but it seems like we don’t want to find work arounds for every new web framework, we want to get flymake working in a way that won’t conflict with any other tools.
;;
;; It is easy to patch your autotest to ignore flymake files. I have submitted a patch which hopefully will be included in future releases. For more info see: Emacs, flymake and autotest: the fix
;;
;; Here is a suggestion for a solution (100% untested). Replace flymake-create-temp-inplace above with

(defun flymake-create-temp-intemp (file-name prefix)
  "Return file name in temporary directory for checking FILE-NAME.
This is a replacement for `flymake-create-temp-inplace'. The
difference is that it gives a file name in
`temporary-file-directory' instead of the same directory as
FILE-NAME.

For the use of PREFIX see that function.

Note that not making the temporary file in another directory
\(like here) will not if the file you are checking depends on
relative paths to other files \(for the type of checks flymake
makes)."
  (unless (stringp file-name)
    (error "Invalid file-name"))
  (or prefix
      (setq prefix "flymake"))
  (let* ((name (concat
                (file-name-nondirectory
                 (file-name-sans-extension file-name))
                "_" prefix))
         (ext  (concat "." (file-name-extension file-name)))
         (temp-name (make-temp-file name nil ext))
         )
    (flymake-log 3 "create-temp-intemp: file=%s temp=%s" file-name temp-name)
    temp-name))


;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-intemp))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '(".+\\.rjs$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook 'ruby-mode-hook
          '(lambda ()

             ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
             (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                 (flymake-mode))
             ))

(require 'flymake-jslint)
(add-hook 'javascript-mode-hook
          '(lambda ()
             ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
             (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
                 (flymake-mode))
             ))

;; rhtml-mode
(require 'rhtml-mode)
(add-hook 'rhtml-mode-hook
  (lambda () (rinari-launch)))

(add-hook 'rhtml-mode
          (let ((original-command (lookup-key rhtml-mode-map [tab])))
            `(lambda ()
               (setq yas/fallback-behavior
                     '(apply ,original-command))
               (local-set-key [tab] 'yas/expand))))


;(set-background-color "#2b2b2b")
;(set-foreground-color "white")
;(set-face-background 'modeline "DarkRed")
;(set-face-foreground 'modeline "white")


;; javascript
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(autoload 'javascript-mode "javascript" nil t)

(defvar javascript-identifier-regexp "[a-zA-Z0-9.$_]+")

(defun javascript-imenu-create-method-index-1 (class bound)
  (let (result)
    (while (re-search-forward (format "^ +\\(\%s\\): *function" javascript-identifier-regexp) bound t)
      (push (cons (format "%s.%s" class (match-string 1)) (match-beginning 1)) result))
    (nreverse result)))

(defun javascript-imenu-create-method-index()
  (cons "Methods"
        (let (result)
          (dolist (pattern (list (format "\\b\\(%s\\) *= *Class\.create" javascript-identifier-regexp)
                                 (format "\\b\\([A-Z]%s\\) *= *Object.extend(%s"
                                         javascript-identifier-regexp
                                         javascript-identifier-regexp)
                                 (format "^ *Object.extend(\\([A-Z]%s\\)" javascript-identifier-regexp)
                                 (format "\\b\\([A-Z]%s\\) *= *{" javascript-identifier-regexp)))
            (goto-char (point-min))
            (while (re-search-forward pattern (point-max) t)
              (save-excursion
                (condition-case nil
                    (let ((class (replace-regexp-in-string "\.prototype$" "" (match-string 1)))
                          (try 3))
                      (if (eq (char-after) ?\()
                          (down-list))
                      (if (eq (char-before) ?{)
                          (backward-up-list))
                      (forward-list)
                      (while (and (> try 0) (not (eq (char-before) ?})))
                        (forward-list)
                        (decf try))
                      (if (eq (char-before) ?})
                          (let ((bound (point)))
                            (backward-list)
                            (setq result (append result (javascript-imenu-create-method-index-1 class bound))))))
                  (error nil)))))
          (delete-duplicates result :test (lambda (a b) (= (cdr a) (cdr b)))))))

(defun javascript-imenu-create-function-index ()
  (cons "Functions"
         (let (result)
           (dolist (pattern '("\\b\\([[:alnum:].$]+\\) *= *function" "function \\([[:alnum:].]+\\)"))
             (goto-char (point-min))
             (while (re-search-forward pattern (point-max) t)
               (push (cons (match-string 1) (match-beginning 1)) result)))
           (nreverse result))))

(defun javascript-imenu-create-index ()
  (list
   (javascript-imenu-create-function-index)
   (javascript-imenu-create-method-index)))

(add-hook 'javascript-mode-hook
  (lambda ()
    (setq imenu-create-index-function 'javascript-imenu-create-index)
    (local-set-key (kbd "<return>") 'newline-and-indent)
  )
t)
