import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/features/map/data/services/nominatim_service.dart';

class MockDio implements Dio {
  final Response<dynamic> response;

  MockDio(this.response);

  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    return response as Response<T>;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('searchPlaces returns list of places on success', () async {
    final mockResponse = Response<dynamic>(
      data: [
        {
          'place_id': '123',
          'name': 'Eiffel Tower',
          'type': 'tourism',
          'category': 'attraction',
          'lat': '48.8584',
          'lon': '2.2945',
          'display_name': 'Eiffel Tower, Paris, France',
        },
      ],
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

    final service = NominatimServiceImpl(dio: MockDio(mockResponse));
    final results = await service.searchPlaces('Eiffel Tower');

    expect(results.length, 1);
    expect(results.first.name, 'Eiffel Tower');
    expect(results.first.location.latitude, 48.8584);
  });
}
