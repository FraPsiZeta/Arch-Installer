;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Layer configuration:
This function should only modify configuration layer settings."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs

   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused

   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t

   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()

   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; +----------------------------------------------------+
     ;; |  Installation requirements for layers that follow  |
     ;; +----------------------------------------------------+
     ;;
     ;; List of packages needed for the following layers. LSP-related packages will be
     ;; installed if not found by spacemacs, but can be installed system-wide if
     ;; preferred (marked with 'X' in the list below). To clean up the ones installed
     ;; by LSP delete them from "~/.emacs.d/.cache/lsp".
     ;;
     ;; Arch oneliner:
     ;; $ yay -Sy bashate shellcheck shfmt nodejs   ag   fd texlive-most clangd cmake-lsp-server pyright rust-analyzer
     ;;          |                        |      |      |  |            |   X  |        X       |   X   |      X      |
     ;;          +------------------------+------+------+--+------------+------+----------------+-------+-------------+
     ;;                       |              |       |            |         |           |           |          |
     ;;                       V              V       V            V         V           V           V          V
     ;;                 shell-scripts       dap   helm-ag       LaTex     c-c++       cmake       Python      Rust
     ;;
     ;;
     ;; Some one-time only commands to configure dap and set icons fonts:
     ;; - M-x dap-gdb-lldb-setup (debug-layer)
     ;; - M-x all-the-icons-install-fonts
     ;;
     ;; For python developement the following should be installed in specific
     ;; virtualenvs as developement dependencies. Installing them system-wide works as well.
     ;; - python -m pip install python-lsp-server pylint mypy black
     ;;
     ;; We define :variables in dotspacemacs-configuration-layers if and only if they are
     ;; defined in layer's config (i.e. config.el, easily checked with [, h h]).
     ;; ------------------------------------------------------------------------

     (python :variables
             python-lsp-server 'pylsp
             python-formatter 'black
             python-test-runner 'pytest)
     (c-c++ :variables
            c-c++-backend 'lsp-clangd
            c-c++-adopt-subprojects t
            c-c++-dap-adapters '(dap-gdb-lldb dap-cpptools)
            c-c++-lsp-enable-semantic-highlight t)
     (shell :variables
            shell-default-shell 'vterm
            shell-default-term-shell (concat "env -i USER=$USER DISPLAY=$DISPLAY "
                                             "HOME=$HOME TERM=$TERM bash -l"))
     (version-control :variables
                      version-control-diff-side 'left
                      version-control-global-margin t
                      version-control-diff-tool 'diff-hl)
     (shell-scripts :variables
                    shell-scripts-backend 'shell-script-mode)
     (auto-completion :variables
                      auto-completion-enable-help-tooltip t)
     yaml
     cmake
     treemacs
     syntax-checking
     spacemacs-layouts
     evil-better-jumper
     better-defaults
     spacemacs-navigation
     lsp
     dap
     docker
     debug
     html
     csv
     emacs-lisp
     systemd
     git
     rust
     theming
     helm
     markdown
     org
     pdf
     javascript)

   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   ;; To use a local version of a package, use the `:location' property:
   ;; '(your-package :location "~/path/to/your-package/")
   ;; Also include the dependencies as they will not be resolved automatically.
   dotspacemacs-additional-packages
   '(nord-theme
     poetry)

   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()

   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages '()

   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and deletes any unused
   ;; packages as well as their unused dependencies. `used-but-keep-unused'
   ;; installs only the used packages but won't delete unused ones. `all'
   ;; installs *all* packages supported by Spacemacs and never uninstalls them.
   ;; (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization:
This function is called at the very beginning of Spacemacs startup,
before layer configuration.
It should only modify the values of Spacemacs settings."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non-nil then enable support for the portable dumper. You'll need to
   ;; compile Emacs 27 from source following the instructions in file
   ;; EXPERIMENTAL.org at to root of the git repository.
   ;;
   ;; WARNING: pdumper does not work with Native Compilation, so it's disabled
   ;; regardless of the following setting when native compilation is in effect.
   ;;
   ;; (default nil)
   dotspacemacs-enable-emacs-pdumper nil

   ;; Name of executable file pointing to emacs 27+. This executable must be
   ;; in your PATH.
   ;; (default "emacs")
   dotspacemacs-emacs-pdumper-executable-file "emacs"

   ;; Name of the Spacemacs dump file. This is the file will be created by the
   ;; portable dumper in the cache directory under dumps sub-directory.
   ;; To load it when starting Emacs add the parameter `--dump-file'
   ;; when invoking Emacs 27.1 executable on the command line, for instance:
   ;;   ./emacs --dump-file=$HOME/.emacs.d/.cache/dumps/spacemacs-27.1.pdmp
   ;; (default (format "spacemacs-%s.pdmp" emacs-version))
   dotspacemacs-emacs-dumper-dump-file (format "spacemacs-%s.pdmp" emacs-version)

   ;; If non-nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t

   ;; Maximum allowed time in seconds to contact an ELPA repository.
   ;; (default 5)
   dotspacemacs-elpa-timeout 300

   ;; Set `gc-cons-threshold' and `gc-cons-percentage' when startup finishes.
   ;; This is an advanced option and should not be changed unless you suspect
   ;; performance issues due to garbage collection operations.
   ;; (default '(100000000 0.1))
   dotspacemacs-gc-cons '(100000000 0.1)

   ;; Set `read-process-output-max' when startup finishes.
   ;; This defines how much data is read from a foreign process.
   ;; Setting this >= 1 MB should increase performance for lsp servers
   ;; in emacs 27.
   ;; (default (* 1024 1024))
   dotspacemacs-read-process-output-max (* 5 1024 1024)

   ;; If non-nil then Spacelpa repository is the primary source to install
   ;; a locked version of packages. If nil then Spacemacs will install the
   ;; latest version of packages from MELPA. Spacelpa is currently in
   ;; experimental state please use only for testing purposes.
   ;; (default nil)
   dotspacemacs-use-spacelpa nil

   ;; If non-nil then verify the signature for downloaded Spacelpa archives.
   ;; (default t)
   dotspacemacs-verify-spacelpa-archives t

   ;; If non-nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update nil

   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'. (default 'emacs-version)
   dotspacemacs-elpa-subdirectory 'emacs-version

   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim

   ;; If non-nil show the version string in the Spacemacs buffer. It will
   ;; appear as (spacemacs version)@(emacs version)
   ;; (default t)
   dotspacemacs-startup-buffer-show-version t

   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner 'official

   ;; Scale factor controls the scaling (size) of the startup banner. Default
   ;; value is `auto' for scaling the logo automatically to fit all buffer
   ;; contents, to a maximum of the full image height and a minimum of 3 line
   ;; heights. If set to a number (int or float) it is used as a constant
   ;; scaling factor for the default logo size.
   dotspacemacs-startup-banner-scale 'auto

   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `recents-by-project' `bookmarks' `projects' `agenda' `todos'.
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   ;; The exceptional case is `recents-by-project', where list-type must be a
   ;; pair of numbers, e.g. `(recents-by-project . (7 .  5))', where the first
   ;; number is the project limit and the second the limit on the recent files
   ;; within a project.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))

   ;; True if the home buffer should respond to resize events. (default t)
   dotspacemacs-startup-buffer-responsive t

   ;; Show numbers before the startup list lines. (default t)
   dotspacemacs-show-startup-list-numbers t

   ;; The minimum delay in seconds between number key presses. (default 0.4)
   dotspacemacs-startup-buffer-multi-digit-delay 0.4

   ;; If non-nil, show file icons for entries and headings on Spacemacs home buffer.
   ;; This has no effect in terminal or if "all-the-icons" package or the font
   ;; is not installed. (default nil)
   dotspacemacs-startup-buffer-show-icons t

   ;; Default major mode for a new empty buffer. Possible values are mode
   ;; names such as `text-mode'; and `nil' to use Fundamental mode.
   ;; (default `text-mode')
   dotspacemacs-new-empty-buffer-major-mode 'text-mode

   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'text-mode

   ;; If non-nil, *scratch* buffer will be persistent. Things you write down in
   ;; *scratch* buffer will be saved and restored automatically.
   dotspacemacs-scratch-buffer-persistent nil

   ;; If non-nil, `kill-buffer' on *scratch* buffer
   ;; will bury it instead of killing.
   dotspacemacs-scratch-buffer-unkillable nil

   ;; Initial message in the scratch buffer, such as "Welcome to Spacemacs!"
   ;; (default nil)
   dotspacemacs-initial-scratch-message nil

   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press `SPC T n' to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(nord spacemacs-dark)

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `doom', `vim-powerline' and `vanilla'. The
   ;; first three are spaceline themes. `doom' is the doom-emacs mode-line.
   ;; `vanilla' is default Emacs mode-line. `custom' is a user defined themes,
   ;; refer to the DOCUMENTATION.org for more info on how to create your own
   ;; spaceline theme. Value can be a symbol or list with additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.5)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t

   ;; Default font or prioritized list of fonts. The `:size' can be specified as
   ;; a non-negative integer (pixel size), or a floating-point (point size).
   ;; Point size is recommended, because it's device independent. (default 10.0)
   dotspacemacs-default-font '("Hack Nerd Font"
                               :size 12.0
                               :weight normal
                               :width normal)

   ;; The leader key (default "SPC")
   dotspacemacs-leader-key "SPC"

   ;; The key used for Emacs commands `M-x' (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"

   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"

   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"

   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","

   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m" for terminal mode, "<M-return>" for GUI mode).
   ;; Thus M-RET should work as leader key in both GUI and terminal modes.
   ;; C-M-m also should work in terminal mode, but not in GUI mode.
   dotspacemacs-major-mode-emacs-leader-key (if window-system "<M-return>" "C-M-m")

   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs `C-i', `TAB' and `C-m', `RET'.
   ;; Setting it to a non-nil value, allows for separate commands under `C-i'
   ;; and TAB or `C-m' and `RET'.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab nil

   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"

   ;; If non-nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil

   ;; If non-nil then the last auto saved layouts are resumed automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil

   ;; If non-nil, auto-generate layout name when creating new layouts. Only has
   ;; effect when using the "jump to layout by number" commands. (default nil)
   dotspacemacs-auto-generate-layout-names nil

   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1

   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache

   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5

   ;; If non-nil, the paste transient-state is enabled. While enabled, after you
   ;; paste something, pressing `C-j' and `C-k' several times cycles through the
   ;; elements in the `kill-ring'. (default nil)
   dotspacemacs-enable-paste-transient-state nil

   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4

   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom

   ;; Control where `switch-to-buffer' displays the buffer. If nil,
   ;; `switch-to-buffer' displays the buffer in the current window even if
   ;; another same-purpose window is available. If non-nil, `switch-to-buffer'
   ;; displays the buffer in a same-purpose window even if the buffer can be
   ;; displayed in the current window. (default nil)
   dotspacemacs-switch-to-buffer-prefers-purpose nil

   ;; If non-nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t

   ;; If non-nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil

   ;; If non-nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil

   ;; If non-nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil

   ;; If non-nil the frame is undecorated when Emacs starts up. Combine this
   ;; variable with `dotspacemacs-maximized-at-startup' to obtain fullscreen
   ;; without external boxes. Also disables the internal border. (default nil)
   dotspacemacs-undecorated-at-startup nil

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90

   ;; A value from the range (0..100), in increasing opacity, which describes the
   ;; transparency level of a frame background when it's active or selected. Transparency
   ;; can be toggled through `toggle-background-transparency'. (default 90)
   dotspacemacs-background-transparency 90

   ;; If non-nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t

   ;; If non-nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t

   ;; If non-nil unicode symbols are displayed in the mode line.
   ;; If you use Emacs as a daemon and wants unicode characters only in GUI set
   ;; the value to quoted `display-graphic-p'. (default t)
   dotspacemacs-mode-line-unicode-symbols t

   ;; If non-nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t

   ;; Show the scroll bar while scrolling. The auto hide time can be configured
   ;; by setting this variable to a number. (default t)
   dotspacemacs-scroll-bar-while-scrolling t

   ;; Control line numbers activation.
   ;; If set to `t', `relative' or `visual' then line numbers are enabled in all
   ;; `prog-mode' and `text-mode' derivatives. If set to `relative', line
   ;; numbers are relative. If set to `visual', line numbers are also relative,
   ;; but only visual lines are counted. For example, folded lines will not be
   ;; counted and wrapped lines are counted as multiple lines.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :visual nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; When used in a plist, `visual' takes precedence over `relative'.
   ;; (default nil)
   dotspacemacs-line-numbers 'relative

   ;; Code folding method. Possible values are `evil', `origami' and `vimish'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil

   ;; If non-nil and `dotspacemacs-activate-smartparens-mode' is also non-nil,
   ;; `smartparens-strict-mode' will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil

   ;; If non-nil smartparens-mode will be enabled in programming modes.
   ;; (default t)
   dotspacemacs-activate-smartparens-mode nil

   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc...
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil

   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all

   ;; If non-nil, start an Emacs server if one is not already running.
   ;; (default nil)
   dotspacemacs-enable-server nil

   ;; Set the emacs server socket location.
   ;; If nil, uses whatever the Emacs default is, otherwise a directory path
   ;; like \"~/.emacs.d/server\". It has no effect if
   ;; `dotspacemacs-enable-server' is nil.
   ;; (default nil)
   dotspacemacs-server-socket-dir nil

   ;; If non-nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server nil

   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `rg', `ag', `pt', `ack' and `grep'.
   ;; (default '("rg" "ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")

   ;; Format specification for setting the frame title.
   ;; %a - the `abbreviated-file-name', or `buffer-name'
   ;; %t - `projectile-project-name'
   ;; %I - `invocation-name'
   ;; %S - `system-name'
   ;; %U - contents of $USER
   ;; %b - buffer name
   ;; %f - visited file name
   ;; %F - frame name
   ;; %s - process status
   ;; %p - percent of buffer above top of window, or Top, Bot or All
   ;; %P - percent of buffer above bottom of window, perhaps plus Top, or Bot or All
   ;; %m - mode name
   ;; %n - Narrow if appropriate
   ;; %z - mnemonics of buffer, terminal, and keyboard coding systems
   ;; %Z - like %z, but including the end-of-line format
   ;; If nil then Spacemacs uses default `frame-title-format' to avoid
   ;; performance issues, instead of calculating the frame title by
   ;; `spacemacs/title-prepare' all the time.
   ;; (default "%I@%S")
   dotspacemacs-frame-title-format "%I@%S"

   ;; Format specification for setting the icon title format
   ;; (default nil - same as frame-title-format)
   dotspacemacs-icon-title-format nil

   ;; Color highlight trailing whitespace in all prog-mode and text-mode derived
   ;; modes such as c++-mode, python-mode, emacs-lisp, html-mode, rst-mode etc.
   ;; (default t)
   dotspacemacs-show-trailing-whitespace t

   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed' to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup nil

   ;; If non-nil activate `clean-aindent-mode' which tries to correct
   ;; virtual indentation of simple modes. This can interfere with mode specific
   ;; indent handling like has been reported for `go-mode'.
   ;; If it does deactivate it here.
   ;; (default t)
   dotspacemacs-use-clean-aindent-mode t

   ;; Accept SPC as y for prompts if non-nil. (default nil)
   dotspacemacs-use-SPC-as-y nil

   ;; If non-nil shift your number row to match the entered keyboard layout
   ;; (only in insert state). Currently supported keyboard layouts are:
   ;; `qwerty-us', `qwertz-de' and `querty-ca-fr'.
   ;; New layouts can be added in `spacemacs-editing' layer.
   ;; (default nil)
   dotspacemacs-swap-number-row nil

   ;; Either nil or a number of seconds. If non-nil zone out after the specified
   ;; number of seconds. (default nil)
   dotspacemacs-zone-out-when-idle nil

   ;; Run `spacemacs/prettify-org-buffer' when
   ;; visiting README.org files of Spacemacs.
   ;; (default nil)
   dotspacemacs-pretty-docs nil

   ;; If nil the home buffer shows the full path of agenda items
   ;; and todos. If non-nil only the file name is shown.
   dotspacemacs-home-shorten-agenda-source nil

   ;; If non-nil then byte-compile some of Spacemacs files.
   dotspacemacs-byte-compile nil))

(defun dotspacemacs/user-env ()
  "Environment variables setup.
This function defines the environment variables for your Emacs session. By
default it calls `spacemacs/load-spacemacs-env' which loads the environment
variables declared in `~/.spacemacs.env' or `~/.spacemacs.d/.spacemacs.env'.
See the header of this file for more information."
  (spacemacs/load-spacemacs-env)
)

(defun dotspacemacs/user-init ()
  "Initialization for user code:
This function is called immediately after `dotspacemacs/init', before layer
configuration.
It is mostly for variables that should be set before packages are loaded.
If you are unsure, try setting them in `dotspacemacs/user-config' first."
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

  ;; Modes' hooks should be placed in user-init
  (add-hook 'after-init-hook 'company-tng-mode)
  ;; Added to solve company-tng init bug. Only the previous one should be necessary.
  (add-hook 'prog-mode-hook
            'company-tng-mode)
)


(defun dotspacemacs/user-load ()
  "Library to load while dumping.
This function is called only while dumping Spacemacs configuration. You can
`require' or `load' the libraries of your choice that will be included in the
dump."
)


(defun dotspacemacs/user-config ()
  "Configuration for user code:
This function is called at the very end of Spacemacs startup, after layer
configuration.
Put your configuration code here, except for variables that should be set
before packages are loaded."

  ;; +----------+
  ;; |   Misc   |
  ;; +----------+

  ;; Battery and time in mode-line.
  (spacemacs/toggle-mode-line-battery-on)
  (spacemacs/toggle-display-time-on)

  ;; <C-i> problems
  (setq-default dotspacemacs-distinguish-gui-tab t)

  ;; Cursor options
  ;; (global-centered-cursor-mode 1)

  ;; Disable line wrap
  (spacemacs/toggle-truncate-lines-on)

  ;; Prevent undo-tree from saving trees all over the place
  (customize-set-variable 'undo-tree-auto-save-history nil)

  ;; Kill buffer when killing layer with [SPC-l-x]
  (customize-set-variable 'persp-autokill-buffer-on-remove 'kill-weak)

  ;; Do not ask when following symlinks, just warn.
  (customize-set-variable 'vc-follow-symlinks nil)

  ;; Hide special buffers, still shown with [SPC-b-U]
  (add-to-list 'spacemacs-useless-buffers-regexp '"^*")

  ;; +-----------------------+
  ;; |    Custom shortcuts   |
  ;; +-----------------------+

  (spacemacs/set-leader-keys "oh" 'lsp-ui-doc-glance)
  (spacemacs/set-leader-keys "ol" 'my-term-in-vsplit)
  (spacemacs/set-leader-keys "oj" 'my-term-in-split)

  ;; Super useful fuzzy find for files.
  (spacemacs/set-leader-keys "ff" 'helm-find)

  (define-key evil-normal-state-map (kbd "C-i") 'evil-jump-forward)

  (spacemacs/set-leader-keys "pm" 'my-add-project-and-treemacs)
  (spacemacs/set-leader-keys "pM" 'my-remove-project-and-treemacs)
  (spacemacs/set-leader-keys "pn" 'projectile-next-project-buffer)
  (spacemacs/set-leader-keys "pN" 'projectile-previous-project-buffer)

  ;; (with-eval-after-load 'lsp-mode
  ;;   (define-key lsp-command-map-prefix "ga" 'projectile-find-other-file))

  ;; +---------+
  ;; |   LSP   |
  ;; +---------+

  (setq-default lsp-ui-sideline-code-actions-prefix "💡 ")
  (customize-set-variable 'lsp-file-watch-threshold nil)
  (customize-set-variable 'lsp-diagnostics-disabled-modes '(python-mode))
  (customize-set-variable 'lsp-clients-clangd-args
                          '("--clang-tidy"
                            "--header-insertion-decorators=0"
                            "-j=4"
                            "--background-index"
                            "--header-insertion=never"))
  (customize-set-variable 'lsp-headerline-breadcrumb-enable-diagnostics nil)
  (customize-set-variable 'lsp-ui-doc-show-with-mouse nil)
  (customize-set-variable 'lsp-ui-doc-show-with-cursor t)
  (customize-set-variable 'lsp-rust-server 'rust-analyzer)
  (customize-set-variable 'lsp-semantic-tokens-enable t)
  (customize-set-variable 'lsp-rust-analyzer-server-display-inlay-hints t)

  ;; +------------+
  ;; |   Python   |
  ;; +------------+

  (setq-default pytest-project-root-files
                '("setup.py" ".git" ".hg" "pyproject.toml" ".projectile"))
  (customize-set-variable 'blacken-line-length 79)

  ;; +-------------+
  ;; |    c-c++    |
  ;; +-------------+

  (customize-set-variable 'c-basic-offset 4)

  ;; +--------------+
  ;; |   Flycheck   |
  ;; +--------------+

  (customize-set-variable 'flycheck-disabled-checkers '(python-flake8))
  (customize-set-variable 'flycheck-indication-mode 'left-margin)

  ;; Adjust margins and fringe widths...
  (defun my-set-flycheck-margins ()
    (setq left-fringe-width 8 right-fringe-width 8
          left-margin-width 1 right-margin-width 0)
    (flycheck-refresh-fringes-and-margins))

  ;; ...every time Flycheck is activated in a new buffer
  (add-hook 'flycheck-mode-hook #'my-set-flycheck-margins)

  ;; +---------+
  ;; |   DAP   |
  ;; +---------+

  (customize-set-variable 'dap-ui-mode t)
  (customize-set-variable 'dap-ui-controls-mode t)

  ;; +--------------+
  ;; |   Treemacs   |
  ;; +--------------+

  (customize-set-variable 'treemacs-position 'right)

  ;; +------------------+
  ;; |   Shell-script   |
  ;; +------------------+

  (setq-default shfmt-arguments '("-i" "4"))

  ;; +---------------+
  ;; |   Evil-mode   |
  ;; +---------------+

  (customize-set-variable 'evil-escape-delay 0.1)

  ;; +---------+
  ;; |   Org   |
  ;; +---------+

  (with-eval-after-load 'org
    (setq-default org-superstar-headline-bullets-list
                  '("◉" "☉" "●" "○" "⚫" "◎" "○" "◌" "◎" "◦" "◯" "⚪" "⚬" "❍" "￮" "⊙" "⊚" "⊛" "∙" "∘"))
    (setq-default org-latex-caption-above nil)
    (setq-default org-latex-table-caption-above nil)
    ;; Latex-org
    (add-to-list 'org-latex-packages-alist '("" "listings" nil))
    (setq-default org-latex-listings t)
    (setq-default org-latex-listings-options '(("breaklines" "true")
                                               ("showstringspaces" "false")))
    ;;=========================
    (setq-default org-startup-indented t)
    (setq-default org-directory "~/Documents/org")
    (setq-default org-default-notes-file (concat org-directory "/notes.org"))
    (setq-default org-agenda-files (flatten-tree
                                    (list
                                     (concat org-directory "/agenda.org")
                                     (file-expand-wildcards "~/software/sadel/agenda/*.org"))))
    (setq-default org-projectile-capture-template
                  (concat "* TODO [[file:%(my-org-capture-relative-name)::"
                          "%(my-org-line-number)][%(my-org-capture-relative-name):"
                          "%(my-org-line-number)]]\n%(my-org-line-content)%?\n"))
    (setq-default org-link-file-path-type 'relative))

  ;; Helper functions for capturing TODOs with org-projectile-capture-template...
  ;; ...gets file relative path (org-link-file-path-type does not work)...
  (defun my-org-capture-relative-name ()
    (kill-new (file-relative-name
               (or (org-capture-get :original-file)
                   (org-capture-get :original-file t))
               (projectile-project-root))))

  (defun my-major-mode-to-org-src ()
    (string-trim-right (symbol-name major-mode) "-mode"))

  ;; ...gets current line or selected region, wrapping it in SRC-code block...
  (defun my-org-line-content ()
    (with-current-buffer (org-capture-get :original-buffer)
      (let ((selected-content
             (if (use-region-p)
                 (buffer-substring
                  (region-beginning)
                  (region-end))
               (buffer-substring
                (line-beginning-position)
                (line-end-position)))))
        (format "#+BEGIN_SRC %s\n%s\n#+END_SRC"
                (my-major-mode-to-org-src)
                selected-content))))

  ;; ...gets line number.
  (defun my-org-line-number ()
    (with-current-buffer
        (org-capture-get :original-buffer) (number-to-string (line-number-at-pos))))

  ;; +----------------+
  ;; |   Projectile   |
  ;; +----------------+

  (with-eval-after-load 'projectile
    (mapc (lambda (x)
            (add-to-list 'projectile-globally-ignored-directories x))
          '("*.mypy_cache" "*target" "*docs" "doxydoc" "*bin" "*.venv" "*venv" "*.pytest_cache" "*__pycache__" "*build_Test" "*build_Debug" "*build_Release" "build" "*dist" "*.egg-info*" "*.ld"))
    (customize-set-variable 'projectile-indexing-method 'hybrid)
    (customize-set-variable 'projectile-enable-caching t)
    (customize-set-variable 'projectile-track-known-projects-automatically nil)
    (customize-set-variable 'projectile-svn-command projectile-generic-command)
    (customize-set-variable 'projectile-git-command projectile-generic-command)
    (customize-set-variable 'helm-ag-ignore-patterns projectile-globally-ignored-directories))

  ;; Add and remove from both projectile and treemacs.
  (defun my-add-project-and-treemacs (dir)
    (interactive (list (read-directory-name "Add to known projects: ")))
    (projectile-add-known-project dir)
    (treemacs-do-add-project-to-workspace dir
                                          (file-name-nondirectory
                                           (directory-file-name
                                            (file-name-directory dir)))))

  (defun my-remove-project-and-treemacs (dir)
    (interactive (list (projectile-completing-read
                        "Remove from known projects: " projectile-known-projects)))
    (treemacs-do-remove-project-from-workspace dir)
    (projectile-remove-known-project dir))

  ;; +--------------------------+
  ;; |  Terminal configuration  |
  ;; +--------------------------+

  ;; C-r bind correctly
  (defun my-term-setup-term-mode ()
    (evil-local-set-key 'insert (kbd "C-r") 'my-term-send-C-r))

  (defun my-term-send-C-r ()
    (interactive)
    (term-send-raw-string "\C-r"))

  (add-hook 'term-mode-hook 'my-term-setup-term-mode)

  ;; Quickly open terminal in a new vertical split"
  (defun my-term-in-vsplit ()
    (interactive)
    (evil-window-vsplit)
    (evil-window-right 1)
    (let ((current-prefix-arg '(4))) ;; emulate C-u
      (call-interactively 'spacemacs/default-pop-shell) ;; invoke align-regexp interactively
      (rename-uniquely)))

  (defun my-term-in-split ()
    (interactive)
    (evil-window-split)
    (evil-window-down 1)
    (let ((current-prefix-arg '(4))) ;; emulate C-u
      (call-interactively 'spacemacs/default-pop-shell) ;; invoke align-regexp interactively
      (rename-uniquely)))

  (spacemacs|define-custom-layout "@Terminal"
    :binding "l"
    :body
    (spacemacs/default-pop-shell)
    (spacemacs/toggle-maximize-buffer))

  ;; Makes normal-mode I works like C-a in normal terminal emulators
  (defun my-vterm-evil-insert-at-start ()
    (interactive)
    (vterm-send-C-a)
    (call-interactively 'evil-insert))

  (defun my-vterm-hook()
    (evil-local-mode 1)
    (evil-define-key 'normal 'local "I" 'my-vterm-evil-insert-at-start))

  (add-hook 'vterm-mode-hook 'my-vterm-hook)

  ;; Faster refresh when scrolling
  (with-eval-after-load 'vterm
    (setq-default vterm-timer-delay nil)
    (customize-set-variable 'vterm-max-scrollback 100000))

)


;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yasnippet-snippets yapfify yaml-mode xterm-color ws-butler writeroom-mode winum which-key web-mode web-beautify volatile-highlights vim-powerline vi-tilde-fringe uuidgen use-package unfill undo-tree treemacs-projectile treemacs-persp treemacs-magit treemacs-icons-dired treemacs-evil toml-mode toc-org terminal-here term-cursor tagedit systemd symon symbol-overlay string-inflection string-edit-at-point sphinx-doc spacemacs-whitespace-cleanup spacemacs-purpose-popwin spaceline-all-the-icons space-doc smeargle slim-mode shfmt shell-pop scss-mode sass-mode rust-mode ron-mode restart-emacs realgud rainbow-delimiters quickrun pytest pylookup pyenv-mode pydoc py-isort pug-mode prettier-js popwin poetry pippel pipenv pip-requirements pdf-view-restore pcre2el password-generator paradox overseer orgit-forge org-superstar org-rich-yank org-projectile org-present org-pomodoro org-mime org-download org-contrib org-cliplink open-junk-file npm-mode nose nord-theme nodejs-repl nameless mwim multi-vterm multi-term multi-line mmm-mode markdown-toc macrostep lsp-ui lsp-python-ms lsp-pyright lsp-origami lorem-ipsum livid-mode live-py-mode link-hint json-reformat json-navigator json-mode js2-refactor js-doc journalctl-mode inspector insert-shebang info+ indent-guide importmagic impatient-mode hybrid-mode hungry-delete holy-mode hl-todo highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-xref helm-themes helm-swoop helm-rtags helm-pydoc helm-purpose helm-projectile helm-org-rifle helm-org helm-mode-manager helm-make helm-lsp helm-ls-git helm-git-grep helm-descbinds helm-ctest helm-css-scss helm-company helm-c-yasnippet helm-ag google-translate google-c-style golden-ratio gnuplot gitignore-templates git-timemachine git-modes git-messenger git-link gh-md gendoxy fuzzy font-lock+ flycheck-ycmd flycheck-rust flycheck-rtags flycheck-pos-tip flycheck-package flycheck-elsa flycheck-bashate flx-ido fish-mode fancy-battery eyebrowse expand-region evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-textobj-line evil-surround evil-org evil-numbers evil-nerd-commenter evil-matchit evil-lisp-state evil-lion evil-indent-plus evil-iedit-state evil-goggles evil-exchange evil-evilified-state evil-escape evil-easymotion evil-collection evil-cleverparens evil-args evil-anzu eval-sexp-fu eshell-z eshell-prompt-extras esh-help emr emmet-mode elisp-slime-nav elisp-def editorconfig dumb-jump drag-stuff dotenv-mode dockerfile-mode docker-tramp docker disaster dired-quick-sort diminish diff-hl devdocs define-word dap-mode cython-mode csv-mode cpp-auto-include company-ycmd company-web company-shell company-rtags company-quickhelp company-c-headers company-anaconda column-enforce-mode code-cells cmake-mode clean-aindent-mode centered-cursor-mode ccls cargo browse-at-remote blacken better-jumper auto-yasnippet auto-highlight-symbol auto-compile aggressive-indent ace-link ace-jump-helm-line ac-ispell)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
