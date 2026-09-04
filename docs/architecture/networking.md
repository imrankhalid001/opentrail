# Networking Stack & REST Client Architecture 🌐

OpenTrail uses **Dio (v5.x)** as its HTTP client engine for REST API communication with open data providers.

---

## 1. Client Configuration & Interceptors

All HTTP REST requests are routed through a centralized `Dio` instance created in `lib/core/networking/dio_client.dart`:

```dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'User-Agent': 'OpenTrail/1.0.0 (https://github.com/imrankhalid001/opentrail)',
      },
    ),
  );

  dio.interceptors.addAll([
    LoggingInterceptor(),
    ErrorInterceptor(),
    CacheInterceptor(),
  ]);

  return dio;
});
```

---

## 2. Interceptor Pipeline Responsibilities

1. **LoggingInterceptor**: Formats and logs HTTP request URLs, query parameters, headers, and status codes in debug mode using `AppLogger`.
2. **ErrorInterceptor**: Intercepts raw `DioException` errors (connect timeout, receive timeout, 4xx/5xx responses) and maps them to strongly typed `NetworkException` models.
3. **CacheInterceptor**: Adds HTTP `If-None-Match` and `ETag` headers to reduce unnecessary bandwidth consumption.

---

## 3. Retries, Rate Limits & Request Cancellation

- **Exponential Backoff**: Transient network failures (e.g., HTTP 503 or socket timeouts) trigger up to 3 automatic retry attempts with exponential jitter delay.
- **Request Cancellation**: ViewModels pass `CancelToken` to service methods when a user navigates away from a screen or cancels a search query, terminating redundant HTTP requests immediately.
- **Rate Limit Resilience**: The networking client respects HTTP `429 Too Many Requests` responses and `Retry-After` headers.
