#!/bin/bash

# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------

ensure_term() {

    # if [ -z "$TERM" ]; then
        export TERM="xterm-256color"
    # fi
}

verify_os() {

    declare -r MINIMUM_UBUNTU_VERSION="20.04"
    declare -r MINIMUM_ZORIN_VERSION="16"
    declare -r MINIMUM_DEBIAN_VERSION="11"

    . /etc/os-release

    local os_name=$ID
    local os_version=$VERSION_ID

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if the OS is `ubuntu` or `debian` and
    # it's above the required version.

    if [ "$os_name" == "ubuntu" ]; then

        if is_supported_version "$os_version" "$MINIMUM_UBUNTU_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for Ubuntu %s+\n" "$MINIMUM_UBUNTU_VERSION"
        fi

    elif [ "$os_name" == "zorin" ]; then

        if is_supported_version "$os_version" "$MINIMUM_ZORIN_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for Zorin %s+\n" "$MINIMUM_ZORIN_VERSION"
        fi

    elif [ "$os_name" == "debian" ]; then

        if is_supported_version "$os_version" "$MINIMUM_DEBIAN_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for Debian %s+\n" "$MINIMUM_DEBIAN_VERSION"
        fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    else
        printf "Sorry, this script is intended only for Ubuntu, Zorin or Debian (you're using %s %s)\n" "$os_name" "$os_version"
    fi

    return 1

}

verify_git() {

    # We need at least git version 2.34.0 to sign with ssh keys

    declare -r MINIMUM_GIT_VERSION="2.34.0"

    local git_version
    
    git_version=$(git --version | cut -d' ' -f3)

    if ! is_supported_version "$git_version" "$MINIMUM_GIT_VERSION"; then
        printf "Sorry, this script needs git version %s+ to sign commits with an ssh key\n" "$MINIMUM_GIT_VERSION"
        return 1
    fi
}

# ----------------------------------------------------------------------
# | Main                                                               |
# ----------------------------------------------------------------------

main() {

    # Ensure that the following actions
    # are made relative to this file's path.

    cd "$(dirname "${BASH_SOURCE[0]}")" \
        || exit 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Make sure we have a $TERM, to stop tput from complaining

    ensure_term

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Load utils

    . "utils.sh" || exit 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Ensure the OS is supported and
    # it's above the required version.

    verify_os \
        || exit 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ./os/installs/main.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Ensure git is supported and
    # it's above the required version.

    verify_git \
        || exit 1

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # ./os/create_directories.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ./os/create_symbolic_links.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ./os/create_local_config_files.sh
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ./os/check_for_updates.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    echo ""

}

main
