# SSH abbreviations
abbr -a pi1 'ssh pi1'
abbr -a pi2 'ssh pi2'
abbr -a sb 'ssh sb'
abbr -a nas 'ssh nas'
abbr -a sgw1 '~/.config/work/login-sgw.exp sgw1'
abbr -a sgw2 '~/.config/work/login-sgw.exp sgw2'

# Directory navigation abbreviations
abbr -a w 'cd $winhome/Downloads'
abbr -a g 'cd /mnt/c/gdrive'

# Clear screen abbreviation
abbr -a c clear

# lsd (LSDeluxe) abbreviations
abbr -a ls 'lsd --group-dirs=first'
abbr -a ll 'lsd -lah --group-dirs=first'
abbr -a l 'lsd -A --group-dirs=first'
abbr -a lr 'lsd --tree --group-dirs=first'
abbr -a lx 'lsd -X --group-dirs=first'
abbr -a lt 'lsd --tree --group-dirs=first'

# Vim abbreviation
abbr -a vim nvim

bind yy fish_clipboard_copy
bind Y fish_clipboard_copy
bind p fish_clipboard_paste
