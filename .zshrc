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
alias y='yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/best" --merge-output-format mp4 -P "/sdcard/Download" -o "%(title)s.%(ext)s" --exec "termux-media-scan {}"'

# Скачивание АУДИО в глобальную папку Download/Music телефона + автосканирование в Плеер
alias ya='yt-dlp -x --audio-format mp3 --audio-quality 320k --embed-thumbnail --add-metadata -P "/sdcard/Download/Music" -o "%(title)s.%(ext)s" --exec "termux-media-scan {}"'


# Ручное сканирование глобальной папки Download
alias scan='termux-media-scan -r /sdcard/Download'

alias update='pkg update && pkg upgrade -y'

# ── Termux Dotfiles Manager ──────────────────────────────────────
# 1. Основной алиас как на ПК (ручное управление)
alias config='git'

# 2. Ленивый авто-пуш в 1 слово (для телефона)
tpush() {
    cd ~
    git add ~/.zshrc ~/.p10k.zsh ~/.config/fastfetch/config.jsonc ~/README.md
    local msg="${1:-Update Termux dotfiles $(date +'%Y-%m-%d %H:%M')}"
    git commit -m "$msg" && git push origin main
}

# 3. Ленивое авто-обновление в 1 слово (стянуть с GitHub + применить)
tpull() {
    cd ~ && git pull origin main && exec zsh
}

# ── Aider + Gemini Setup ─────────────────────────────────────────
export GEMINI_API_KEY=""
alias aider-proxy='HTTP_PROXY=http://127.0.0.1:12334 HTTPS_PROXY=http://127.0.0.1:12334 ALL_PROXY=socks5://127.0.0.1:12334 aider --model gemini/gemini-3.1-flash-lite'
alias aider-smart='HTTP_PROXY=http://127.0.0.1:12334 HTTPS_PROXY=http://127.0.0.1:12334 ALL_PROXY=socks5://127.0.0.1:12334 aider --model gemini/gemini-3-flash-preview'

# System fetch on interactive shell start
if [[ $- == *i* ]]; then
    fastfetch -l android_small
fi

nya() {
    local url="$1"
    local ep="$2"
    # Если номер серии забыли указать, скрипт использует случайное число
    [[ -z "$ep" ]] && ep=$RANDOM

    yt-dlp -f "bv*+ba/best" \
      --merge-output-format mkv \
      --embed-subs --embed-thumbnail --embed-chapters --add-metadata \
      --sub-langs "ru.*,en.*,all" \
      --fragment-retries infinite --concurrent-fragments 5 --legacy-server-connect \
      -P "/sdcard/Download/Anime" \
      -o "Серия_${ep}.%(ext)s" \
      "$url"
}
