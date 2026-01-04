## Cuentacuentos

Kid-friendly story generator with themed UI, localization, and TTS.

### Key Features
- Generate stories by age, length, and idea (or random topic).
- Themed UI (multiple gradients, backgrounds; switch in Profile).
- Saved stories list with detail and audio playback.
- Profile: preferred language, avatar picker, mock credits.
- Localization: Spanish, English, French, German, Italian, Portuguese, Japanese.

### Setup
1. Open `Cuentacuentos.xcodeproj` in Xcode 15+.
2. Set a unique Bundle Identifier in Target > Signing & Capabilities.
3. Select your Personal Team (or a paid team) for code signing.
4. Run on a device (⌘R). For free teams, trust the profile in Settings > General > VPN & Device Management.

### Theming
- Themes are managed via `ThemeManager` and `ThemeVariant`.
- Backgrounds drawn in `ThemeBackgroundView`. Ocean and Galaxy use images:
  - Add `bg_waves.png` and `bg_galaxy.png` into `Assets.xcassets` matching the imageset names.

### Icons
- Add your 1024×1024 PNG into `Assets.xcassets/AppIcon.appiconset` (assign to all slots).

### API Keys
- Do not commit secrets. Remove/ignore any API keys from `Info.plist` and use secure storage.


