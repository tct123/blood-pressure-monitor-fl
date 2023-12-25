import 'package:blood_pressure_app/model/export_import/record_formatter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


/// Type a [Formatter] can uses to indicate the kind of data returned.
///
/// The data types returned from the deprecated [LegacyExportColumn] may differ from the guarantees.
enum RowDataFieldType {
  /// Guarantees [DateTime] is returned.
  timestamp,
  /// Guarantees [int] is returned.
  sys,
  /// Guarantees [int] is returned.
  dia,
  /// Guarantees [int] is returned.
  pul,
  /// Guarantees [String] is returned.
  notes,
  /// Guarantees that the returned type is of type [MeasurementNeedlePin].
  needlePin;

  String localize(AppLocalizations localizations) {
    switch(this) {
      case RowDataFieldType.timestamp:
        return localizations.timestamp;
      case RowDataFieldType.sys:
        return localizations.sysLong;
      case RowDataFieldType.dia:
        return localizations.diaLong;
      case pul:
        return localizations.pulLong;
      case RowDataFieldType.notes:
        return localizations.notes;
      case RowDataFieldType.needlePin:
        return localizations.color;
    }
  }
}