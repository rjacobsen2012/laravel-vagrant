# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
#

sudo cp ~/server-setup/cobalt2-custom.zsh-theme ~/.oh-my-zsh/themes/
sudo cp ~/server-setup/iTerm2-custom.zsh ~/.oh-my-zsh/custom/

ZSH_THEME="cobalt2-custom"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

alias art="php artisan"
alias migrate="php artisan migrate"
alias migrate:rollback="php artisan migrate:rollback"
alias seed="php artisan db:seed"
alias fire="php artisan event:fire"
alias add="git add --all"
alias add.="git add ."
alias commit="git commit -m"
alias push="git push"
alias pull="git pull"
alias fetch="git fetch"
alias phpunit="vendor/phpunit/phpunit/phpunit"
alias fphpunit="vendor/phpunit/phpunit/phpunit --stop-on-error --stop-on-failure"

alias regen='composer dumpautoload; art ide-helper:generate'

alias gvl='cd ~/development/work/projects/gvl'
alias cbi='cd ~/development/work/projects/cbi/CBICurrent'
alias sub='cd ~/development/work/projects/Subcontract'
alias pc="vendor/phpunit/phpunit/phpunit --coverage-html /var/www/vagrant/phpunit-coverage"
alias pctemp="vendor/phpunit/phpunit/phpunit --coverage-html /var/www/vagrant/phpunit-coverage-temp"
alias dumpseed="composer dumpautoload; art migrate:refresh --seed"
alias www='cd ~/development/work/projects'
alias gvlvagrant='cd ~/development/work/gvlvagrant'

export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"

alias regen='composer dumpautoload; art ide-helper:generate'
export PATH="/usr/local/opt/libxml2/bin:$PATH"

source ~/.oh-my-zsh/custom/iTerm2-custom.zsh

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

