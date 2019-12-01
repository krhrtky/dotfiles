export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history

zplug "mafredri/zsh-async", from:github
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "mollifier/anyframe"
zplug "rupa/z", use:z.sh
#zplug "sorin-ionescu/prezto"
#zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
#zplug "themes/robbyrussell", from:oh-my-zsh
#zplug "agnoster", from:oh-my-zsh
#zplug "themes/funky", from:oh-my-zsh
#zplug "themes/gnzh", from:oh-my-zsh
zplug "b4b4r07/enhancd", use:enhancd.sh


# prezto のプラグインやテーマを使用する
#zplug "modules/osx", from:prezto, if:"[[ $OSTYPE == *darwin* ]]"
#zplug "modules/prompt", from:prezto
## zstyle は zplug load の前に設定する
#zstyle ':prezto:module:prompt' theme 'sorin'

# install plugin
if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

function powerline_precmd() {
    PS1="$(powerline-shell --shell zsh $?)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
    install_powerline_precmd
fi

function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi
# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧をカラー表示
zstyle ':completion:*' list-colors ''

# コマンドのスペルを訂正
setopt correct
# ビープ音を鳴らさない
setopt no_beep

# enhancd config
export ENHANCD_COMMAND=ed
export ENHANCD_FILTER=ENHANCD_FILTER=fzy:fzf:peco

# prompt
autoload -Uz vcs_info
#setopt prompt_subst
#zstyle ':vcs_info:git:*' check-for-changes true
#zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
#zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
#zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
#zstyle ':vcs_info:*' actionformats '[%b|%a]'
#precmd() { vcs_info }
#PROMPT='%m:%F{green}%~%f %n %F{yellow}$%f '
#RPROMPT='${vcs_info_msg_0_}'

bindkey -v

# alias
alias ls='exa'
alias lt='exa -lT'
alias la='exa -alhBG'
alias ll='exa -alhBG'
#alias ls='ls -aF'
#alias ll='ls -l'
#alias rm='rm -i'
#alias cp='cp -i'
#alias mv='mv -i'
alias vi='nvim'
alias view='nvim -R'
alias cat='cat -n'
alias less='less -NM'
alias bd='cd ..'
alias mkdir='mkdir -p'
export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

#export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
#export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin

# *env
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

export PATH="/usr/local/opt/openssl/bin:$PATH"
zle -N peco-history-selection
bindkey '^R' peco-history-selection

ulimit -n 2048

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PATH=${JAVA_HOME}/bin:${PATH}
eval "$(direnv hook zsh)"

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /Users/takuya.kurihara/.npm/_npx/40791/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/takuya.kurihara/.npm/_npx/40791/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /Users/takuya.kurihara/.npm/_npx/40791/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/takuya.kurihara/.npm/_npx/40791/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /Users/takuya.kurihara/.npm/_npx/53486/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /Users/takuya.kurihara/.npm/_npx/53486/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zshexport PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
