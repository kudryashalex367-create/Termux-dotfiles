# (ᵔᴥᵔ) Termux Dotfiles by zev1ce — Mobile Obsidian Suite

<p align="center">
  <img src="https://img.shields.io/badge/OS-Android-a78bfa?style=flat-square&logo=android&logoColor=white&labelColor=15111f" alt="Android">
  <img src="https://img.shields.io/badge/Terminal-Termux-c4b5fd?style=flat-square&labelColor=15111f" alt="Termux">
  <img src="https://img.shields.io/badge/Shell-Zsh-a78bfa?style=flat-square&logo=gnubash&logoColor=white&labelColor=15111f" alt="Zsh">
  <img src="https://img.shields.io/badge/Prompt-Starship-c4b5fd?style=flat-square&logo=starship&logoColor=white&labelColor=15111f" alt="Starship">
  <img src="https://img.shields.io/badge/Packages-GNU_Stow-a78bfa?style=flat-square&labelColor=15111f" alt="GNU Stow">
  <a href="./LICENSE">
    <img src="https://img.shields.io/badge/License-GPL_v3-c4b5fd?style=flat-square&labelColor=15111f" alt="GNU GPL v3">
  </a>
</p>

> *"UNIX in your pocket." — Минималистичная, производительная CLI и медиа-среда для Android, приведенная к стандарту рабочей станции Arch Linux.*

Репозиторий мобильных конфигурационных файлов для **Termux (Android)** в едином стиле **Obsidian Violet**. Конфигурации организованы в виде независимых пакетов **GNU Stow**, идентично структуре основных десктопных дотфайлов.

---

## (•̀ᴗ•́)و Содержание

- [Характеристики мобильного узла](#specs)
- [Ключевые особенности](#features)
- [Структура репозитория](#structure)
- [Умный набор команд (Media Suite)](#commands)
- [Быстрая установка](#install)
- [Управление конфигами](#manage)
- [Мост с ПК](#remote)
- [Лицензия](#license)

---

<a id="specs"></a>
## ٩(◕‿◕)۶ Характеристики мобильного узла

* (☞ﾟヮﾟ)☞ **OS:** Android (aarch64 / ARMv8)
* (⌐■_■) **Kernel:** Linux (Android LTS)
* (｡◕‿◕｡) **Terminal:** Termux
* (≧▽≦) **Shell:** Zsh + Oh My Zsh + Starship (Material / Obsidian Violet)
* (ง •̀_•́)ง **Core Suite:** `yt-dlp` (Video / Audio / Anime) + `aria2c` (8 потоков turbo) + SponsorBlock, `termux-api` (MediaStore Scanner), OpenSSH, Fastfetch
* (✿◠‿◠) **Theme:** Obsidian Violet & Soft Lavender (`#a78bfa`, `#c4b5fd`)
* (⚙️‿⚙️) **Dotfiles Manager:** GNU Stow

---

<a id="features"></a>
## (¬‿¬) Ключевые особенности сборки

* (︶︹︶) **Эстетика Obsidian Violet:** Единая лавандовая палитра для Fastfetch и Starship, синхронизированная со стилем десктопной сборки на Arch Linux.
* 📦 **Модульность через GNU Stow:** Каждый инструмент вынесен в отдельный пакет (`zsh`, `starship`, `fastfetch`, `yt-dlp`, `pkglists`). Управление через симлинки, никаких ручных `cp`.
* (づ｡◕‿‿◕｡)づ **Медиа-пайплайн в системную память:** Загрузки сохраняются напрямую в `/sdcard/Download/{Anime,Audio,Video}` и мгновенно регистрируются через `termux-media-scan`. Файлы сразу видны в Галерее и VLC.
* (๑•̀ㅂ•́)و **8-поточный турбо-буст:** `aria2c` подключен через `~/.config/yt-dlp/config`.
* ヽ(´▽`)/ **SponsorBlock и автотеги:** Вырезка рекламы и спонсорских вставок, встраивание обложек и метаданных.
* (⌐■_■) **Синхронизация с десктопом:** Привычные команды управления `config`, `dpush` (`cpush`) и `cpull`.

---

<a id="structure"></a>
## (•̀o•́)v Структура репозитория (GNU Stow)

```
Termux-dotfiles/
├── install.sh              # Скрипт развертывания симлинков (GNU Stow)
├── AGENTS.md               # Регламент для AI-агентов
├── LICENSE                 # GNU GPL v3
├── zsh/
│   └── .zshrc              # Настройки Zsh, плагины, медиа-алиасы и dpush/cpull
├── starship/
│   └── .config/starship.toml # Промпт Starship в палитре Obsidian Violet
├── fastfetch/
│   └── .config/fastfetch/config.jsonc # Минималистичный системный инфо-баннер
├── yt-dlp/
│   └── .config/yt-dlp/config # Конфигурация 8-поточного aria2c
└── pkglists/
    └── .config/pkglist_termux.txt # Список необходимых пакетов Termux
```

---

<a id="commands"></a>
## (☞ﾟヮﾟ)☞ Умный набор команд и алиасов (Media Suite)

Все скачанные файлы сохраняются напрямую в глобальную системную память Android (`/sdcard/Download/`) и автоматически регистрируются в системе через `termux-media-scan`.

| Команда | Назначение | Формат | Куда сохраняет | Особенности |
| :--- | :--- | :--- | :--- | :--- |
| **`y <url>`** | YouTube / Видео | MP4 (до 1080p) | `/sdcard/Download/Video/` | Автоскан в системную Галерею |
| **`ya <url>`** | Музыка / Треки | M4A (Opus) | `/sdcard/Download/Audio/` | Обложка, метаданные, автоскан в Плеер |
| **`nya [N] <url...>`** | Аниме по сериям | MKV | `/sdcard/Download/Anime/` | Субтитры (RU/EN), главы, нумерация серий, aria2c |
| **`scan`** | Ручной медиа-скан | — | `/sdcard/Download/` | Принудительно обновляет медиа-индекс Android |
| **`update`** | Обновление системы | — | Termux `$PREFIX` | `pkg update && pkg upgrade -y && apt autoremove` |

---

<a id="install"></a>
## (ง •̀_•́)ง Быстрая установка

### Шаг 1. Доступ к памяти и базовые пакеты

В чистом Termux выполните:

```bash
termux-setup-storage
pkg update -y && pkg install -y git zsh stow starship curl ffmpeg python-yt-dlp aria2 termux-api fastfetch bat eza ripgrep openssh tmux jq
```

*(Или восстановите полный список пакетов: `xargs pkg install -y < ~/.config/pkglist_termux.txt` после клонирования)*.

### Шаг 2. Oh My Zsh и плагины

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Шаг 3. Клонирование репозитория и линковка через Stow

```bash
git clone https://github.com/kudryashalex367-create/Termux-dotfiles.git ~/Termux-dotfiles
cd ~/Termux-dotfiles
chmod +x install.sh
./install.sh
```

### Шаг 4. Папки для медиа и запуск

```bash
mkdir -p /sdcard/Download/{Anime,Audio,Video}
chsh -s zsh
exec zsh
```

---

<a id="manage"></a>
## (≧▽≦) Управление конфигами

Идентично десктопным дотфайлам:

```bash
config status        # git -C ~/Termux-dotfiles status
config diff          # git -C ~/Termux-dotfiles diff
config add -- <file> # взять новый файл под контроль

cpush "сообщение"    # add -u + commit + push origin main (алиас dpush)
cpull                # pull --no-rebase + install.sh + exec zsh
```

Каталог дотфайлов: `$DOTFILES` (`~/Termux-dotfiles`).

---

<a id="remote"></a>
## (⌐■_■) Мост с ПК (ADB Forward / USB)

Подключение к Termux с ПК через USB-кабель без Wi-Fi:

1. В Termux:
   ```bash
   sshd
   ```
2. На ПК в терминале:
   ```bash
   phone    # выполняет: adb forward tcp:8022 tcp:8022 && ssh -p 8022 localhost
   ```

---

<a id="license"></a>
## (︶︹︶) Лицензия

Проект распространяется по лицензии [GNU GPL v3.0](./LICENSE).
