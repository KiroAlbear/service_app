import 'features/models/month_count.dart';

class Constants {
  static const String spreadsheetId =
      '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA';
  static Map<String, MonthCount> monthCountColumns = {
    '12': MonthCount(
      morningServiceColumn: 'J',
      communionColumn: 'K',
      serviceColumn: 'L',
      confessionColumn: 'M',
    ),
    '11': MonthCount(
      morningServiceColumn: 'O',
      communionColumn: 'P',
      serviceColumn: 'Q',
      confessionColumn: 'R',
    ),
    '10': MonthCount(
      morningServiceColumn: 'T',
      communionColumn: 'U',
      serviceColumn: 'V',
      confessionColumn: 'W',
    ),
    '9': MonthCount(
      morningServiceColumn: 'Y',
      communionColumn: 'Z',
      serviceColumn: 'AA',
      confessionColumn: 'AB',
    ),

    // First group of months 8 to 4
    '8': MonthCount(
      morningServiceColumn: 'AD',
      communionColumn: 'AE',
      serviceColumn: 'AF',
      confessionColumn: 'AG',
    ),
    '7': MonthCount(
      morningServiceColumn: 'AI',
      communionColumn: 'AJ',
      serviceColumn: 'AK',
      confessionColumn: 'AL',
    ),
    '6': MonthCount(
      morningServiceColumn: 'AN',
      communionColumn: 'AO',
      serviceColumn: 'AP',
      confessionColumn: 'AQ',
    ),
    '5': MonthCount(
      morningServiceColumn: 'AS',
      communionColumn: 'AT',
      serviceColumn: 'AU',
      confessionColumn: 'AV',
    ),
    '4': MonthCount(
      morningServiceColumn: 'AX',
      communionColumn: 'AY',
      serviceColumn: 'AZ',
      confessionColumn: 'BA',
    ),

    '3': MonthCount(
      morningServiceColumn: 'BC',
      communionColumn: 'BD',
      serviceColumn: 'BE',
      confessionColumn: 'BF',
    ),
    '2': MonthCount(
      morningServiceColumn: 'BH',
      communionColumn: 'BI',
      serviceColumn: 'BJ',
      confessionColumn: 'BK',
    ),
    '1': MonthCount(
      morningServiceColumn: 'BM',
      communionColumn: 'BN',
      serviceColumn: 'BO',
      confessionColumn: 'BP',
    ),
  };
}
