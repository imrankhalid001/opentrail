# ADR-0008: Strict Dependency Governance Matrix

## Context
To prevent dependency bloat, security risks, and breaking upstream package conflicts, OpenTrail enforces strict criteria before adding dependencies.

## Decision
Every package must be evaluated against licensing, active maintenance status, null-safety compatibility, and architectural alignment prior to addition.

## Consequences
- Minimal, clean `pubspec.yaml`.
- Reduced maintenance debt and predictable upgrades.
