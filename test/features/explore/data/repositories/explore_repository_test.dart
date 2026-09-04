import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_projects/features/explore/data/models/destination.dart';
import 'package:flutter_projects/features/explore/data/repositories/explore_repository.dart';
import 'package:flutter_projects/features/explore/data/services/rest_countries_service.dart';
import 'package:flutter_projects/features/explore/data/services/wikipedia_service.dart';

class MockRestCountriesService implements RestCountriesService {
  final List<Destination> mockDestinations;

  MockRestCountriesService(this.mockDestinations);

  @override
  Future<List<Destination>> fetchAllDestinations() async => mockDestinations;

  @override
  Future<List<Destination>> fetchDestinationsByRegion(String region) async {
    return mockDestinations
        .where((d) => d.region.toLowerCase() == region.toLowerCase())
        .toList();
  }
}

class MockWikipediaService implements WikipediaService {
  @override
  Future<Map<String, dynamic>> fetchSummary(String title) async {
    return {
      'extract': 'Enriched Wikipedia cultural summary for $title.',
      'thumbnail': {'source': 'https://example.com/wiki.jpg'},
    };
  }
}

void main() {
  const sampleDestination = Destination(
    id: 'jp',
    name: 'Japan',
    country: 'Japan',
    countryCode: 'JP',
    flagEmoji: '🇯🇵',
    capital: 'Tokyo',
    region: 'Asia',
    subregion: 'Eastern Asia',
    population: 125800000,
    latitude: 36.2048,
    longitude: 138.2529,
    languages: ['Japanese'],
    currencies: ['Japanese Yen (JPY)'],
    summary: 'Island country in East Asia.',
  );

  late ExploreRepository repository;

  setUp(() {
    repository = ExploreRepositoryImpl(
      countriesService: MockRestCountriesService([sampleDestination]),
      wikipediaService: MockWikipediaService(),
    );
  });

  test('getDestinations returns list of destinations successfully', () async {
    final result = await repository.getDestinations();
    expect(result.isSuccess, true);
    result.fold(
      onSuccess: (list) {
        expect(list.length, 1);
        expect(list.first.name, 'Japan');
      },
      onFailure: (_) => fail('Should succeed'),
    );
  });

  test(
    'getDestinationDetail enriches destination with Wikipedia summary',
    () async {
      final result = await repository.getDestinationDetail('jp');
      expect(result.isSuccess, true);
      result.fold(
        onSuccess: (dest) {
          expect(dest.name, 'Japan');
          expect(dest.summary, contains('Enriched Wikipedia'));
        },
        onFailure: (_) => fail('Should succeed'),
      );
    },
  );
}
