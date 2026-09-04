# Networking Stack & REST Client 🌐

OpenTrail uses **Dio** as its HTTP client engine.

## Key Interceptors
1. **LoggingInterceptor**: Formats and logs HTTP requests and responses in debug mode using `AppLogger`.
2. **ErrorInterceptor**: Converts raw Dio errors (`DioExceptionType`) into strongly typed `NetworkException` models.
3. **CacheInterceptor**: Adds HTTP `If-None-Match` and `ETag` headers to reduce redundant bandwidth usage.

---

## Timeouts & Retries
- **Connect Timeout**: 10,000 ms.
- **Receive Timeout**: 15,000 ms.
- **Retry Strategy**: Exponential backoff with jitter (3 retries max for idempotent GET requests).
