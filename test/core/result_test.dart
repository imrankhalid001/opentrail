import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/core/result/result.dart';

void main() {
  group('Result Monad Tests', () {
    test('Success returns value and reports isSuccess = true', () {
      const result = Success<String, Exception>('Tokyo');

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.value, equals('Tokyo'));
      expect(result.valueOrNull, equals('Tokyo'));
      expect(result.exceptionOrNull, isNull);
    });

    test('Failure returns exception and reports isFailure = true', () {
      final exception = Exception('Network error');
      final result = Failure<String, Exception>(exception);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.exception, equals(exception));
      expect(result.exceptionOrNull, equals(exception));
      expect(result.valueOrNull, isNull);
    });

    test('fold pattern matching works correctly for Success and Failure', () {
      const successResult = Success<int, Exception>(42);
      final successOutput = successResult.fold(
        onSuccess: (val) => 'Value: $val',
        onFailure: (ex) => 'Error: $ex',
      );
      expect(successOutput, equals('Value: 42'));

      final failureResult = Failure<int, Exception>(Exception('Timeout'));
      final failureOutput = failureResult.fold(
        onSuccess: (val) => 'Value: $val',
        onFailure: (ex) =>
            'Error: ${ex.toString().replaceAll("Exception: ", "")}',
      );
      expect(failureOutput, equals('Error: Timeout'));
    });
  });
}
