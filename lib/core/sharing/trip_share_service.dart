import 'dart:convert';

import 'package:encrypt/encrypt.dart';

import '../database/app_database.dart';

class TripShareService {
  // Use a fixed key for this project-wide implementation (POC)
  static final _key = Key.fromUtf8('opentrail_secret_key_32_chars_!!');
  static final _iv = IV.fromLength(16);
  static final _encrypter = Encrypter(AES(_key));

  /// Serializes a trip and its itinerary items, then encrypts to a Base64 string.
  static String encryptTrip(Trip trip, List<ItineraryItem> items) {
    final payload = {
      'version': 1,
      'trip': trip.toJson(),
      'items': items.map((i) => i.toJson()).toList(),
    };
    final jsonStr = jsonEncode(payload);
    return _encrypter.encrypt(jsonStr, iv: _iv).base64;
  }

  /// Decrypts a Base64 string and parses the trip data.
  static Map<String, dynamic>? decryptTrip(String base64Data) {
    try {
      final decrypted = _encrypter.decrypt64(base64Data, iv: _iv);
      return jsonDecode(decrypted) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
