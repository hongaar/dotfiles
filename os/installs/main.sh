#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "../../utils.sh" \
    && . "./utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

print_in_purple "\n • Installs\n\n"

#!/bin/bash



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update
upgrade

./git.sh

# ./build-essentials.sh
#./nvm.sh
#./browsers.sh
#./compression_tools.sh
#./image_tools.sh
#./misc.sh
#./misc_tools.sh
#./npm.sh
#./tmux.sh
#./vim.sh

./cleanup.sh

