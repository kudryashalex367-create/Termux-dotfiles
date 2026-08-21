# 🤖 Termux Dotfiles by zev1ce — Mobile Obsidian Suite

> *"UNIX in your pocket." — Minimalist, High-Performance CLI & Media Environment for Android.*

Добро пожаловать в мой репозиторий мобильных конфигурационных файлов для **Termux (Android)**. Здесь хранится оптимизированная, автономная среда командной строки в строгом ахроматическом стиле **Monochrome Obsidian**, синхронизированная с моей рабочей станцией на Arch Linux.

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

Все скачанные файлы сохраняются напрямую в глобальную системную память Android (`/sdcard/Download/`) и автоматически регистрируются в системе через `termux-media-scan`. Файлы мгновенно появляются в Галерее, Музыкальном плеере и VLC без перезагрузки телефона!

| Команда | Назначение | Формат | Куда сохраняет | Особенности |
| :--- | :--- | :--- | :--- | :--- |
| **`y <url>`** | YouTube / Видео | MP4 (до 1080p) | `/sdcard/Download/` | Автоскан в системную Галерею |
| **`ya <url>`** | Музыка / Треки | MP3 (VBR 0) | `/sdcard/Download/Music/` | Вшивает обложку, теги и сканирует в Плеер |
| **`nya <url>`** | Аниме / Сериалы | MKV / MP4 | `/sdcard/Download/Anime/` | Вшивает субтитры (RU/EN), главы OP/ED, постер |
| **`scan`** | Ручной медиа-скан | — | `/sdcard/Download/` | Принудительно обновляет медиа-индекс Android |
| **`update`** | Обновление пакетов | — | — | Выполняет `pkg update && pkg upgrade` |

---

## 🔌 Удаленное управление с ПК (SSH over USB via ADB)

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
| **Скорость** | **~30 секунд** (1 команда) | ~3–5 минут |
| **Что восстанавливается** | **ВСЁ:** бинарники, FFmpeg, Python, Zsh, плагины, конфиги | Чистые пакеты из репозитория + конфиги |
| **Свежесть пакетов** | Зафиксированный снимок *(обновляется через `update`)* | Всегда самые последние версии из апстрима |
| **Сложность** | 🟢 Минимальная (скопировал ➔ вставил) | 🟡 Пошаговая (4 шага) |

---

## ⚡ МЕТОД 1: Быстрое развертывание из готового бэкапа (Рекомендуется)

> 💡 **Особенности:** Скачивает монолитный архив со всеми скомпилированными пакетами, библиотеками и темами из раздела **Releases** и разворачивает 100% готовую рабочую среду за 30 секунд. Конфигурация может быть слегка заморожена во времени, но запускается моментально.

Откройте чистый Termux и выполните **всего одну команду**:

```bash
pkg install -y curl && curl -L https://github.com/kudryashalex367-create/Termux-dotfiles/releases/download/v1.0.0/termux-backup.tar.gz | tar -zxf - -C /data/data/com.termux/files && termux-setup-storage && mkdir -p /sdcard/Download/Anime /sdcard/Download/Music && exec zsh
```

*(При появлении запроса Android нажмите «Разрешить доступ к памяти»)*.

---

## 🛠 МЕТОД 2: Пошаговая чистая установка из репозитория

> 💡 **Особенности:** Устанавливает самые свежие версии пакетов напрямую из зеркал `pkg`, клонирует репозиторий Oh My Zsh и накладывает конфигурационные файлы из ветки `main`. Занимает чуть больше времени, но гарантирует апстрим-свежесть.

### Шаг 1. Разрешение доступа к памяти и установка пакетов

```bash
termux-setup-storage
pkg update -y && pkg install -y zsh curl git ffmpeg yt-dlp termux-api fastfetch micro bat eza ripgrep python openssh
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
mkdir -p ~/.config/fastfetch
cp ~/temp-dotfiles/.config/fastfetch/config.jsonc ~/.config/fastfetch/config.jsonc
rm -rf ~/temp-dotfiles
```

### Шаг 4. Создание глобальных папок и запуск

```bash
mkdir -p /sdcard/Download/Anime /sdcard/Download/Music
chsh -s zsh
exec zsh
```
