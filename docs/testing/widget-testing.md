# Widget Testing Guidelines 🧩

Widget tests verify component rendering, user gesture handling, and state transitions (`loading`, `error`, `data`).

## Example Widget Test (`AppButton`)

```dart
void main() {
  testWidgets('AppButton renders label and triggers onPressed on tap', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppButton(
            label: 'Explore',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Explore'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(tapped, isTrue);
  });
}
```
