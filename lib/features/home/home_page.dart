import 'package:flutter/material.dart';
import 'package:service/core/routes/routes.dart';
import 'package:service/core/services/google_sheets_service.dart';
import 'package:service/core/services/secure_storage/secure_storage_manager.dart';

import '../../core/services/secure_storage/secure_storage_keys.dart';
import '../../core/services/secure_storage/secure_storage_values.dart';
import '../../core/widgets/verse_widget.dart';
import 'list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _logOut() async {
    await GoogleSheetsService.getInstance().signOut();
    await SecureStorageManager.getInstance().setValue(
      SecureStorageKeys.isLoggedIn,
      SecureStorageValues.falseValue,
    );
    await SecureStorageManager.getInstance().deleteValue(
      SecureStorageKeys.sheetName,
    );
    await SecureStorageManager.getInstance().deleteValue(
      SecureStorageKeys.servantName,
    );

    if (!mounted) {
      return;
    }

    Routes.navigateToScreen(
      Routes.loginScreen,
      NavigationType.goNamed,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f8fe),
      appBar: AppBar(backgroundColor: Color(0xfff3f8fe)),
      drawer: Drawer(
        backgroundColor: Color(0xfff3f8fe),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.logout_rounded),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: _logOut,
              ),
            ],
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: SecureStorageManager.getInstance().getValue(
                  SecureStorageKeys.servantName,
                ),
                builder: (context, snapshot) {
                  return Text(
                    " اهلا ${snapshot.data.toString()} ",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  );
                },
              ),
              SizedBox(height: 10),
              VerseWidget(
                verse:
                    '"أَيْضًا إِذَا سِرْتُ فِي وَادِي ظِلِّ الْمَوْتِ لَا أَخَافُ شَرًّا، لأَنَّكَ أَنْتَ مَعِي. عَصَاكَ وَعُكَّازُكَ هُمَا يُعَزِّيَانِنِي."',
                verseLocation: 'المزامير 23: 4',
              ),
              SizedBox(height: 20),
              Text(
                "قائمة المخدومين",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 18,
                  itemBuilder: (context, index) {
                    return ListItem(
                      title: "test",
                      category: "category",
                      id: "id",
                      total: 205,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
