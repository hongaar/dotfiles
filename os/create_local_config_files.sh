#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

create_bash_local() {

    declare -r FILE_PATH="$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then

        DOTFILES_BIN_DIR="$(dirname "$(pwd)")/bin/"

        printf "%s\n" \
"#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set PATH additions.

PATH=\"$DOTFILES_BIN_DIR:\$PATH\"

export PATH

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" \
        >> "$FILE_PATH"

        print_result $? "$FILE_PATH"

    else

        print_skipped "$FILE_PATH (already exists)"

    fi

}

create_gitconfig_local() {

    declare -r FILE_PATH="$HOME/.gitconfig.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # codespaces

    if [ -n "${CODESPACES}" ]; then

        print_skipped "$FILE_PATH (codespaces)"

        return 1

    fi


    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then

        SSH_KEY_ID="$(ssh-add -L)"
        
        printf "%s\n" \
"[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    gpgsign = true

[tag]

    # When uncommented, lightweight tags will be disabled (?)
    # gpgsign = true

[gpg]

    format = ssh

[user]

    name = Joram van den Boezem
    email = joram@vandenboezem.nl
    signingkey = \"${SSH_KEY_ID//\\//}\"" \
        >> "$FILE_PATH"

        print_result $? "$FILE_PATH"

    else

        print_skipped "$FILE_PATH (already exists)"

    fi

}

create_vimrc_local() {

    declare -r FILE_PATH="$HOME/.vimrc.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >> "$FILE_PATH"

        print_result $? "$FILE_PATH"

    else

        print_skipped "$FILE_PATH (already exists)"

    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Create local config files\n\n"

    create_bash_local
    create_gitconfig_local
    create_vimrc_local

}

main
