if [[ $- == *i* ]]; then
    fastfetch -l android_small
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Path
export PATH="$PATH:$HOME/.local/bin"

# ── Useful Aliases (Termux) ──────────────────────────────────────
# Скачивание ВИДЕО в глобальную папку Download телефона + автосканирование в Галерею
alias y='yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/b[ext=mp4]/best" --merge-output-format mp4 -P "/sdcard/Download/Video" -o "%(title)s.%(ext)s" --exec "termux-media-scan {}"'

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

# Аниме по сериям: nya [номер_первой_серии] url1 url2 ...
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

# Ручное сканирование глобальной папки Download
alias scan='termux-media-scan -r /sdcard/Download'

alias update='pkg update && pkg upgrade -y && apt autoremove -y && apt clean'

# ── Dotfiles (GNU Stow) ──────────────────────────────────────────
export DOTFILES="$HOME/Termux-dotfiles"
alias config='git -C "$DOTFILES"'

dpush() {
  git -C "$DOTFILES" add -u || return
  local new
  new=$(git -C "$DOTFILES" ls-files --others --exclude-standard)
  if [[ -n $new ]]; then
    echo "⚠ не добавлены новые файлы (config add -- <файл>):"
    echo "$new"
  fi
  git -C "$DOTFILES" commit -m "${1:-Update Termux dotfiles $(date +'%F %H:%M')}" \
    && git -C "$DOTFILES" push -u origin main
}
alias cpush=dpush

cpull() {
  git -C "$DOTFILES" pull --no-rebase origin main \
    && "$DOTFILES/install.sh" \
    && exec zsh
}

# Промпт Starship
eval "$(starship init zsh)"
