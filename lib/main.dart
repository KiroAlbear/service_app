import 'package:flutter/material.dart';

import 'google_sheets_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final sheetsService = GoogleSheetsService();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    widget.sheetsService.init();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> saveData() async {
    await widget.sheetsService.appendRow(
      spreadsheetId: '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA',
      sheetName: 'test',
      row: ['Mostafa', 'Robotics', 95, DateTime.now().toIso8601String()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveData,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
