/// Helper class for WebEngage analytics integration.
/// Implements singleton pattern for consistent SDK access.
import 'package:webengage_flutter/webengage_flutter.dart';

/// Singleton helper class for WebEngage SDK operations.
class WebEngageHelper {
  WebEngagePlugin _webEngagePlugin = new WebEngagePlugin();

  /// Private constructor for singleton pattern.
  WebEngageHelper._privateConstructor();

  /// Static instance of the class.
  static final WebEngageHelper _instance =
      WebEngageHelper._privateConstructor();

  /// Factory constructor returns singleton instance.
  factory WebEngageHelper() {
    return _instance;
  }

  /// Logs in a user with the given [id].
  void login(id) {
    WebEngagePlugin.userLogin(id);
  }
}
