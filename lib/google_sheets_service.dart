import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleSheetsService {
  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/spreadsheets',
  ];

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  GoogleSignInAccount? _currentUser;

  Future<void> init() async {
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
  }

  Future<GoogleSignInAccount> signIn() async {
    _currentUser ??= await _googleSignIn.authenticate();
    return _currentUser!;
  }

  Future<Map<String, String>> _getAuthHeaders() async {
    final user = _currentUser ?? await signIn();

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

  Future<int> _getSheetId({
    required String spreadsheetId,
    required String sheetName,
    required Map<String, String> headers,
  }) async {
    final uri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId'
      '?fields=sheets.properties(sheetId,title)',
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to get sheet metadata: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final sheets = data['sheets'] as List<dynamic>;

    final sheet = sheets.firstWhere(
      (s) => s['properties']['title'] == sheetName,
      orElse: () => throw Exception('Sheet "$sheetName" not found.'),
    );

    return sheet['properties']['sheetId'] as int;
  }

  Future<int> _getNextDataRow({
    required String spreadsheetId,
    required String sheetName,
    required Map<String, String> headers,
  }) async {
    final range = Uri.encodeComponent(_a1(sheetName, 'A:Z'));

    final uri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$range',
    );

    final response = await http.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to read table rows: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final values = data['values'] as List<dynamic>? ?? [];

    final lastNonEmptyIndex = values.lastIndexWhere((r) {
      final cells = r as List<dynamic>;
      return cells.any((c) => c != null && c.toString().trim().isNotEmpty);
    });

    // If sheet is empty, write to row 1.
    // Otherwise write after the last non-empty row.
    return lastNonEmptyIndex == -1 ? 1 : lastNonEmptyIndex + 2;
  }

  String _a1(String sheetName, String range) {
    final escapedSheetName = sheetName.replaceAll("'", "''");
    return "'$escapedSheetName'!$range";
  }

  Future<void> appendRow({
    required String spreadsheetId,
    required String sheetName,
    required List<Object?> row,

    /// Use this if you want to insert before a footer / total row.
    /// Example: insertBeforeRow: 20 inserts the new row at row 20.
    int? insertBeforeRow,

    /// A:Z = 26 columns. Change this if your table is wider/narrower.
    int columnCount = 26,
  }) async {
    final headers = await _getAuthHeaders();

    final sheetId = await _getSheetId(
      spreadsheetId: spreadsheetId,
      sheetName: sheetName,
      headers: headers,
    );

    final targetRow =
        insertBeforeRow ??
        await _getNextDataRow(
          spreadsheetId: spreadsheetId,
          sheetName: sheetName,
          headers: headers,
        );

    final requests = <Map<String, dynamic>>[
      {
        'insertDimension': {
          'range': {
            'sheetId': sheetId,
            'dimension': 'ROWS',
            'startIndex': targetRow - 1, // zero-based
            'endIndex': targetRow,
          },
          'inheritFromBefore': targetRow > 1,
        },
      },
    ];

    // Extra safety: copy the full style/borders from the row above.
    if (targetRow > 1) {
      requests.add({
        'copyPaste': {
          'source': {
            'sheetId': sheetId,
            'startRowIndex': targetRow - 2,
            'endRowIndex': targetRow - 1,
            'startColumnIndex': 0,
            'endColumnIndex': columnCount,
          },
          'destination': {
            'sheetId': sheetId,
            'startRowIndex': targetRow - 1,
            'endRowIndex': targetRow,
            'startColumnIndex': 0,
            'endColumnIndex': columnCount,
          },
          'pasteType': 'PASTE_FORMAT',
          'pasteOrientation': 'NORMAL',
        },
      });
    }

    final batchUri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId:batchUpdate',
    );

    final batchResponse = await http.post(
      batchUri,
      headers: {...headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'requests': requests}),
    );

    if (batchResponse.statusCode < 200 || batchResponse.statusCode >= 300) {
      throw Exception('Failed to insert styled row: ${batchResponse.body}');
    }

    final writeRange = Uri.encodeComponent(_a1(sheetName, 'A$targetRow'));

    final writeUri = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$spreadsheetId/values/$writeRange'
      '?valueInputOption=USER_ENTERED',
    );

    final writeResponse = await http.put(
      writeUri,
      headers: {...headers, 'Content-Type': 'application/json'},
      body: jsonEncode({
        'majorDimension': 'ROWS',
        'values': [row],
      }),
    );

    if (writeResponse.statusCode < 200 || writeResponse.statusCode >= 300) {
      throw Exception('Failed to write row values: ${writeResponse.body}');
    }
  }
}
