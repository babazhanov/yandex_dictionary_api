// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:yandex_dictionary_api/yandex_dictionary_api.dart';

void main() {
  group('YandexDictionaryApi', () {
    test('can be instantiated', () {
      expect(
        YandexDictionaryApi(
          key: YandexDictionaryKey(apiKey: ''),
        ),
        isNotNull,
      );
    });
  });
}
