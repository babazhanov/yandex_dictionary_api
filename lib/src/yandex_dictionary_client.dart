import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:yandex_dictionary_api/src/constants.dart';
import 'package:yandex_dictionary_api/src/types.dart';

/// {@template yandex_dictionary_exception}
/// An [YandexDictionaryException] is thrown if an error occurs
///  while sending the request.
/// {@endtemplate}
sealed class YandexDictionaryException implements Exception {
  /// {@macro yandex_dictionary_exception}
  const YandexDictionaryException(this.error);

  /// The error which was caught.
  final Object? error;

  @override
  String toString() {
    return 'YandexDictionaryException - $error';
  }
}

/// {@template yandex_dictionary_invalid_key_exception}
/// Thrown when invalid API key.
/// {@endtemplate}
final class YandexDictionaryInvalidKeyException
    extends YandexDictionaryException {
  /// {@macro yandex_dictionary_invalid_key_exception}
  const YandexDictionaryInvalidKeyException(super.error);
}

/// {@template yandex_dictionary_blocked_key_exception}
/// Thrown when this API key has been blocked.
/// {@endtemplate}
final class YandexDictionaryBlockedKeyException
    extends YandexDictionaryException {
  /// {@macro yandex_dictionary_blocked_key_exception}
  const YandexDictionaryBlockedKeyException(super.error);
}

/// {@template yandex_dictionary_daily_request_limit_exception}
/// Exceeded the daily limit on the number of requests.
/// {@endtemplate}
final class YandexDictionaryDailyRequestLimitException
    extends YandexDictionaryException {
  /// {@macro yandex_dictionary_daily_request_limit_exception}
  const YandexDictionaryDailyRequestLimitException(super.error);
}

/// {@template yandex_dictionary_text_too_long_exception}
/// The text size exceeds the maximum.
/// {@endtemplate}
final class YandexDictionaryTextTooLongException
    extends YandexDictionaryException {
  /// {@macro yandex_dictionary_text_too_long_exception}
  const YandexDictionaryTextTooLongException(super.error);
}

/// {@template yandex_dictionary_lang_not_supported_exception}
/// The specified translation direction is not supported.
/// {@endtemplate}
final class YandexDictionaryLangNotSupportedException
    extends YandexDictionaryException {
  /// {@macro yandex_dictionary_lang_not_supported_exception}
  const YandexDictionaryLangNotSupportedException(super.error);
}

/// {@template yandex_dictionary_unknown_exception}
/// Thrown when unknown error cases.
/// {@endtemplate}
final class YandexDictionaryUnknownException extends YandexDictionaryException {
  /// {@macro yandex_dictionary_unknown_exception}
  const YandexDictionaryUnknownException(super.error);
}

/// {@template yandex_dictionary_client}
/// It requests Yandex services and parses the data.
/// {@endtemplate}
final class YandexDictionaryClient {
  /// {@macro yandex_dictionary_client}
  YandexDictionaryClient({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  /// Returns a list of translation directions supported by the service.
  Future<List<String>> getLangs(String apiKey) async {
    try {
      final uri = Uri.https(kBaseUrl, kGetLangUrl, {
        'key': apiKey,
      });

      final repsonse = await _client.get(uri);

      if (repsonse.statusCode == HttpStatus.unauthorized) {
        throw const YandexDictionaryInvalidKeyException(
          'Invalid API key.',
        );
      } else if (repsonse.statusCode == HttpStatus.paymentRequired) {
        throw const YandexDictionaryBlockedKeyException(
          'This API key has been blocked.',
        );
      } else if (repsonse.statusCode == HttpStatus.ok) {
        final json = await Isolate.run(() => jsonDecode(repsonse.body));
        if (json is List<dynamic>) {
          return json.cast<String>();
        } else {
          throw YandexDictionaryUnknownException(
            'Json Type Error: ${json.runtimeType}',
          );
        }
      } else {
        throw YandexDictionaryUnknownException(
          'Status code Error: ${repsonse.statusCode}',
        );
      }
    } on YandexDictionaryException catch (_) {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        YandexDictionaryUnknownException(error),
        stackTrace,
      );
    }
  }

  /// Searches for a word or phrase in the dictionary and returns
  /// an automatically generated dictionary entry.
  Future<YandexLookupResponse> lookup(
    YandexLookupRequest request,
    String apiKey,
  ) async {
    try {
      final uri = Uri.https(kBaseUrl, kLookupUrl, {
        'key': apiKey,
        'lang': request.lang,
        'text': request.text,
      });

      final repsonse = await _client.get(uri);

      if (repsonse.statusCode == HttpStatus.unauthorized) {
        throw const YandexDictionaryInvalidKeyException(
          'Invalid API key.',
        );
      } else if (repsonse.statusCode == HttpStatus.paymentRequired) {
        throw const YandexDictionaryBlockedKeyException(
          'This API key has been blocked.',
        );
      } else if (repsonse.statusCode == HttpStatus.forbidden) {
        throw const YandexDictionaryDailyRequestLimitException(
          'Exceeded the daily limit on the number of requests.',
        );
      } else if (repsonse.statusCode == HttpStatus.requestEntityTooLarge) {
        throw const YandexDictionaryTextTooLongException(
          'The text size exceeds the maximum.',
        );
      } else if (repsonse.statusCode == HttpStatus.notImplemented) {
        throw const YandexDictionaryLangNotSupportedException(
          'The specified translation direction is not supported.',
        );
      } else if (repsonse.statusCode == HttpStatus.ok) {
        final json = await Isolate.run(() => jsonDecode(repsonse.body));
        if (json is Map<String, dynamic>) {
          return YandexLookupResponse.fromJson(json);
        } else {
          throw YandexDictionaryUnknownException(
            'Json Type Error: ${json.runtimeType}',
          );
        }
      } else {
        throw YandexDictionaryUnknownException(
          'Status code Error: ${repsonse.statusCode}',
        );
      }
    } on YandexDictionaryException catch (_) {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        YandexDictionaryUnknownException(error),
        stackTrace,
      );
    }
  }
}
