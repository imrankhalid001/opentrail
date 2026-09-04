# Widget Testing Guidelines 🧩

Widget tests verify reusable design system controls (`lib/core/widgets/`) and screen states.

## Guidelines
1. Wrap tested widgets in `UncontrolledProviderScope` and `MaterialApp`.
2. Test 4 state branches: `loading` (`AppSkeleton`), `error` (`AppErrorState`), `empty` (`AppEmptyState`), and `data`.
3. Verify tap interactions and accessibility semantic labels.
