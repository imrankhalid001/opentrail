# Security Policy

## Reporting Security Issues

The OpenTrail team takes the security of our application and open-source infrastructure seriously. If you believe you have discovered a security vulnerability in OpenTrail, please report it to us responsibly.

### How to Report
**Do NOT report security vulnerabilities through public GitHub issues.**

Instead, please send an email to `security@opentrail.org` detailing:
- A description of the issue and potential impact
- Step-by-step instructions or proof-of-concept code to reproduce the issue
- Any affected platforms or dependencies

We will acknowledge receipt of your vulnerability report within 48 hours and provide regular updates regarding our remediation plan.

---

## Secret Management Policy

1. **Zero Hardcoded Secrets**: No API keys, credentials, tokens, or private certificates may be hardcoded into source code, test files, or committed documentation.
2. **Environment Variables**: Sensitive configuration parameters must be supplied via compile-time environment variables (`--dart-define` or `.env` files).
3. **Git Hygiene**: Pre-commit hooks and CI pipelines analyze all commits to ensure `.env` files and credentials are never introduced into source control.
