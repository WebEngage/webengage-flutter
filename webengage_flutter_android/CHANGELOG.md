## CHANGE LOG

### Version 2.1.0 (Oct 29, 2026)
- **Android Gradle Plugin 9:** builds with AGP 9, including `android.builtInKotlin=true`. The Android build script no longer declares its own Android Gradle Plugin version (it uses the app's), and the plugin has no Kotlin code, so it never applies the Kotlin Gradle Plugin.
- **compileSdk:** the plugin now compiles against Android API 34 (was 33). If your app compiles against a lower API level, Flutter shows a warning asking you to raise `compileSdk`, which is backward compatible.
- **Requires Flutter 3.27 or later** (Dart SDK constraint `>=2.18.6 <4.0.0`). Apps on older Flutter versions keep using 2.0.0.
- **Android SDK:** now requires WebEngage Android SDK **5.x** (`com.webengage:android-sdk:[5,)`; latest 5.2.0). Apps that already resolve the newest SDK see no change; apps that pinned 4.x must move to 5.x.
- **Fix:** the plugin now reports its correct version (`2.1.0`) to WebEngage. Version 2.0.0 reported `2.0.0-beta.2`.

### Version 2.0.0 (May 7, 2026)
- Migrated to Flutter federated plugin architecture.
