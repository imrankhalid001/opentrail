import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/logging/app_logger.dart';
import '../../../../core/result/result.dart';
import '../models/destination.dart';
import '../services/rest_countries_service.dart';
import '../services/wikipedia_service.dart';

final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        'User-Agent':
            'OpenTrail/1.0.0 (https://github.com/imrankhalid001/opentrail)',
      },
    ),
  );
});

final restCountriesServiceProvider = Provider<RestCountriesService>((ref) {
  final dio = ref.watch(dioProvider);
  return RestCountriesServiceImpl(dio: dio);
});

final wikipediaServiceProvider = Provider<WikipediaService>((ref) {
  final dio = ref.watch(dioProvider);
  return WikipediaServiceImpl(dio: dio);
});

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  final countriesService = ref.watch(restCountriesServiceProvider);
  final wikiService = ref.watch(wikipediaServiceProvider);
  final db = ref.watch(appDatabaseProvider);
  return ExploreRepositoryImpl(
    countriesService: countriesService,
    wikipediaService: wikiService,
    db: db,
  );
});

abstract class ExploreRepository {
  Future<Result<List<Destination>, AppException>> getDestinations({
    String region = 'All',
    String query = '',
  });

  Future<Result<Destination, AppException>> getDestinationDetail(String id);

  Future<void> toggleFavorite(String id);

  Future<bool> isFavorite(String id);
}

class ExploreRepositoryImpl implements ExploreRepository {
  final RestCountriesService countriesService;
  final WikipediaService wikipediaService;
  final AppDatabase db;

  final Map<String, Destination> _cache = {};

  static const List<Destination> _fallbackDestinations = [
    Destination(
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
      summary: 'Japan is an island country in East Asia located in the northwest Pacific Ocean. Famous for ancient temples, futuristic cities, and cherry blossoms.',
      imageUrl: 'https://flagcdn.com/w320/jp.png',
    ),
    Destination(
      id: 'fr',
      name: 'France',
      country: 'France',
      countryCode: 'FR',
      flagEmoji: '🇫🇷',
      capital: 'Paris',
      region: 'Europe',
      subregion: 'Western Europe',
      population: 67750000,
      latitude: 46.2276,
      longitude: 2.2137,
      languages: ['French'],
      currencies: ['Euro (EUR)'],
      summary: 'France is a transcontinental country in Western Europe known for art, haute couture, gastronomy, and historic landmarks like the Eiffel Tower.',
      imageUrl: 'https://flagcdn.com/w320/fr.png',
    ),
    Destination(
      id: 'it',
      name: 'Italy',
      country: 'Italy',
      countryCode: 'IT',
      flagEmoji: '🇮🇹',
      capital: 'Rome',
      region: 'Europe',
      subregion: 'Southern Europe',
      population: 58980000,
      latitude: 41.8719,
      longitude: 12.5674,
      languages: ['Italian'],
      currencies: ['Euro (EUR)'],
      summary: 'Italy is a Mediterranean country in Southern Europe renowned for Roman ruins, Renaissance art, stunning coastlines, and culinary traditions.',
      imageUrl: 'https://flagcdn.com/w320/it.png',
    ),
    Destination(
      id: 'eg',
      name: 'Egypt',
      country: 'Egypt',
      countryCode: 'EG',
      flagEmoji: '🇪🇬',
      capital: 'Cairo',
      region: 'Africa',
      subregion: 'Northern Africa',
      population: 104300000,
      latitude: 26.8206,
      longitude: 30.8025,
      languages: ['Arabic'],
      currencies: ['Egyptian Pound (EGP)'],
      summary: 'Egypt connects northeast Africa with the Middle East, dating to the time of the pharaohs and iconic monuments like Giza Pyramids.',
      imageUrl: 'https://flagcdn.com/w320/eg.png',
    ),
    Destination(
      id: 'br',
      name: 'Brazil',
      country: 'Brazil',
      countryCode: 'BR',
      flagEmoji: '🇧🇷',
      capital: 'Brasília',
      region: 'Americas',
      subregion: 'South America',
      population: 214300000,
      latitude: -14.235,
      longitude: -51.9253,
      languages: ['Portuguese'],
      currencies: ['Brazilian Real (BRL)'],
      summary: 'Brazil is South America’s largest country, famous for Amazon rainforests, Rio Carnival, vibrant culture, and tropical beaches.',
      imageUrl: 'https://flagcdn.com/w320/br.png',
    ),
    Destination(
      id: 'au',
      name: 'Australia',
      country: 'Australia',
      countryCode: 'AU',
      flagEmoji: '🇦🇺',
      capital: 'Canberra',
      region: 'Oceania',
      subregion: 'Australia and New Zealand',
      population: 25690000,
      latitude: -25.2744,
      longitude: 133.7751,
      languages: ['English'],
      currencies: ['Australian Dollar (AUD)'],
      summary: 'Australia is bounded by the Indian and Pacific oceans, known for the Great Barrier Reef, Sydney Opera House, and vast Outback.',
      imageUrl: 'https://flagcdn.com/w320/au.png',
    ),
    Destination(
      id: 'us',
      name: 'United States',
      country: 'United States',
      countryCode: 'US',
      flagEmoji: '🇺🇸',
      capital: 'Washington, D.C.',
      region: 'Americas',
      subregion: 'North America',
      population: 331900000,
      latitude: 37.0902,
      longitude: -95.7129,
      languages: ['English'],
      currencies: ['US Dollar (USD)'],
      summary: 'The United States of America is a country of 50 states covering a vast swath of North America, with Alaska in the northwest and Hawaii extending the nation’s presence into the Pacific Ocean.',
      imageUrl: 'https://flagcdn.com/w320/us.png',
    ),
    Destination(
      id: 'ca',
      name: 'Canada',
      country: 'Canada',
      countryCode: 'CA',
      flagEmoji: '🇨🇦',
      capital: 'Ottawa',
      region: 'Americas',
      subregion: 'North America',
      population: 38250000,
      latitude: 56.1304,
      longitude: -106.3468,
      languages: ['English', 'French'],
      currencies: ['Canadian Dollar (CAD)'],
      summary: 'Canada is a country in North America. Its ten provinces and three territories extend from the Atlantic to the Pacific and northward into the Arctic Ocean.',
      imageUrl: 'https://flagcdn.com/w320/ca.png',
    ),
    Destination(
      id: 'ke',
      name: 'Kenya',
      country: 'Kenya',
      countryCode: 'KE',
      flagEmoji: '🇰🇪',
      capital: 'Nairobi',
      region: 'Africa',
      subregion: 'Eastern Africa',
      population: 53770000,
      latitude: -0.0236,
      longitude: 37.9062,
      languages: ['Swahili', 'English'],
      currencies: ['Kenyan Shilling (KES)'],
      summary: 'Kenya is a country in East Africa with coastline on the Indian Ocean. It encompasses savannah, lakelands, the dramatic Great Rift Valley and mountain highlands.',
      imageUrl: 'https://flagcdn.com/w320/ke.png',
    ),
    Destination(
      id: 'th',
      name: 'Thailand',
      country: 'Thailand',
      countryCode: 'TH',
      flagEmoji: '🇹🇭',
      capital: 'Bangkok',
      region: 'Asia',
      subregion: 'South-Eastern Asia',
      population: 71600000,
      latitude: 15.87,
      longitude: 100.9925,
      languages: ['Thai'],
      currencies: ['Thai Baht (THB)'],
      summary: 'Thailand is a Southeast Asian country. It’s known for tropical beaches, opulent royal palaces, ancient ruins and ornate temples displaying figures of Buddha.',
      imageUrl: 'https://flagcdn.com/w320/th.png',
    ),
    Destination(
      id: 'ch',
      name: 'Switzerland',
      country: 'Switzerland',
      countryCode: 'CH',
      flagEmoji: '🇨🇭',
      capital: 'Bern',
      region: 'Europe',
      subregion: 'Western Europe',
      population: 8698000,
      latitude: 46.8182,
      longitude: 8.2275,
      languages: ['German', 'French', 'Italian', 'Romansh'],
      currencies: ['Swiss Franc (CHF)'],
      summary: 'Switzerland is a mountainous Central European country, home to numerous lakes, villages and the high peaks of the Alps.',
      imageUrl: 'https://flagcdn.com/w320/ch.png',
    ),
    Destination(
      id: 'gb',
      name: 'United Kingdom',
      country: 'United Kingdom',
      countryCode: 'GB',
      flagEmoji: '🇬🇧',
      capital: 'London',
      region: 'Europe',
      subregion: 'Northern Europe',
      population: 67330000,
      latitude: 55.3781,
      longitude: -3.436,
      languages: ['English'],
      currencies: ['Pound Sterling (GBP)'],
      summary: 'The United Kingdom, made up of England, Scotland, Wales and Northern Ireland, is an island nation in northwestern Europe.',
      imageUrl: 'https://flagcdn.com/w320/gb.png',
    ),
  ];

  ExploreRepositoryImpl({
    required this.countriesService,
    required this.wikipediaService,
    required this.db,
  });

  @override
  Future<bool> isFavorite(String id) async {
    final query = db.select(db.favorites)
      ..where(
        (f) =>
            f.id.equals(id.toLowerCase()) & f.entityType.equals('destination'),
      );
    final result = await query.getSingleOrNull();
    return result != null;
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final key = id.toLowerCase();
    final existing =
        await (db.select(db.favorites)..where(
              (f) => f.id.equals(key) & f.entityType.equals('destination'),
            ))
            .getSingleOrNull();

    if (existing != null) {
      await (db.delete(db.favorites)..where(
            (f) => f.id.equals(key) & f.entityType.equals('destination'),
          ))
          .go();
    } else {
      await db
          .into(db.favorites)
          .insert(
            FavoritesCompanion.insert(id: key, entityType: 'destination'),
          );
    }

    final cached = _cache[key];
    if (cached != null) {
      final isFav = await isFavorite(key);
      _cache[key] = cached.copyWith(isFavorite: isFav);
    }
  }

  @override
  Future<Result<List<Destination>, AppException>> getDestinations({
    String region = 'All',
    String query = '',
  }) async {
    List<Destination> fetched;
    try {
      if (region.toLowerCase() == 'all' || region.isEmpty) {
        fetched = await countriesService.fetchAllDestinations();
      } else {
        fetched = await countriesService.fetchDestinationsByRegion(region);
      }
    } catch (e, stack) {
      AppLogger.error(
        'RestCountries API fetch failed, falling back to cached catalog',
        error: e,
        stackTrace: stack,
      );
      fetched = _fallbackDestinations;
    }

    final List<Destination> mapped = [];
    for (final dest in fetched) {
      final isFav = await isFavorite(dest.id);
      final updated = dest.copyWith(isFavorite: isFav);
      _cache[dest.id.toLowerCase()] = updated;
      mapped.add(updated);
    }

    var resultList = mapped;

    if (region.toLowerCase() != 'all' && region.isNotEmpty) {
      resultList = resultList
          .where((d) => d.region.toLowerCase() == region.toLowerCase())
          .toList();
    }

    if (query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      resultList = resultList.where((d) {
        return d.name.toLowerCase().contains(q) ||
            d.country.toLowerCase().contains(q) ||
            d.capital.toLowerCase().contains(q) ||
            d.region.toLowerCase().contains(q);
      }).toList();
    }

    resultList.sort((a, b) => a.name.compareTo(b.name));
    return Success(resultList);
  }

  @override
  Future<Result<Destination, AppException>> getDestinationDetail(
    String id,
  ) async {
    final key = id.toLowerCase();
    var baseDestination = _cache[key];

    if (baseDestination == null) {
      final allResult = await getDestinations();
      if (allResult.isSuccess) {
        baseDestination = _cache[key];
      }
    }

    baseDestination ??= _fallbackDestinations.firstWhere(
      (d) => d.id == key,
      orElse: () => _fallbackDestinations.first,
    );

    final isFav = await isFavorite(key);
    baseDestination = baseDestination.copyWith(isFavorite: isFav);

    try {
      final wikiSummaryMap = await wikipediaService.fetchSummary(
        baseDestination.name,
      );
      final extract =
          wikiSummaryMap['extract'] as String? ?? baseDestination.summary;
      final thumbnailMap = wikiSummaryMap['thumbnail'] as Map<String, dynamic>?;
      final wikiImg =
          thumbnailMap?['source'] as String? ?? baseDestination.imageUrl;

      final enriched = baseDestination.copyWith(
        summary: extract,
        imageUrl: wikiImg,
        isFavorite: isFav,
      );
      _cache[key] = enriched;
      return Success(enriched);
    } catch (_) {
      return Success(baseDestination);
    }
  }
}
