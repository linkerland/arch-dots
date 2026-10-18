#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Display system info on terminal launch
fastfetch

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"

# Starship prompt
eval "$(starship init bash)"
