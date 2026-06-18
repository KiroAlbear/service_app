import 'features/models/month_columns.dart';

class Constants {
  static const String spreadsheetId =
      '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA';

  static const String configSheetName = 'بيانات تطبيق الخدام';

  static const String morningServiceText = 'قداس';
  static const String communionText = 'تناول';
  static const String serviceText = 'اجتماع';
  static const String confessionText = 'اعتراف';

  static Map<String, MonthColumns> monthCountColumns = {
    '12': MonthColumns(
      morningServiceColumn: 'J',
      communionColumn: 'K',
      serviceColumn: 'L',
      confessionColumn: 'M',
    ),
    '11': MonthColumns(
      morningServiceColumn: 'O',
      communionColumn: 'P',
      serviceColumn: 'Q',
      confessionColumn: 'R',
    ),
    '10': MonthColumns(
      morningServiceColumn: 'T',
      communionColumn: 'U',
      serviceColumn: 'V',
      confessionColumn: 'W',
    ),
    '9': MonthColumns(
      morningServiceColumn: 'Y',
      communionColumn: 'Z',
      serviceColumn: 'AA',
      confessionColumn: 'AB',
    ),

    // First group of months 8 to 4
    '8': MonthColumns(
      morningServiceColumn: 'AD',
      communionColumn: 'AE',
      serviceColumn: 'AF',
      confessionColumn: 'AG',
    ),
    '7': MonthColumns(
      morningServiceColumn: 'AI',
      communionColumn: 'AJ',
      serviceColumn: 'AK',
      confessionColumn: 'AL',
    ),
    '6': MonthColumns(
      morningServiceColumn: 'AN',
      communionColumn: 'AO',
      serviceColumn: 'AP',
      confessionColumn: 'AQ',
    ),
    '5': MonthColumns(
      morningServiceColumn: 'AS',
      communionColumn: 'AT',
      serviceColumn: 'AU',
      confessionColumn: 'AV',
    ),
    '4': MonthColumns(
      morningServiceColumn: 'AX',
      communionColumn: 'AY',
      serviceColumn: 'AZ',
      confessionColumn: 'BA',
    ),

    '3': MonthColumns(
      morningServiceColumn: 'BC',
      communionColumn: 'BD',
      serviceColumn: 'BE',
      confessionColumn: 'BF',
    ),
    '2': MonthColumns(
      morningServiceColumn: 'BH',
      communionColumn: 'BI',
      serviceColumn: 'BJ',
      confessionColumn: 'BK',
    ),
    '1': MonthColumns(
      morningServiceColumn: 'BM',
      communionColumn: 'BN',
      serviceColumn: 'BO',
      confessionColumn: 'BP',
    ),
  };
}
