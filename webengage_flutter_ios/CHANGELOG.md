## Version 2.1.0 (Nov 2, 2026)

- **Swift Package Manager:** added support for `webengage-ios-sdk` **2.x** (WebEngage iOS SDK **7.x**). The supported range is now `1.0.0 ..< 3.0.0`, so both iOS SDK 6.x and 7.x work.
- **CocoaPods:** no change.
- No Dart API changes.
- **Existing SPM apps:** to move to iOS SDK 7.x, update your packages in Xcode (**File ▸ Packages ▸ Update to Latest Package Versions**) or delete `Package.resolved`. If another plugin in your app still limits `webengage-ios-sdk` to 1.x, SPM keeps 1.x until that plugin is updated.

## Version 2.0.0 (May 7, 2026)

- Migrated to **Flutter federated plugin architecture** for improved modularity and platform separation.
- Added **Swift Package Manager (SPM) support** for iOS integration.

### ⚠️ Breaking Changes

#### iOS Import Change
- Swift import statement updated:
    - **Old:**
      ```swift
      import webengage_flutter
      ```
    - **New:**
      ```swift
      import webengage_flutter_ios
      ```

#### Location Plugin Separation
- Location-related functionality has been moved to a **separate plugin**.
- If you are upgrading from a version **below 2.0.0** and using location features, you must add the new plugin manually (otherwise, this step can be ignored):

```yaml
dependencies:
  webengage_flutter_location: ^latest_version