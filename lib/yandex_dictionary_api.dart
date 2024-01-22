/// The API is used for getting detailed dictionary entries from the static
/// Yandex.Dictionary. Unlike conventional translation dictionaries, it is
/// compiled automatically using the technologies at the root of the Yandex
/// machine translation system. Yandex.Dictionary entries include the word’s
/// part of speech, and translations are grouped with examples. For English
/// words, the transcription is provided. The service supports a total of 17
///  language pairs.
library yandex_dictionary_api;

export 'src/types.dart';
export 'src/yandex_dictionary_api.dart';
export 'src/yandex_dictionary_client.dart';
