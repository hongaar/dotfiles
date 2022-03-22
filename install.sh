#!/bin/bash

# ----------------------------------------------------------------------
# | Helper Functions                                                   |
# ----------------------------------------------------------------------

verify_os() {

    declare -r MINIMUM_UBUNTU_VERSION="20.04"
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
            printf "Sorry, this script is intended only for Ubuntu %s+" "$MINIMUM_UBUNTU_VERSION"
        fi

    elif [ "$os_name" == "debian" ]; then

        if is_supported_version "$os_version" "$MINIMUM_DEBIAN_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for Debian %s+" "$MINIMUM_DEBIAN_VERSION"
        fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    else
        printf "Sorry, this script is intended only for Ubuntu or Debian!"
    fi

    return 1

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

    # ./os/create_directories.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ./os/create_symbolic_links.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ./os/create_local_config_files.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # ./os/installs/main.sh
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    ./os/check_for_updates.sh

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

main
