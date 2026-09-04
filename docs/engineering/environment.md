# Environment Configuration & Safe Secret Handling 🔒

OpenTrail follows a strict **Zero-Secrets Policy**.

---

## 1. Zero Secrets in Source Code
- **No API Keys in Git**: Never commit API keys, tokens, passwords, or certificates into `.dart` files or `.env` files.
- **Environment Injection**: Runtime parameters are injected via compile-time `--dart-define` flags:
  ```bash
  flutter run --dart-define=API_ENVIRONMENT=production
  ```
- **`.gitignore` Enforcement**: All `.env`, `.env.local`, and platform secret files are strictly ignored in `.gitignore`.
