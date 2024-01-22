import 'package:yandex_dictionary_api/yandex_dictionary_api.dart';

Future<void> main() async {
  try {
    final yandexDictionaryKey = YandexDictionaryKey(apiKey: '');
    final yandexDictionaryApi = YandexDictionaryApi(key: yandexDictionaryKey);

    final langs = await yandexDictionaryApi.getLangs();
    print(langs);

    final lookupRequest = YandexLookupRequest(lang: 'en-tr', text: 'hello');
    final resuult = await yandexDictionaryApi.lookup(lookupRequest);
    print(resuult.def?.first);
  } on YandexDictionaryException catch (error, stackTrace) {
    print(error);
    print(stackTrace);
  }
}
