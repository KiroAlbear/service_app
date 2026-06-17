import 'package:flutter/material.dart';

import 'list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f8fe),
      appBar: AppBar(backgroundColor: Color(0xfff3f8fe)),
      body: ListItem(title: "test", category: "category", id: "id", total: 205),
    );
  }
}
