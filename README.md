# 🤖 Termux Dotfiles by zev1ce — Mobile Obsidian Suite

> *"UNIX in your pocket." — Minimalist, High-Performance CLI & Media Environment for Android.*

Добро пожаловать в мой репозиторий мобильных конфигурационных файлов для **Termux (Android)**. Здесь хранится оптимизированная, сверхлегкая среда командной строки в строгом ахроматическом стиле **Monochrome Obsidian**, синхронизированная с моей рабочей станцией на Arch Linux.

---

## 📱 Характеристики мобильного узла

* 🤖 **OS:** Android (aarch64 / ARMv8)
* ⚙️ **Kernel:** Linux (Android LTS)
* 🖥️ **WM:** `WindowManager (SurfaceFlinger)`
* 🐚 **Shell:** Zsh 5.9.2 + Oh My Zsh + Powerlevel10k (Lean 8-colors)
* ⚡ **Core Suite:** `yt-dlp` (Video / Audio / Anime), `termux-api` (MediaStore Scanner), OpenSSH, Fastfetch
* 🎨 **Theme:** Monochrome Obsidian & Zinc

---

## ⚡ Умный набор команд и алиасов (Media Suite)

Все скачанные файлы автоматически регистрируются в системной медиа-базе Android (`termux-media-scan`), благодаря чему они мгновенно появляются в Галерее, Музыкальном плеере и VLC без перезагрузки телефона!

| Команда | Назначение | Формат | Куда сохраняет | Особенности |
| :--- | :--- | :--- | :--- | :--- |
| **`y <url>`** | YouTube / Видео | MP4 (до 1080p) | `Download/` | Автоскан в системную Галерею |
| **`ya <url>`** | Музыка / Треки | MP3 (VBR 0) | `Download/` | Вшивает обложку, теги и сканирует в Плеер |
| **`nya <url>`** | Аниме / Сериалы | MKV / MP4 | `Download/Anime/` | Вшивает субтитры (RU/EN), главы OP/ED, постер |
| **`scan`** | Ручной медиа-скан | — | `Download/` | Принудительно обновляет медиа-индекс Android |
| **`update`** | Обновление пакетов | — | — | Выполняет `pkg update && pkg upgrade` |

---

## 🔌 Удаленное управление с ПК (SSH over USB via ADB)

Благодаря пробросу портов через ADB можно подключиться к телефону с компьютера на скорости кабеля с нулевым пингом без Wi-Fi:

1. Включите **«Отладку по USB»** на телефоне и подключите кабель к ПК.
2. На компьютере выполните:
   ```bash
   adb forward tcp:8022 tcp:8022
   ssh -p 8022 localhost
   ```
3. *(Опционально)* Алиас для быстрого входа на компьютере:
   ```bash
   alias phone='adb forward tcp:8022 tcp:8022 && ssh -p 8022 localhost'
   ```

---

## 🛠 1. Быстрая установка на чистый телефон (1-Click Restore)

### Шаг 1. Разрешение доступа к памяти и установка пакетов

```bash
termux-setup-storage
pkg update -y && pkg install -y zsh curl git ffmpeg yt-dlp termux-api fastfetch micro bat eza ripgrep python openssh
```
*(При появлении системного окна Android нажмите «Разрешить доступ к памяти»)*.

### Шаг 2. Установка Oh My Zsh и плагинов

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Шаг 3. Клонирование конфигураций из репозитория

```bash
git clone https://github.com/kudryashalex367-create/Termux-dotfiles-.git ~/temp-dotfiles
cp ~/temp-dotfiles/.zshrc ~/.zshrc
cp ~/temp-dotfiles/.p10k.zsh ~/.p10k.zsh
mkdir -p ~/.config/fastfetch
cp ~/temp-dotfiles/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
rm -rf ~/temp-dotfiles
```

### Шаг 4. Создание папок и запуск

```bash
mkdir -p ~/storage/downloads/Anime
chsh -s zsh
exec zsh
```
