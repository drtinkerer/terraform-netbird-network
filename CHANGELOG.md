# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-08-02

### Changed
- Enhanced documentation with clearer examples and usage patterns
- Improved code stability and maintainability 
- Updated examples for better real-world usage scenarios
- Refined variable descriptions and validation

### Fixed
- Minor documentation inconsistencies
- Example formatting improvements

### Internal
- Code review and quality improvements
- Better error handling patterns
- Enhanced code comments and documentation

## [1.0.0] - 2025-07-07

### Added
- Initial release of the NetBird Network Terraform module
- Support for creating NetBird networks with custom descriptions
- Auto-assigned groups for peers using setup keys
- Network resources support for both CIDR blocks and domain names
- Configurable routing with metrics and masquerading options
- Flexible access policies with configurable source groups
- Setup key generation with customizable expiry and usage limits
- Complete documentation and examples
- Support for multiple network resources per network
- Sensitive output handling for setup keys

### Features
- **Network Management**: Create and manage NetBird networks
- **Group Auto-assignment**: Automatically assign peers to groups via setup keys
- **Resource Management**: Support for IP ranges and domain-based resources
- **Routing Configuration**: Optional network routing with configurable settings
- **Access Control**: Flexible policies with multiple source group support
- **Setup Keys**: Reusable or one-time keys for device enrollment

### Examples
- Basic usage example with minimal configuration
- Complete example with all features demonstrated
- Clear documentation with input/output specifications