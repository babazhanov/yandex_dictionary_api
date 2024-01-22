import 'package:yandex_dictionary_api/yandex_dictionary_api.dart';

Future<void> main() async {
  try {
    final yandexDictionaryKey = YandexDictionaryKey(apiKey: '');
    final yandexDictionaryApi = YandexDictionaryApi(key: yandexDictionaryKey);

    final getLangsResponse = await yandexDictionaryApi.getLangs();
    print(getLangsResponse);

    final lookupRequest = YandexLookupRequest(lang: 'en-tr', text: 'hello');
    final lookupResponse = await yandexDictionaryApi.lookup(lookupRequest);
    print(lookupResponse.def?.first);
  } on YandexDictionaryException catch (error, stackTrace) {
    print(error);
    print(stackTrace);
  }
}
