# Security & Privacy Specifications 🔒

OpenTrail prioritizes privacy and local data security.

1. **Zero Secret Storage in Code**: API keys or access tokens are injected via compile-time environment variables (`--dart-define`).
2. **Local Key-Value Encryption**: Sensitive user preferences or offline data are encrypted using platform-native secure storage (`flutter_secure_storage` / Keychain / Keystore).
3. **HTTPS / TLS**: All network REST communication with open data providers is strictly enforced over HTTPS.
4. **Zero Telemetry**: No third-party tracking, analytics SDKs, or cloud telemetry dependencies exist in OpenTrail.
