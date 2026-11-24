# WallpaperStudio

Живые обои и кастом для iPhone. iOS 17+, SwiftUI, без внешних зависимостей.

## Что внутри

- 6 процедурных анимированных пресетов (Aurora, Ember, Lagoon, Neon Dusk, Bubblegum, Deep Space).
- Parallax по данным акселерометра (`CMMotionManager`) в реальном времени.
- Рендер обоев в видео 1080×1920, H.264, 30 fps через `AVAssetWriter` и экспорт в Фото.
- Настройки: parallax, скорость, мягкость, зерно, свечение. Сохраняются в `UserDefaults`.
- Отдельный theos‑твик для джейлбрейка: скрытие подписей иконок, скругление дока, прозрачность папок.

## Сборка .ipa с Windows

На Windows `.ipa` собрать нельзя — `xcodebuild` работает только на macOS. Используй GitHub Actions:

1. Создай репозиторий на GitHub и залей сюда всё содержимое этой папки.
2. Открой вкладка **Actions** → **Build unsigned IPA** → **Run workflow**.
3. Дождись окончания (обычно 3–6 минут).
4. Скачай артефакт `WallpaperStudio-unsigned-ipa`, распакуй — внутри `WallpaperStudio-unsigned.ipa`.

### Подпись и установка

1. Скачай и установи [Sideloadly](https://sideloadly.io/) на Windows.
2. Подключи iPhone по USB, доверь компьютеру.
3. В Sideloadly выбери `.ipa`, введи свой Apple ID (можно бесплатный), нажми **Start**.
4. После установки: **Настройки → Общие → VPN и управление устройствами** → подтверди сертификат разработчика.

Бесплатный Apple ID даёт подпись на 7 дней — потом нужно повторить загрузку.

## Локальная сборка (если есть Mac)

```bash
brew install xcodegen
xcodegen generate --spec project.yml
open WallpaperStudio.xcodeproj
```

В Xcode: **Product → Archive → Distribute App** → Development/Ad Hoc → Export.

## Джейлбрейк-твик

Нужен theos на Mac или на самом устройстве:

```bash
cd Tweaks
make package
make install
```

Твик применится после respring'а.

## Ограничения iOS

iOS не предоставляет публичный API для программной смены обоев — последний шаг («Использовать как обои») всегда выполняется вручную через Фото. Настоящие системные твики требуют джейлбрейка и находятся в папке `Tweaks`.
