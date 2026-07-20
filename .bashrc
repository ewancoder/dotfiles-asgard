#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Export shared parts between shells.
source .shellrc
export PATH="$HOME/.local/bin:$PATH"
