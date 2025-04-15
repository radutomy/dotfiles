# SSH abbreviations
abbr -a pi1 'ssh pi1'
abbr -a pi2 'ssh pi2'
abbr -a sb 'ssh sb'
abbr -a nas 'ssh nas'

# Directory navigation abbreviations
abbr -a w "cd /mnt/c/Users/a-rtomuleasa/Downloads"
abbr -a e "explorer.exe ."
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

# bat abbreviation
abbr -a cat bat --style=plain

# Vim abbreviation
abbr -a vim nvim

bind \ce clear-screen
abbr -a p python

# --- WORK --- #

set CR_PATH ~/ConceptReader
set WORK_PATH ~/.config/work

function build_reader
    cargo build --target aarch64-unknown-linux-musl --manifest-path $CR_PATH/Cargo.toml
end

abbr -a cr 'ssh local-terasic'
abbr -a cr1 "$WORK_PATH/login-ter.exp cr1-terasic"
abbr -a cr2 "$WORK_PATH/login-ter.exp cr2-terasic"
abbr -a qer "build_reader && scp $CR_PATH/target/aarch64-unknown-linux-musl/debug/reader terasic@10.0.0.2:/home/terasic/rt"
abbr -a qer1 "build_reader && $WORK_PATH/transfer-ter.exp cr1-terasic"
abbr -a qer2 "build_reader && $WORK_PATH/transfer-ter.exp cr2-terasic"
abbr -a cb 'cargo build --target aarch64-unknown-linux-musl --manifest-path ~/ConceptReader/Cargo.toml'
