#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ssh -T git@github.com &> /dev/null

    if [ $? -ne 1 ]; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    print_in_purple "\n • Update content\n\n"

    git fetch --all 1> /dev/null \
        && git reset --hard origin/main 1> /dev/null \
        && git checkout main &> /dev/null \
        && git clean -fd 1> /dev/null

    print_result $? "Update content"

}

main
