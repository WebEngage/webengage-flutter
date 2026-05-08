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