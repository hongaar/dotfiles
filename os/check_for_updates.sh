#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    print_in_purple "\n • Checking for updates\n\n"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! cmd_exists "git"; then

        print_warning "Could not find git, skipping"
        return 1

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! git remote update &> /dev/null; then

        print_warning "Could not update remotes, skipping"
        return 1

    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [[ $(git diff main origin/main) ]]; then

        print_error "dotfiles are outdated, please run 'git pull origin main'"

    else

        print_success "dotfiles are up to date"

    fi

}

main
