import 'package:yandex_dictionary_api/yandex_dictionary_api.dart';

/// {@template yandex_dictionary_api}
/// A Yandex Dictionary API Package.
/// {@endtemplate}
final class YandexDictionaryApi {
  /// {@macro yandex_dictionary_api}
  YandexDictionaryApi({
    required YandexDictionaryKey key,
    YandexDictionaryClient? client,
  })  : _client = client ?? YandexDictionaryClient(),
        _key = key;

  final YandexDictionaryKey _key;
  final YandexDictionaryClient _client;

  /// Returns a list of translation directions supported by the service.
  Future<List<String>> getLangs() => _client.getLangs(_key.apiKey);

  /// Searches for a word or phrase in the dictionary and returns
  /// an automatically generated dictionary entry.
  Future<YandexLookupResponse> lookup(YandexLookupRequest request) =>
      _client.lookup(request, _key.apiKey);
}
