#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PKGS=(zsh fastfetch starship yt-dlp pkglists)
BK="$HOME/dotfiles-backup/stow-$(date +%F_%H%M%S)"
for p in "${PKGS[@]}"; do
  [[ -d $p ]] || continue
  while IFS= read -r -d '' f; do
    rel="${f#"$p"/}"; t="$HOME/$rel"
    if [[ -e $t && ! -L $t ]]; then mkdir -p "$BK/$(dirname "$rel")"; mv "$t" "$BK/$rel"; fi
  done < <(find "$p" -type f -print0)
  stow --no-folding -t "$HOME" -R "$p"
done
echo "готово (бэкап конфликтов, если были: $BK)"
