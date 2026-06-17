import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:service/constants.dart';
import 'package:service/core/services/secure_storage/secure_storage_keys.dart';
import 'package:service/core/services/secure_storage/secure_storage_manager.dart';

import '../../features/models/SheetFullName.dart';

class GoogleSheetsService {
  static GoogleSheetsService? _instance;

  static GoogleSheetsService getInstance() {
    return _instance ??= GoogleSheetsService();
  }

  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/spreadsheets',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser;
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) {
      return;
    }

    await _googleSignIn.initialize(
      serverClientId:
          "740898183630-cd7shmlk22lir62sqrrspj65eohu5isu.apps.googleusercontent.com",
    );
    // await _googleSignIn.initialize(
    //   serverClientId:
    //       "740898183630-fip58noqt3s18bmellgf9nl0rifngqiu.apps.googleusercontent.com",
    // );

    _googleSignIn.authenticationEvents.listen((event) {
      switch (event) {
        case GoogleSignInAuthenticationEventSignIn():
          _currentUser = event.user;
          break;
        case GoogleSignInAuthenticationEventSignOut():
          _currentUser = null;
          break;
      }
    });

    await _googleSignIn.attemptLightweightAuthentication();
    _isInitialized = true;
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
  }

  Future<String> getSheetNameofServant(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      throw Exception("username or password cannot be empty");
    }

    await GoogleSheetsService.getInstance().init();

    final servantName = await _getNameByUsernameAndPassword(
      username: username,
      password: password,
    );

    if (servantName == null) {
      throw Exception("Invalid username or password");
    }

    final List<String> sheetNames =
        await _getSheetNamesOfCurrentYearWhereC5ContainsName(name: servantName);

    if (sheetNames.isEmpty) {
      throw Exception("No sheet found for this user");
    }

    SecureStorageManager.getInstance().setValue(
      SecureStorageKeys.servantName,
      servantName,
    );

    return sheetNames.first;
  }

  Future<GoogleSignInAccount> _signIn() async {
    _currentUser ??= await _googleSignIn.authenticate();
    return _currentUser!;
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final user = _currentUser ?? await _signIn();

    final authorization = await user.authorizationClient.authorizationForScopes(
      _scopes,
    );

    if (authorization == null) {
      await user.authorizationClient.authorizeScopes(_scopes);
    }

    final headers = await user.authorizationClient.authorizationHeaders(
      _scopes,
    );

    if (headers == null) {
      throw Exception('Could not get authorization headers.');
    }

    return headers;
  }

  Future<int> _getFirstEmptyRowInsideTable({
    required String sheetName,
    int startRow = 9,
    int endRow = 28,
  }) async {
    final headers = await _getAuthHeaders();

    // Read C:H, but we will check D:H because C may already contain serial numbers.
    final range = Uri.encodeComponent('$sheetName!C$startRow:H$endRow');

    final uri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}/values/$range'
      '?majorDimension=ROWS'
      '&valueRenderOption=FORMATTED_VALUE',
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to read table rows: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final values = (body['values'] as List?) ?? [];

    final totalRows = endRow - startRow + 1;

    for (int i = 0; i < totalRows; i++) {
      final row = i < values.length
          ? List<Object?>.from(values[i])
          : <Object?>[];

      // C:H = 6 columns.
      // C index 0 may contain serial number.
      // Check D:H only => indexes 1 to 5.
      bool dataCellsAreEmpty = true;

      for (int col = 1; col <= 5; col++) {
        final value = col < row.length ? row[col] : null;

        if (value != null && value.toString().trim().isNotEmpty) {
          dataCellsAreEmpty = false;
          break;
        }
      }

      if (dataCellsAreEmpty) {
        return startRow + i;
      }
    }

    throw Exception('No empty row found inside C:H table.');
  }

  Future<void> writeRowInsideTable({
    required String sheetName,
    required List<Object?> row,
  }) async {
    final user = _currentUser ?? await _signIn();

    final authorization = await user.authorizationClient.authorizationForScopes(
      _scopes,
    );

    if (authorization == null) {
      await user.authorizationClient.authorizeScopes(_scopes);
    }

    final headers = await user.authorizationClient.authorizationHeaders(
      _scopes,
    );

    if (headers == null) {
      throw Exception('Could not get authorization headers.');
    }
    final int rowNumber = await _getFirstEmptyRowInsideTable(
      sheetName: sheetName,
    );
    final lastColumn = "H";
    final escapedSheetName = sheetName.replaceAll("'", "''");

    final range = Uri.encodeComponent(
      "'$escapedSheetName'!C$rowNumber:$lastColumn$rowNumber",
    );

    final uri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}/values/$range'
      '?valueInputOption=USER_ENTERED',
    );

    final response = await http.put(
      uri,
      headers: {...headers, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'majorDimension': 'ROWS',
        'values': [row],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to write inside table: ${response.body}');
    }
  }

  Future<Map<String, int>> incrementColumnByExactName({
    required String sheetName,
    required String targetColumnLetter,
    required String firstName, // Column C
    required String fatherName, // Column D
    required String grandfatherName, // Column E
    int startRow = 9,
  }) async {
    final headers = await _getAuthHeaders();

    final targetColumn = targetColumnLetter.trim().toUpperCase();

    if (!RegExp(r'^[A-Z]+$').hasMatch(targetColumn)) {
      throw Exception('Invalid column letter: $targetColumnLetter');
    }

    // Read only the name columns C/D/E
    final namesRange = _sheetRange(sheetName, 'C$startRow:E');

    final namesUri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}/values/'
      '${Uri.encodeComponent(namesRange)}'
      '?majorDimension=ROWS&valueRenderOption=UNFORMATTED_VALUE',
    );

    final namesResponse = await http.get(namesUri, headers: headers);

    if (namesResponse.statusCode < 200 || namesResponse.statusCode >= 300) {
      throw Exception('Failed to read names: ${namesResponse.body}');
    }

    final namesBody = jsonDecode(namesResponse.body) as Map<String, dynamic>;
    final rows = namesBody['values'] as List<dynamic>? ?? [];

    int? matchedSheetRow;

    String clean(Object? value) => value?.toString().trim() ?? '';

    for (int i = 0; i < rows.length; i++) {
      final row = rows[i] as List<dynamic>;

      final cName = row.isNotEmpty ? clean(row[0]) : '';
      final dName = row.length > 1 ? clean(row[1]) : '';
      final eName = row.length > 2 ? clean(row[2]) : '';

      final isSameStudent =
          cName == firstName.trim() &&
          dName == fatherName.trim() &&
          eName == grandfatherName.trim();

      if (isSameStudent) {
        if (matchedSheetRow != null) {
          throw Exception(
            'More than one row found for this exact name in columns C/D/E.',
          );
        }

        matchedSheetRow = startRow + i;
      }
    }

    if (matchedSheetRow == null) {
      throw Exception(
        'Name not found in columns C/D/E: $firstName $fatherName $grandfatherName',
      );
    }

    // Read current value from the target column in the matched row
    final targetCellRange = _sheetRange(
      sheetName,
      '$targetColumn$matchedSheetRow',
    );

    final targetCellReadUri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}/values/'
      '${Uri.encodeComponent(targetCellRange)}'
      '?valueRenderOption=UNFORMATTED_VALUE',
    );

    final targetCellReadResponse = await http.get(
      targetCellReadUri,
      headers: headers,
    );

    if (targetCellReadResponse.statusCode < 200 ||
        targetCellReadResponse.statusCode >= 300) {
      throw Exception(
        'Failed to read target cell $targetColumn$matchedSheetRow: '
        '${targetCellReadResponse.body}',
      );
    }

    final targetCellBody =
        jsonDecode(targetCellReadResponse.body) as Map<String, dynamic>;

    final values = targetCellBody['values'] as List<dynamic>?;

    final currentValueText =
        values != null &&
            values.isNotEmpty &&
            values[0] is List &&
            (values[0] as List).isNotEmpty
        ? clean((values[0] as List)[0])
        : '';

    final currentValue = num.tryParse(currentValueText)?.toInt() ?? 0;
    final newValue = currentValue + 1;

    // Write only the target cell, so formatting/borders stay unchanged
    final targetCellUpdateUri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}/values/'
      '${Uri.encodeComponent(targetCellRange)}'
      '?valueInputOption=USER_ENTERED',
    );

    final updateResponse = await http.put(
      targetCellUpdateUri,
      headers: {...headers, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'values': [
          [newValue],
        ],
      }),
    );

    if (updateResponse.statusCode < 200 || updateResponse.statusCode >= 300) {
      throw Exception(
        'Failed to increment cell $targetColumn$matchedSheetRow: '
        '${updateResponse.body}',
      );
    }

    return {'row': matchedSheetRow, 'newValue': newValue};
  }

  Future<List<SheetFullName>> getFullNamesInTable({
    required String sheetName,
    int startRow = 9,
    int endRow = 80,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    final headers = await _getAuthHeaders();

    // Read names from C/D/E only.
    // C = first name, D = father name, E = grandfather name
    final range = _sheetRange(sheetName, 'C$startRow:E$endRow');

    final uri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}/values/'
      '${Uri.encodeComponent(range)}'
      '?majorDimension=ROWS&valueRenderOption=UNFORMATTED_VALUE',
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to get full names: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final rows = body['values'] as List<dynamic>? ?? [];

    String clean(Object? value) => value?.toString().trim() ?? '';

    final List<SheetFullName> names = [];

    for (int i = 0; i < rows.length; i++) {
      final row = rows[i] as List<dynamic>;

      final firstName = row.isNotEmpty ? clean(row[0]) : '';
      final fatherName = row.length > 1 ? clean(row[1]) : '';
      final grandfatherName = row.length > 2 ? clean(row[2]) : '';

      // Ignore completely empty rows inside the table
      if (firstName.isEmpty && fatherName.isEmpty && grandfatherName.isEmpty) {
        continue;
      }

      final fullName = [
        firstName,
        fatherName,
        grandfatherName,
      ].where((part) => part.isNotEmpty).join(' ');

      names.add(
        SheetFullName(
          rowNumber: startRow + i,
          firstName: firstName,
          fatherName: fatherName,
          grandfatherName: grandfatherName,
          fullName: fullName,
        ),
      );
    }

    return names;
  }

  Future<List<String>> getSheetNames() async {
    final headers = await _getAuthHeaders();

    final uri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}'
      '?fields=sheets.properties.title',
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to get sheet names: ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    final sheets = body['sheets'] as List<dynamic>? ?? [];

    return sheets.map((sheet) {
      final properties = sheet['properties'] as Map<String, dynamic>;
      return properties['title'].toString();
    }).toList();
  }

  Future<String?> _getNameByUsernameAndPassword({
    required String username,
    required String password,
  }) async {
    final user = _currentUser ?? await _signIn();

    final authorization = await user.authorizationClient.authorizationForScopes(
      _scopes,
    );

    if (authorization == null) {
      await user.authorizationClient.authorizeScopes(_scopes);
    }

    final headers = await user.authorizationClient.authorizationHeaders(
      _scopes,
    );

    if (headers == null) {
      throw Exception('Could not get authorization headers.');
    }

    // Sheet1 columns:
    // A = الباسورد
    // B = اسم المستخدم
    // C = اسم الخادم
    final range = Uri.encodeComponent('Sheet1!A:C');

    final uri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}/values/$range'
      '?majorDimension=ROWS'
      '&valueRenderOption=FORMATTED_VALUE',
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to read users from Sheet1: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final values = data['values'] as List<dynamic>? ?? [];

    // Skip header row
    for (final rawRow in values.skip(1)) {
      final row = rawRow as List<dynamic>;

      final sheetPassword = row.isNotEmpty ? row[0].toString().trim() : '';
      final sheetUsername = row.length > 1 ? row[1].toString().trim() : '';
      final sheetName = row.length > 2 ? row[2].toString().trim() : '';

      if (sheetUsername == username.trim() &&
          sheetPassword == password.trim()) {
        return sheetName;
      }
    }

    return null; // invalid username or password
  }

  Future<List<String>> _getSheetNamesOfCurrentYearWhereC5ContainsName({
    required String name,
  }) async {
    final searchedName = name.trim();

    if (searchedName.isEmpty) {
      return [];
    }

    final headers = await _getAuthHeaders();

    final sheetNames = await getSheetNames();

    final matchingSheets = <String>[];

    for (final sheetName in sheetNames) {
      final escapedSheetName = sheetName.replaceAll("'", "''");

      final range = Uri.encodeComponent("'$escapedSheetName'!C5");

      final uri = Uri.parse(
        'https://sheets.googleapis.com/v4/spreadsheets/${Constants.spreadsheetId}/values/$range'
        '?valueRenderOption=FORMATTED_VALUE',
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          'Failed to read C5 from sheet $sheetName: ${response.body}',
        );
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final values = body['values'] as List<dynamic>? ?? [];

      if (values.isEmpty || values.first.isEmpty) {
        continue;
      }

      final cellValue = values.first.first.toString().trim();

      if (cellValue.contains(searchedName) &&
          sheetName.contains(DateTime.now().year.toString())) {
        matchingSheets.add(sheetName);
      }
    }

    return matchingSheets;
  }

  String _sheetRange(String sheetName, String range) {
    final safeSheetName = sheetName.replaceAll("'", "''");
    return "'$safeSheetName'!$range";
  }
}
