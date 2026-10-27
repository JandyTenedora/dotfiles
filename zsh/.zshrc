# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration
export DOCKER_BUILDKIT=0

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

eval "$(/opt/homebrew/bin/brew shellenv)"

ulimit -n 8192

export PATH="$HOME/.local/bin:$PATH"

alias gdupload='gdrive-upload'

export PATH="/opt/homebrew/bin:$PATH"

# Java managed by SDKMAN (see end of file)


source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

typeset -ga CODEX_DEFAULT_ARGS=()

codex() {
  command codex "${CODEX_DEFAULT_ARGS[@]}" "$@"
}

codexa() {
  emulate -L zsh

  local start_pet=0
  local pet_name=""
  local -a codex_args
  codex_args=()

  while (( $# )); do
    case "$1" in
      --pet)
        start_pet=1
        if (( $# > 1 )) && [[ "$2" != --* ]]; then
          pet_name="$2"
          shift
        fi
        ;;
      --pet=*)
        start_pet=1
        pet_name="${1#--pet=}"
        ;;
      --no-pet)
        start_pet=0
        pet_name=""
        ;;
      --list-pets)
        /Users/user/.codex/codex-pet-overlay/scripts/select-pet.sh list
        return $?
        ;;
      --help)
        print -r -- "usage: codexa [--pet[=NAME]|--pet NAME] [--no-pet] [--list-pets] [codex args...]"
        print -r -- ""
        print -r -- "Runs: codex using defaults from ~/.codex/config.toml"
        print -r -- "Use 'codexa -- --help' to pass --help through to Codex."
        return 0
        ;;
      --)
        shift
        codex_args+=("$@")
        break
        ;;
      *)
        codex_args+=("$1")
        ;;
    esac
    shift
  done

  if (( start_pet )); then
    if [[ -n "$pet_name" ]]; then
      /Users/user/.codex/codex-pet-overlay/scripts/select-pet.sh "$pet_name" >/dev/null || return $?
    elif ! /usr/bin/pgrep -f CodexPetOverlay >/dev/null 2>&1; then
      /Users/user/.codex/codex-pet-overlay/scripts/run-detached.sh >/dev/null || return $?
    fi
  fi

  command codex "${CODEX_DEFAULT_ARGS[@]}" "${codex_args[@]}"
}
alias codex-auto=codexa

# Rust/Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# Fluss: run Maven in a Linux Docker container (macOS arm64 compat)
fluss_mvn() {
  mkdir -p /tmp/fluss-m2-docker

  docker run --rm -it --platform linux/amd64 \
    -u "$(id -u):$(id -g)" \
    -v "$PWD:/workspace" \
    -v /tmp/fluss-m2-docker:/m2 \
    -w /workspace \
    maven:3.9.9-eclipse-temurin-11 \
    mvn -Dmaven.repo.local=/m2 "$@"
}

alias nvima='NVIM_MINIMAL_UI=1 nvim'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
