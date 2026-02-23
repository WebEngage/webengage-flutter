/// Model class representing region-specific configuration.
/// Contains WebEngage SDK initialization parameters for different regions.
class RegionConfig {
  /// Region identifier (e.g., "US", "IN", "KSA").
  final String region;
  
  /// WebEngage license code for the region.
  final String licenseCode;
  
  /// Environment identifier for WebEngage SDK.
  final String env;

  /// Creates a RegionConfig with required parameters.
  RegionConfig({
    required this.region,
    required this.licenseCode,
    required this.env,
  });
}