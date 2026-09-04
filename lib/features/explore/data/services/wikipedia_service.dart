import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';

abstract class WikipediaService {
  Future<Map<String, dynamic>> fetchSummary(String title);
}

class WikipediaServiceImpl implements WikipediaService {
  final Dio dio;

  WikipediaServiceImpl({required this.dio});

  String _formatDioError(DioException e, String contextMessage) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return '$contextMessage: Connection timed out.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return '$contextMessage: Server unreachable.';
    }
    final msg = e.message;
    if (msg != null && msg.isNotEmpty && msg.toLowerCase() != 'null') {
      return '$contextMessage: $msg';
    }
    if (e.error != null) {
      return '$contextMessage: ${e.error}';
    }
    return '$contextMessage: Unable to fetch Wikipedia data.';
  }

  @override
  Future<Map<String, dynamic>> fetchSummary(String title) async {
    try {
      final sanitizedTitle = Uri.encodeComponent(title);
      final response = await dio.get<Map<String, dynamic>>(
        'https://en.wikipedia.org/api/rest_v1/page/summary/$sanitizedTitle',
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!;
      }
      throw NetworkException(
        message:
            'Failed to fetch Wikipedia summary for $title: HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
        message: _formatDioError(e, 'Network error fetching Wikipedia summary'),
        cause: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        message: 'Unexpected error fetching Wikipedia summary: $e',
        cause: e,
      );
    }
  }
}
