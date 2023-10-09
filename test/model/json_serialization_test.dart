
import 'package:blood_pressure_app/model/horizontal_graph_line.dart';
import 'package:blood_pressure_app/model/storage/export_csv_settings_store.dart';
import 'package:blood_pressure_app/model/storage/export_pdf_settings_store.dart';
import 'package:blood_pressure_app/model/storage/export_settings_store.dart';
import 'package:blood_pressure_app/model/storage/intervall_store.dart';
import 'package:blood_pressure_app/model/storage/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntervallStorage', () {
    test('should create json without error', () {
      final intervall = IntervallStorage(stepSize: TimeStep.year);
      final json = intervall.toJson();
      expect(json.length, greaterThan(0));
    });

    test('should load same data from json', () {
      final initialData = IntervallStorage();
      final json = initialData.toJson();
      final recreatedData = IntervallStorage.fromJson(json);

      expect(initialData.stepSize, recreatedData.stepSize);
      expect(initialData.currentRange.start.millisecondsSinceEpoch,
          recreatedData.currentRange.start.millisecondsSinceEpoch);
      expect(initialData.currentRange.end.millisecondsSinceEpoch,
          recreatedData.currentRange.end.millisecondsSinceEpoch);
    });

    test('should load same data from json in edge cases', () {
      final initialData = IntervallStorage(stepSize: TimeStep.month, range: DateTimeRange(
          start: DateTime.fromMillisecondsSinceEpoch(1234),
          end: DateTime.fromMillisecondsSinceEpoch(5678)
      ));
      final json = initialData.toJson();
      final recreatedData = IntervallStorage.fromJson(json);

      expect(initialData.stepSize, TimeStep.month);
      expect(recreatedData.currentRange.start.millisecondsSinceEpoch, 1234);
      expect(recreatedData.currentRange.end.millisecondsSinceEpoch, 5678);
    });

    test('should not crash when parsing incorrect json', () {
      IntervallStorage.fromJson('banana');
      IntervallStorage.fromJson('{"stepSize" = 1}');
      IntervallStorage.fromJson('{"stepSize": 1');
      IntervallStorage.fromJson('{stepSize: 1}');
      IntervallStorage.fromJson('green{stepSize: 1}');
    });

    test('should not crash when parsing invalid values and ignore them', () {
      final v1 = IntervallStorage.fromJson('{"stepSize": true}');
      final v2 = IntervallStorage.fromJson('{"stepSize": "month"}');
      final v3 = IntervallStorage.fromJson('{"start": "month", "end": 10.5}');
      final v4 = IntervallStorage.fromJson('{"start": 18.6, "end": 90.65}');

      expect(v1.stepSize, TimeStep.last7Days);
      expect(v2.stepSize, TimeStep.last7Days);
      expect(v3.stepSize, TimeStep.last7Days);

      // in minutes to avoid failing through performance
      expect(v2.currentRange.duration.inMinutes, v1.currentRange.duration.inMinutes);
      expect(v3.currentRange.duration.inMinutes, v1.currentRange.duration.inMinutes);
      expect(v4.currentRange.duration.inMinutes, v1.currentRange.duration.inMinutes);
    });
  });

  group('Settings', (){
    test('should be able to recreate all values from json', () {
      final initial = Settings(
        language: const Locale('en'),
        accentColor: Colors.deepOrange,
        sysColor: Colors.deepOrange,
        diaColor: Colors.deepOrange,
        pulColor: Colors.deepOrange,
        dateFormatString: 'Lorem Ipsum',
        graphLineThickness: 134.23123,
        animationSpeed: 78,
        sysWarn: 78,
        diaWarn: 78,
        allowManualTimeInput: false,
        confirmDeletion: false,
        darkMode: false,
        followSystemDarkMode: false,
        validateInputs: false,
        allowMissingValues: false,
        drawRegressionLines: false,
        startWithAddMeasurementPage: false,
        useLegacyList: false,
        horizontalGraphLines: [HorizontalGraphLine(Colors.blue, 1230)],
      );
      final fromJson = Settings.fromJson(initial.toJson());

      expect(initial.language, fromJson.language);
      expect(initial.accentColor.value, fromJson.accentColor.value);
      expect(initial.sysColor.value, fromJson.sysColor.value);
      expect(initial.diaColor.value, fromJson.diaColor.value);
      expect(initial.pulColor.value, fromJson.pulColor.value);
      expect(initial.dateFormatString, fromJson.dateFormatString);
      expect(initial.graphLineThickness, fromJson.graphLineThickness);
      expect(initial.animationSpeed, fromJson.animationSpeed);
      expect(initial.sysWarn, fromJson.sysWarn);
      expect(initial.diaWarn, fromJson.diaWarn);
      expect(initial.allowManualTimeInput, fromJson.allowManualTimeInput);
      expect(initial.confirmDeletion, fromJson.confirmDeletion);
      expect(initial.darkMode, fromJson.darkMode);
      expect(initial.followSystemDarkMode, fromJson.followSystemDarkMode);
      expect(initial.validateInputs, fromJson.validateInputs);
      expect(initial.allowMissingValues, fromJson.allowMissingValues);
      expect(initial.drawRegressionLines, fromJson.drawRegressionLines);
      expect(initial.startWithAddMeasurementPage, fromJson.startWithAddMeasurementPage);
      expect(initial.useLegacyList, fromJson.useLegacyList);
      expect(initial.horizontalGraphLines.length, fromJson.horizontalGraphLines.length);
      expect(initial.horizontalGraphLines.first.color.value, fromJson.horizontalGraphLines.first.color.value);
      expect(initial.horizontalGraphLines.first.height, fromJson.horizontalGraphLines.first.height);

      expect(initial.toJson(), fromJson.toJson());
    });

    test('should not crash when parsing incorrect json', () {
      Settings.fromJson('banana');
      Settings.fromJson('{"stepSize" = 1}');
      Settings.fromJson('{"stepSize": 1');
      Settings.fromJson('{stepSize: 1}');
      Settings.fromJson('green{stepSize: 1}');
    });

    test('should not crash when parsing invalid values and ignore them', () {
      final v1 = Settings.fromJson('{"pulColor": true}');
      final v2 = Settings.fromJson('{"validateInputs": "red"}');
      final v3 = Settings.fromJson('{"validateInputs": "month", "useLegacyList": 10.5}');
      Settings.fromJson('{"sysWarn": 18.6, "diaWarn": 90.65}');

      expect(v1.pulColor.value, Settings().pulColor.value);
      expect(v2.validateInputs, Settings().validateInputs);
      expect(v3.useLegacyList, Settings().useLegacyList);
    });
  });

  group('ExportSettings', (){
    test('should be able to recreate all values from json', () {
      final initial = ExportSettings(
        exportFormat: ExportFormat.db,
        defaultExportDir: 'lorem ipsum',
        exportAfterEveryEntry: true,
      );
      final fromJson = ExportSettings.fromJson(initial.toJson());

      expect(initial.exportFormat, fromJson.exportFormat);
      expect(initial.defaultExportDir, fromJson.defaultExportDir);
      expect(initial.exportAfterEveryEntry, fromJson.exportAfterEveryEntry);

      expect(initial.toJson(), fromJson.toJson());
    });

    test('should not crash when parsing incorrect json', () {
      ExportSettings.fromJson('banana');
      ExportSettings.fromJson('{"defaultExportDir" = 1}');
      ExportSettings.fromJson('{"defaultExportDir": 1');
      ExportSettings.fromJson('{defaultExportDir: 1}');
      ExportSettings.fromJson('green{exportFormat: 1}');
    });

    test('should not crash when parsing invalid values and ignore them', () {
      final v1 = ExportSettings.fromJson('{"defaultExportDir": ["test"]}');
      final v2 = ExportSettings.fromJson('{"exportFormat": "red"}');
      final v3 = ExportSettings.fromJson('{"exportFormat": "month", "exportAfterEveryEntry": 15}');

      expect(v1.defaultExportDir, ExportSettings().defaultExportDir);
      expect(v2.exportFormat, ExportSettings().exportFormat);
      expect(v3.exportFormat, ExportSettings().exportFormat);
      expect(v3.exportAfterEveryEntry, ExportSettings().exportAfterEveryEntry);
    });
  });

  group('CsvExportSettings', (){
    test('should be able to recreate all values from json', () {
      final initial = CsvExportSettings(
        fieldDelimiter: 'asdfghjklö',
        textDelimiter: 'asdfghjklö2',
        exportHeadline: false,
        exportCustomFields: true,
        customFields: ['test1', 'test2'],
      );
      final fromJson = CsvExportSettings.fromJson(initial.toJson());

      expect(initial.fieldDelimiter, fromJson.fieldDelimiter);
      expect(initial.textDelimiter, fromJson.textDelimiter);
      expect(initial.exportHeadline, fromJson.exportHeadline);
      expect(initial.exportCustomFields, fromJson.exportCustomFields);
      expect(initial.customFields, fromJson.customFields);

      expect(initial.toJson(), fromJson.toJson());
    });

    test('should not crash when parsing incorrect json', () {
      CsvExportSettings.fromJson('banana');
      CsvExportSettings.fromJson('{"fieldDelimiter" = 1}');
      CsvExportSettings.fromJson('{"fieldDelimiter": 1');
      CsvExportSettings.fromJson('{fieldDelimiter: 1}');
      CsvExportSettings.fromJson('green{fieldDelimiter: 1}');
    });

    test('should not crash when parsing invalid values and ignore them', () {
      final v1 = CsvExportSettings.fromJson('{"fieldDelimiter": ["test"]}');
      final v2 = CsvExportSettings.fromJson('{"exportHeadline": "red"}');
      final v3 = CsvExportSettings.fromJson('{"textDelimiter": "month", "textDelimiter": {"test": 10.5}}');

      expect(v1.fieldDelimiter, CsvExportSettings().fieldDelimiter);
      expect(v2.exportHeadline, CsvExportSettings().exportHeadline);
      expect(v3.textDelimiter, CsvExportSettings().textDelimiter);
      expect(v3.exportCustomFields, CsvExportSettings().exportCustomFields);
      expect(v3.customFields, CsvExportSettings().customFields);
    });
  });

  group('PdfExportSettings', (){
    test('should be able to recreate all values from json', () {
      final initial = PdfExportSettings(
        exportTitle: false,
        exportStatistics: false,
        exportData: false,
        headerHeight: 67.89,
        cellHeight: 67.89,
        headerFontSize: 67.89,
        cellFontSize: 67.89,
        exportCustomFields: true,
        customFields: ['test1', 'test2'],
      );
      final fromJson = PdfExportSettings.fromJson(initial.toJson());

      expect(initial.exportTitle, fromJson.exportTitle);
      expect(initial.exportStatistics, fromJson.exportStatistics);
      expect(initial.exportData, fromJson.exportData);
      expect(initial.headerHeight, fromJson.headerHeight);
      expect(initial.cellHeight, fromJson.cellHeight);
      expect(initial.headerFontSize, fromJson.headerFontSize);
      expect(initial.cellFontSize, fromJson.cellFontSize);
      expect(initial.exportCustomFields, fromJson.exportCustomFields);
      expect(initial.customFields, fromJson.customFields);

      expect(initial.toJson(), fromJson.toJson());
    });

    test('should not crash when parsing incorrect json', () {
      PdfExportSettings.fromJson('banana');
      PdfExportSettings.fromJson('{"cellFontSize" = 1}');
      PdfExportSettings.fromJson('{"cellFontSize": 1');
      PdfExportSettings.fromJson('{cellFontSize: 1}');
      PdfExportSettings.fromJson('green{fieldDelimiter: 1}');
    });

    test('should not crash when parsing invalid values and ignore them', () {
      final v1 = PdfExportSettings.fromJson('{"cellFontSize": ["test"]}');
      final v2 = PdfExportSettings.fromJson('{"cellFontSize": "red"}');
      final v3 = PdfExportSettings.fromJson('{"headerFontSize": "month", "exportData": 15}');

      expect(v1.cellFontSize, PdfExportSettings().cellFontSize);
      expect(v2.cellFontSize, PdfExportSettings().cellFontSize);
      expect(v3.headerFontSize, PdfExportSettings().headerFontSize);
      expect(v3.exportData, PdfExportSettings().exportData);
    });
  });
}