// source: https://pressbooks.library.torontomu.ca/vitalsign/chapter/blood-pressure-ranges/ (last access: 14.11.2023)
class BloodPressureWarnValues {
  BloodPressureWarnValues._create();

  static String source = 'https://pressbooks.library.torontomu.ca/vitalsign/chapter/blood-pressure-ranges/';

  static int getUpperDiaWarnValue(int age) {
    if (age <= 2) {
      return 70;
    } else if (age <= 13) {
      return 80;
    } else if (age <= 18) {
      return 80;
    } else if (age <= 40) {
      return 80;
    } else if (age <= 60) {
      return 90;
    } else {
      return 90;
    }
  }

  static int getUpperSysWarnValue(int age) {
    if (age <= 2) {
      return 100;
    } else if (age <= 13) {
      return 120;
    } else if (age <= 18) {
      return 120;
    } else if (age <= 40) {
      return 125;
    } else if (age <= 60) {
      return 145;
    } else {
      return 145;
    }
  }
}