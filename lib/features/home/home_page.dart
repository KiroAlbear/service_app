import 'package:flutter/material.dart';
import 'package:service/core/services/secure_storage/secure_storage_manager.dart';

import '../../core/services/secure_storage/secure_storage_keys.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f8fe),
      appBar: AppBar(backgroundColor: Color(0xfff3f8fe)),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: SecureStorageManager.getInstance().getValue(
                SecureStorageKeys.servantName,
              ),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    " اهلا ${snapshot.data.toString()} ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            ListItem(title: "test", category: "category", id: "id", total: 205),
          ],
        ),
      ),
    );
  }
}
