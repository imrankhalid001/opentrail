# Environment Configuration & Launch Setup ⚙️

OpenTrail uses `.env` files paired with compile-time `--dart-define` overrides for environment configuration.

## Environment Files
- `.env.example`: Safe configuration template committed to Git.
- `.env`: Local development configuration ignored by `.gitignore`.

## Security Rules
- **ZERO secrets** in source control.
- API keys, credentials, or certificates must **never** be committed.
