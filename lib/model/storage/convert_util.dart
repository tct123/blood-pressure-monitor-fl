
import 'package:flutter/material.dart';

/// Utility class for converting dynamic values to concrete data types.
///
/// The functions this class provides interprets dynamic values as values of the data type. This makes them useful for
/// contexts in which user generated data needs to be parsed.
///
/// An example for this are boolean fields in json data. Users could write `true` which will be converted to a boolean
/// automatically and can be just checked with the `is boolean` condition, but the user may also write `"true"` or 1
/// which are equally valid but would not get converted automatically.
class ConvertUtil {
  static bool? parseBool(dynamic value) {
    if (value is bool) return value;
    if (parseString(value)?.toLowerCase() == 'true' || parseInt(value) == 1) return true;
    if (parseString(value)?.toLowerCase() == 'false' || parseInt(value) == 0) return false;
    return null;
  }

  static int? parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return _isInt(value);
    if (value is String) return int.tryParse(value) ?? _isInt(double.tryParse(value));
    return null;
  }

  static int? _isInt(double? value) {
    if (value?.toInt() == value) return value?.toInt();
    return null;
  }

  static double? parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static String? parseString(dynamic value) {
    if (value is String) return value;
    if (value is int || value is double || value is bool) return value.toString();
    // No check for Object. While this would be convertible to string,
    return null;
  }

  static String serializeLocale(Locale? value) {
    if (value == null) return 'NULL';
    return value.languageCode;
  }

  static Locale? parseLocale(dynamic value) {
    if (value is Locale) return value;
    // Should not use parseString, as values that get caught by it can not be locales.
    if (value is String && value.toLowerCase() == 'null') return null;
    if (value is String) return Locale(value);
    return null;
  }

  static MaterialColor? parseMaterialColor(dynamic value) {
    if (value is MaterialColor) return value;
    if (value == null) return null;

    late final Color color;
    if (value is Color) {
      color = value;
    } else if (parseInt(value) != null) {
      color = Color(parseInt(value)!);
    } else {
      return null;
    }

    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  static DateTimeRange? parseRange(dynamic start, dynamic end) {
    final startTimestamp = parseInt(start);
    final endTimestamp = parseInt(end);
    if (startTimestamp == null || endTimestamp == null) return null;
    return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(startTimestamp),
        end: DateTime.fromMillisecondsSinceEpoch(endTimestamp)
    );
  }

  static List<T>? parseList<T>(dynamic value) {
    if (value is List<T>) return value;
    if (value is List<dynamic>) {
      List<T> validValues = [];
      for (final v in value) {
        if (v is T) validValues.add(v);
      }
      if (value.length == validValues.length) return validValues;
    }
    if (value is List && value.isEmpty) return [];
    return null;
  }
}