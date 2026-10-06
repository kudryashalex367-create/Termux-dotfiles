# 🤖 Termux Dotfiles by zev1ce — Mobile Obsidian Suite

> *"UNIX in your pocket." — Minimalist, High-Performance CLI & Media Environment for Android.*

Добро пожаловать в мой репозиторий мобильных конфигурационных файлов для **Termux (Android)**. Здесь хранится оптимизированная, автономная среда командной строки в строгом ахроматическом стиле **Monochrome Obsidian**, синхронизированная с моей рабочей станцией на Arch Linux.

---

## 📱 Характеристики мобильного узла

* 🤖 **OS:** Android (aarch64 / ARMv8)
* ⚙️ **Kernel:** Linux (Android LTS)
* 🖥️ **WM:** `WindowManager (SurfaceFlinger)`
* 🐚 **Shell:** Zsh 5.9.2 + Oh My Zsh + Powerlevel10k (Lean 8-colors)
* ⚡ **Core Suite:** `yt-dlp` (Video / Audio / Anime) + `aria2c` (8 потоков) + SponsorBlock, `termux-api` (MediaStore Scanner), OpenSSH, Fastfetch
* 🎨 **Theme:** Monochrome Obsidian & Zinc

---

## ⚡ Умный набор команд и алиасов (Media Suite)

Все скачанные файлы сохраняются напрямую в глобальную системную память Android (`/sdcard/Download/`) и автоматически регистрируются в системе через `termux-media-scan`. Файлы мгновенно появляются в Галерее, Музыкальном плеере и VLC без перезагрузки телефона!

| Команда | Назначение | Формат | Куда сохраняет | Особенности |
| :--- | :--- | :--- | :--- | :--- |
| **`y <url>`** | YouTube / Видео | MP4 (до 1080p) | `/sdcard/Download/Video/` | Автоскан в системную Галерею |
| **`ya <url>`** | Музыка / Треки | M4A (Opus, если есть) | `/sdcard/Download/Audio/` | Обложка, теги, вырезает рекламу и интро через SponsorBlock, автоскан в Плеер |
| **`nya [N] <url...>`** | Аниме / Сериалы | MKV | `/sdcard/Download/Anime/` | Субтитры (RU/EN), главы OP/ED, постер, нумерация серий, aria2c |
| **`scan`** | Ручной медиа-скан | — | `/sdcard/Download/` | Принудительно обновляет медиа-индекс Android |
| **`update`** | Обновление пакетов | — | — | `pkg update && pkg upgrade -y && apt clean` |
| **`tpush` / `tpull`** | Синхронизация дотфайлов | — | `~` | Коммит и пуш / пулл конфигов этого репозитория |

Общий конфиг загрузчика лежит в `~/.config/yt-dlp/config` (aria2c, 8 потоков) и применяется ко всем командам выше.

---

## 🔌 Удалённое управление с ПК (SSH over USB via ADB)

Благодаря пробросу портов через ADB можно подключиться к телефону с компьютера на скорости кабеля с нулевым пингом без необходимости раздавать Wi-Fi:

1. Включите **«Отладку по USB»** на телефоне и подключите кабель к ПК.
2. На компьютере выполните:
   ```bash
   adb forward tcp:8022 tcp:8022
   ssh -p 8022 localhost
   ```
3. *(Опционально)* Быстрый алиас для входа в `~/.zshrc` на компьютере:
   ```bash
   alias phone='adb forward tcp:8022 tcp:8022 && ssh -p 8022 localhost'
   ```

---

## 🔄 Выбор метода восстановления системы

В репозитории предусмотрено **два альтернативных сценария** развертывания окружения на чистом телефоне:

| Параметр | ⚡ Метод 1: Готовый Бэкап (Snapshot) | 🛠 Метод 2: Чистая Установка (Fresh Build) |
| :--- | :--- | :--- |
| **Скорость** | **~1–3 минуты** (зависит от интернета, архив ~700 МБ) | ~3–5 минут |
| **Что восстанавливается** | **ВСЁ:** бинарники, FFmpeg, Python, Zsh, плагины, конфиги | Чистые пакеты из репозитория + конфиги |
| **Свежесть пакетов** | Снимок от 06.10.2026 *(дальше обновляется через `update`)* | Всегда самые последние версии из апстрима |
| **Сложность** | 🟢 Минимальная (2 команды) | 🟡 Пошаговая (4 шага) |

---

## ⚡ МЕТОД 1: Быстрое развертывание из готового бэкапа (Рекомендуется)

> 💡 **Особенности:** Скачивает монолитный архив со всеми скомпилированными пакетами, библиотеками и темами из раздела **Releases** и разворачивает готовую рабочую среду. Архив перезаписывает `~` и `$PREFIX`, поэтому запускать его нужно **только на чистом Termux**.
>
> 🔒 В снапшот сознательно **не входят** SSH-ключи, токены, история команд и кэш.

**1.** Откройте чистый Termux и выполните:

```bash
pkg install -y curl && curl -L https://github.com/kudryashalex367-create/Termux-dotfiles/releases/download/v1.1.0/termux-backup.tar.gz | tar -zxf - -C /data/data/com.termux/files --recursive-unlink --preserve-permissions && termux-setup-storage
```

**2.** Нажмите «Разрешить доступ к памяти», затем:

```bash
mkdir -p /sdcard/Download/{Anime,Audio,Video} && exec zsh
```

**3.** Чтобы работали `tpush` / `tpull` (remote репозитория использует SSH), создайте новый ключ и добавьте его на [GitHub → Settings → SSH keys](https://github.com/settings/keys):

```bash
ssh-keygen -t ed25519 -C "termux"
cat ~/.ssh/id_ed25519.pub
ssh -T git@github.com
```

> После восстановления выполните `tpull`, чтобы подтянуть самые свежие конфиги из `main`.

---

## 🛠 МЕТОД 2: Пошаговая чистая установка из репозитория

> 💡 **Особенности:** Устанавливает самые свежие версии пакетов напрямую из зеркал `pkg`, клонирует репозиторий Oh My Zsh и накладывает конфигурационные файлы из ветки `main`. Занимает чуть больше времени, но гарантирует апстрим-свежесть.

### Шаг 1. Разрешение доступа к памяти и установка пакетов

```bash
termux-setup-storage
pkg update -y && pkg install -y zsh git curl ffmpeg python-yt-dlp deno aria2 termux-api \
  fastfetch bat eza ripgrep openssh tmux byobu yazi tealdeer htop fzf fd jq tree
```

### Шаг 2. Установка Oh My Zsh и плагинов

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### Шаг 3. Клонирование конфигураций из репозитория

```bash
git clone https://github.com/kudryashalex367-create/Termux-dotfiles.git ~/temp-dotfiles
cp ~/temp-dotfiles/.zshrc ~/.zshrc
cp ~/temp-dotfiles/.p10k.zsh ~/.p10k.zsh
mkdir -p ~/.config/fastfetch ~/.config/yt-dlp
cp ~/temp-dotfiles/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
cp ~/temp-dotfiles/.config/yt-dlp/config ~/.config/yt-dlp/config
rm -rf ~/temp-dotfiles
```

### Шаг 4. Создание глобальных папок и запуск

```bash
mkdir -p /sdcard/Download/{Anime,Audio,Video}
chsh -s zsh
exec zsh
```