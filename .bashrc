#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim=nvim
alias vi=nvim


PS1='[\u@\h \W]\$ '
export PATH=$PATH:~/.local/bin

# Add EdkRepo command completions https://github.com/tianocore/edk2-edkrepo
[[ -r "/home/pwandzil/.edkrepo/edkrepo_completions.sh" ]] && . "/home/pwandzil/.edkrepo/edkrepo_completions.sh"
export PATH="/home/pwandzil/bin:$PATH"

# Add opt/bin to path
PATH=$PATH:/opt/bin

# EDITOR env variable for git & other tools
export EDITOR=nvim


