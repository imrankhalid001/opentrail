# Unit Testing Guidelines 🔬

Unit tests in OpenTrail verify pure logic in ViewModels, Repositories, Services, and Utilities without mounting Flutter widgets.

## Unit Test Structure

```dart
void main() {
  group('Result Monad Tests', () {
    test('Success returns encapsulated value', () {
      const result = Success<String, Exception>('Tokyo');
      expect(result.value, equals('Tokyo'));
    });

    test('Failure returns encapsulated exception', () {
      final exception = Exception('Network error');
      final result = Failure<String, Exception>(exception);
      expect(result.exception, equals(exception));
    });
  });
}
```
