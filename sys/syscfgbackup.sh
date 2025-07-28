#!/bin/sh
# -*- mode: sh; -*- vim: ft=sh:ts=2:sw=2:norl:et:
# Time-stamp: <2025-07-27 19:30:21 cf>
# Box: cf [Linux 6.15.6-zen1-1-zen x86_64 GNU/Linux]

# Set backup destination
BACKUP_DIR="$HOME/Backups/4-sys/"
BACKUP_DATE=$(date +"%Y-%m-%d_%H")
BACKUP_NAME="syscfg_$BACKUP_DATE.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

CONFIG_PATHS=( # user configurations
    "$HOME/.gnupg"                                  # GPG keyring
    "$HOME/.ssh"                                    # SSH keys
    "$HOME/.local/share/keyrings"                   # Keyrings
    "$HOME/.local/share/password-store/"            # Keyrings
    "$HOME/.local/share/desktop-directories"        # desktop-dirs
    "$HOME/.config/mimeapps.list"                   # mimeapps
    "$HOME/.local/share/mime"                       # mime
    "$HOME/.local/share/larbs"                      # icons
    "$HOME/.config/user-dirs.dirs"                  # user directories
    "$HOME/.config/shell"                           # shell configs
    "$HOME/.config/x11"                             # X11 profile
    "$HOME/.config/zsh"                             # zshell
    "$HOME/.local/bin"                              # user scripts
    "$HOME/Scripts"                                 # scripts
    "$HOME/.config/.infokey"                        # info profile
    "$HOME/.config/tmux"                            # tmux
    "$HOME/.local/share/tmux"                       # tmux sessions
    "$HOME/.config/picom"                           # compositor profiles
    "$HOME/.config/mpd"                             # sound daemon
    "$HOME/.config/pipewire"                        # sound server
    "$HOME/.config/wireplumber/"                    # sound server
    "$HOME/.config/pulsemixer.cfg"                  # sound mixer
    "$HOME/.config/bluez"                           # bluetooth config
    "$HOME/.config/dunst"                           # notifications
    "$HOME/.config/mutt"                            # email
    "$HOME/.config/notmuch-config"                  # email config
    "$HOME/.config/mbsync"                          # email config
    "$HOME/.config/msmtp/"                          # email config
    "$HOME/.msmtprc"                                # email config
    "$HOME/.config/abook"                           # contacts
    "$HOME/.config/calcurse"                        # agenda
    "$HOME/.local/share/calcurse"                   # calendar
    "$HOME/.config/newsboat"                        # newsfeed
    "$HOME/.config/nsxiv"                           # image viewer
    "$HOME/.config/zathura"                         # pdf reader
    "$HOME/.config/qutebrowser"                     # qutebrowser
    "$HOME/.config/ncmpcpp"                         # music player
    "$HOME/.config/mpv/"                            # media player
    "$HOME/.config/vlc/"                            # media player
    "$HOME/.config/pipe-viewer"                     # yt player
    "$HOME/.config/zinger"                          # quotes
    "$HOME/.config/surfraw"                         # web search
    "$HOME/.config/ytfzf"                           # yt subs
    "$HOME/.config/flameshot"                       # gui screenshots
    "$HOME/.config/cef_user_data"                   # dictionaries
    "/etc/udev/rules.d/99-input-remap.rules"        # input remap rule
    "/etc/mysql/mariadb.conf.d/50-server.cnf"       # mariadb cfg
    "/etc/runit/"                                   # services
    "/etc/X11/xorg.conf.d/"                         # X11 hwinput devices
    "/etc/modprobe.d/"                              # kernel modules
    "/etc/default/grub"                             # grub bootloader
    "/usr/share/plymouth/themes/marjo"              # marjo splash screen
    "/etc/"                                         # etc.
)

NEOVIM_CONFIG=( # neovim configs
    "$HOME/.config/nvim/init.lua"            # neovim init
    "$HOME/.config/nvim/lua/plugins"         # neovim plugins
    "$HOME/.config/nvim/lua/keymaps.lua"     # neovim keymaps
    "$HOME/.config/nvim/lua/opts.lua"        # neovim options
    "$HOME/.local/share/db_ui"               # db queries
)

EXTRA_CONFIGS=( # essential system user builds and configs
    "$HOME/.local/src/dwm"                  # window manager
    "$HOME/.local/src/dwm_patches"          # dwm patches
    "$HOME/.local/src/dwmblocks"            # statusbar rules
    "$HOME/.local/src/dmenu"                # scriptable menu interface
    "$HOME/.local/src/st"                   # simple terminal
    "$HOME/.local/src/picom"                # dev compositor
    "$HOME/.local/src/xmouseless"           # mouse emulation
)

# Don't forget to back up large user data dirs too
# USER_DATA=(
#     "$HOME/Notes"                # notes
#     "XDG_DESKTOP_DIR"            # desktop
#     "XDG_DOWNLOAD_DIR"           # downloads
#     "XDG_PICTURES_DIR"           # pictures
#     "XDG_DOCUMENTS_DIR"          # documents
#     "XDG_TEMPLATES_DIR"          # templates
#     "XDG_MUSIC_DIR"              # music
#     "XDG_VIDEOS_DIR"             # videos
#     "$HOME/.local/src/cf.LARBS"             # bootstrap script
#     "$HOME/.local/src/monkeytype"           # type test custom build
#     "$HOME/.local/src/mpv-sockets"          # mpv unique sockets
#     "$HOME/.local/src/ytfzf"                # yt viewer
#     "$HOME/.local/src/libgrapheme"          # font sizing
# )

# Combine paths for backup
INCLUDE_PATHS=("${CONFIG_PATHS[@]}" "${NEOVIM_CONFIG[@]}" "${EXTRA_CONFIGS[@]}")

# Show estimated backup size
du -ch "${INCLUDE_PATHS[@]}" | grep total

# Create a compressed archive of the backup, preserving paths
tar -czvf "$BACKUP_PATH" --absolute-names "${INCLUDE_PATHS[@]}"

echo "Backup completed: $BACKUP_PATH"

find "$BACKUP_PATH" -type f -mtime +1 -delete
