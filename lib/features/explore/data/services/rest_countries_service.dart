import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/errors/app_exception.dart';
import '../models/destination.dart';

abstract class RestCountriesService {
  Future<List<Destination>> fetchAllDestinations();
  Future<List<Destination>> fetchDestinationsByRegion(String region);
}

class RestCountriesServiceImpl implements RestCountriesService {
  final Dio dio;

  static const String _primaryCdnEndpoint =
      'https://raw.githubusercontent.com/mledoze/countries/master/dist/countries.json';

  RestCountriesServiceImpl({required this.dio});

  String _formatDioError(DioException e, String contextMessage) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return '$contextMessage: Connection timed out. Please check internet connection.';
    }
    if (e.type == DioExceptionType.connectionError) {
      return '$contextMessage: Unable to reach server. Please verify network connectivity.';
    }
    final msg = e.message;
    if (msg != null && msg.isNotEmpty && msg.toLowerCase() != 'null') {
      return '$contextMessage: $msg';
    }
    if (e.error != null) {
      return '$contextMessage: ${e.error}';
    }
    return '$contextMessage: Unable to complete network request.';
  }

  List<Destination> _parseJsonPayload(dynamic rawData) {
    List<dynamic> list;
    if (rawData is String) {
      final decoded = jsonDecode(rawData);
      if (decoded is List) {
        list = decoded;
      } else {
        throw const ParseException(message: 'Decoded JSON is not a List');
      }
    } else if (rawData is List) {
      list = rawData;
    } else if (rawData is Map) {
      final msg =
          rawData['message'] ??
          (rawData['errors'] != null &&
                  rawData['errors'] is List &&
                  (rawData['errors'] as List).isNotEmpty
              ? rawData['errors'][0]['message']
              : 'Server returned error payload Map');
      throw NetworkException(message: 'API error: $msg');
    } else {
      throw ParseException(
        message:
            'Invalid payload format: expected List but received ${rawData.runtimeType}',
      );
    }

    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return Destination.fromRestCountriesJson(item);
      } else if (item is Map) {
        final Map<String, dynamic> converted = item.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        return Destination.fromRestCountriesJson(converted);
      } else {
        throw const ParseException(
          message: 'Destination item in list is not a Map',
        );
      }
    }).toList();
  }

  @override
  Future<List<Destination>> fetchAllDestinations() async {
    try {
      final response = await dio.get<dynamic>(
        _primaryCdnEndpoint,
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200 && response.data != null) {
        return _parseJsonPayload(response.data);
      }
      throw NetworkException(
        message: 'Failed to load destinations: HTTP ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw NetworkException(
        message: _formatDioError(e, 'Network error loading destinations'),
        cause: e,
      );
    } catch (e) {
      if (e is AppException) rethrow;
      throw UnknownException(
        message: 'Unexpected error loading destinations: $e',
        cause: e,
      );
    }
  }

  @override
  Future<List<Destination>> fetchDestinationsByRegion(String region) async {
    final all = await fetchAllDestinations();
    if (region.toLowerCase() == 'all' || region.trim().isEmpty) {
      return all;
    }
    return all
        .where((d) => d.region.toLowerCase() == region.toLowerCase())
        .toList();
  }
}
