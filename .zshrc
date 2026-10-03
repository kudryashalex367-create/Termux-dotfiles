if [[ $- == *i* ]]; then
    fastfetch -l android_small
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Path
export PATH="$PATH:$HOME/.local/bin"

# ── Useful Aliases (Termux) ──────────────────────────────────────
# Скачивание ВИДЕО в глобальную папку Download телефона + автосканирование в Галерею
alias y='yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/best" --merge-output-format mp4 -P "/sdcard/Download/Video" -o "%(title)s.%(ext)s" --exec "termux-media-scan {}"'

# Скачивание АУДИО в глобальную папку Download/Music телефона + автосканирование в Плеер
ya() {
    yt-dlp \
        -f 'ba[ext=opus]/ba[ext=m4a]/ba' \
        --embed-thumbnail \
        --add-metadata \
        --continue \
        --no-overwrites \
        --ignore-errors \
        -P "/sdcard/Download/Audio" \
        -o "%(title)s.%(ext)s" \
        "$@"

    termux-media-scan "/sdcard/Download/Audio"
}

# Ручное сканирование глобальной папки Download
alias scan='termux-media-scan -r /sdcard/Download'

alias update='pkg update && pkg upgrade -y && apt autoremove -y && apt clean'

# ── Termux Dotfiles Manager ──────────────────────────────────────
# 1. Основной алиас как на ПК (ручное управление)
alias config='git'

tpush() {
  cd ~
  git add ~/.zshrc ~/.p10k.zsh ~/.config/fastfetch/config.jsonc ~/README.md ~/.gitignore
  local msg="${1:-Update Termux dotfiles $(date +'%Y-%m-%d %H:%M')}"
  git commit -m "$msg" && git push -u origin main
}

tpull() {
  cd ~ && git pull origin main --no-rebase && exec zsh
}

nya() {
    local current_ep=1
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        current_ep="$1"
        shift
    fi

    for url in "$@"; do
        echo -e "\n==> Скачивание серии $current_ep..."
        
        yt-dlp -f "bv*+ba/best" \
          --merge-output-format mkv \
          --embed-subs --embed-thumbnail --embed-chapters --add-metadata \
          --sub-langs "ru.*,en.*,all" \
          --fragment-retries infinite --concurrent-fragments 5 --legacy-server-connect \
          --downloader aria2c \
          --downloader-args "aria2c:--console-log-level=warn --summary-interval=0" \
          -P "/sdcard/Download/Anime" \
          -o "Серия_${current_ep}.%(ext)s" \
          "$url"
          
        ((current_ep++))
    done

    echo -e "\n==> Сканирование папки Anime..."
    termux-media-scan -r "/sdcard/Download/Anime"
}
