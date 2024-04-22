# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH=$PATH:/home/vchokshi/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/vchokshi/google-cloud-sdk/path.bash.inc' ]; then . '/home/vchokshi/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/vchokshi/google-cloud-sdk/completion.bash.inc' ]; then . '/home/vchokshi/google-cloud-sdk/completion.bash.inc'; fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.tfenv/bin:$PATH"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

alias ll='ls -l'
alias l='ls -CF'

check_deps() {
  command -v pass >/dev/null 2>&1 || { echo >&2 "Error: pass not found"; }
  command -v python3 >/dev/null 2>&1 || { echo >&2 "Error: python3 not found"; }
  command -v gcloud >/dev/null 2>&1 || { echo >&2 "Error: gcloud not found"; }
  command -v aws >/dev/null 2>&1 || { echo >&2 "Error: AWS CLI found"; }
  command -v az >/dev/null 2>&1 || { echo >&2 "Error: Azure CLI not found"; }
  command -v terraform >/dev/null 2>&1 || { echo >&2 "Error: terraform not found"; }
}
check_deps

load_secrets() {
  check_deps
  export AWS_PROFILE=iot4
  export DO_PAT=$(pass DO_API_TOKEN)
  export DO_REGISTRY_DOCKERCONFIG=$(pass do/registry/dockerconfigjson)
  export SLACK_WEBHOOK_VPN=$(pass slack/webhook/vpn)
  export SLACK_WEBHOOK_DARKNET=$(pass slack/webhook/darknet)
  export SLACK_WEBHOOK_GRAVITY=$(pass slack/webhook/gravity)
  export ATLANTIS_WEBHOOK_SECRET=$(pass atlantis_webhook_secret)
  export CCM_ROBOT_PAT=$(pass ccm-robot-pat)
  export VP=$(pass vihars_password)
  export TF_VAR_VP=$(pass vihars_password)
  export TF_VAR_atlantis_webhook_secret=$ATLANTIS_WEBHOOK_SECRET
  export TF_VAR_ccm_robot_pat=$CCM_ROBOT_PAT
  export ELASTIO_API_KEY=$(pass elastio)
  export GITHUB_TOKEN=$(pass github/vchokshi)
  export HONEYCOMB_TOKEN=$(pass honeycomb.io)
  export NEWRELIC_TOKEN=$(pass newrelic_ingest)
  export NEWRELIC_API_KEY=$(pass newrelic_api_key)
  export NEWRELIC_ACCOUNT_NUMBER=$(pass new_relic_account_number)
  export TWILIO_TOKEN=$(pass twillio)
  export OPENAI_API_KEY=$(pass openai_api_key)
  export TF_VAR_atlassian_api_token=$(pass atlassian)
  export TF_VAR_GITHUB_TERRAFORM_CLOUD_OAUTH_TOKEN_ID=$(pass github/terraform_cloud_oauth)
  export TF_VAR_newrelic_token=$NEWRELIC_TOKEN
  export TF_VAR_do_token=$DO_PAT
}

canary_test(){
    export AWS_PROFILE=canary
}

clear_secrets() {
	unset $(compgen -v | grep AWS)
	unset $(compgen -v | grep ATLANTIS)
	unset $(compgen -v | grep CCM_ROBOT)
	unset $(compgen -v | grep ELASTIO)
	unset $(compgen -v | grep GITHUB_TOKEN)
	unset $(compgen -v | grep HONEYCOMB_TOKEN)
	unset $(compgen -v | grep NEWRELIC)
	unset $(compgen -v | grep TWILIO_TOKEN)
	unset $(compgen -v | grep TF_VAR)
	unset $(compgen -v | grep OPENAI)
	unset $(compgen -v | grep SLACK)
}

aws_assume_role() {
  account=$(pass aws/$1/acctnumber)
  ROLE=OrganizationAccountAccessRole
  OUT=$(aws sts assume-role --role-arn arn:aws:iam::$account:role/$ROLE --role-session-name vc@control@$1);\
	export AWS_ACCESS_KEY_ID=$(echo $OUT | jq -r '.Credentials''.AccessKeyId');\
	export AWS_SECRET_ACCESS_KEY=$(echo $OUT | jq -r '.Credentials''.SecretAccessKey');\
	export AWS_SESSION_TOKEN=$(echo $OUT | jq -r '.Credentials''.SessionToken');
  export AWS_PROFILE=$1
}

alias asgci="aws sts get-caller-identity"
alias tfi="terraform init"
alias tff="terraform fmt"
alias tfp="tff && terraform plan"
alias tfa="terraform apply"
alias tfaa="terraform apply --auto-approve"
alias gbrv="git branch -r | grep $USER"
alias gbuu="git branch --unset-upstream"
alias gfp="git fetch && git pull"
alias grbi="git rebase -i"
alias gst="git status"
alias ga="git add ."
alias gc="git commit -v"
alias gp="git push"
alias gpf="git push --force"
alias gcan!="git commit -v -a --no-edit --amend"
alias ghprc="gbuu && gh pr create"
case $SHELL in
*/zsh)
  alias rr="source ~/.zshrc"
  ;;
*/bash)
  alias rr="source ~/.bashrc"
  ;;
*)
   # assume something else
esac

alias dodns="doctl compute domain records list do.iot4.net"
alias dodrops="doctl compute droplet list"
alias dolbs="doctl compute load-balancer list"

gbsu() {
	git branch --set-upstream-to=origin/$1
}

activate() {
	. ~/.venvs/$1/bin/activate
}

rmenv() {
	rm -rf ~/.venvs/$1
}

makeenv() {
	python3 -m venv ~/.venvs/$1 && activate $1
}

cherrypick() {
    # This needs a help file and a usage instructions.
    if [ -z "$1" ] && [ -z "$2" ]
    then
        echo "Usage cherry-pick [GIT_AUTHOR_DATE] [GIT_COMMITER_DATE] [GIT_HASH]. Uses git lgc output"
        return
    fi

    GIT_AUTHOR_DATE='$1' GIT_COMMITTER_DATE='$2' git cherry-pick $3
}
cleanup() {
    find ~/ccm -type d -name node_modules -exec rm -r {} \;
    rm -r $HOME/.terraform.d/plugin-cache/registry.terraform.io/hashicorp/aws/*
    docker system prune -a -f
    sudo journalctl --vacuum-time=2d
    sudo apt-get clean
    npm cache clean --force
}
