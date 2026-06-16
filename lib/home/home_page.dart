import 'package:flutter/material.dart';
import 'package:service/home/list_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListItem(title: "test", category: "category", id: "id", total: 205),
    );
  }
}
