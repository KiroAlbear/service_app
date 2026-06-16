import 'package:flutter/material.dart';
import 'package:service/constants.dart';
import 'package:service/home/home_page.dart';

import 'models/SheetFullName.dart';
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
    // await widget.sheetsService.writeRowInsideTable(
    //   spreadsheetId: '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA',
    //   sheetName: 'test',
    //   row: ['Mostafa22', 'Robotics', "95", "95", "95", "95"],
    // );

    // await widget.sheetsService.incrementColumnByExactName(
    //   spreadsheetId: '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA',
    //   sheetName: 'test',
    //   firstName: "ابانوب",
    //   fatherName: 'عصمت',
    //   grandfatherName: "جندي",
    //   targetColumnLe tter: Constants
    //       .monthCountColumns[DateTime.now().month.toString()]!
    //       .morningServiceColumn,
    // );

    // List<SheetFullName> names = await widget.sheetsService.getFullNamesInTable(
    //   spreadsheetId: '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA',
    //   sheetName: 'test',
    // );

    //
    // final sheetNames = await widget.sheetsService.getSheetNames(
    //   spreadsheetId: '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA',
    // );

    final servantName = await widget.sheetsService.getNameByUsernameAndPassword(
      spreadsheetId: '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA',
      username: "Rom",
      password: "Rom123",
    );

    final sheetName = await widget.sheetsService
        .getSheetNamesOfCurrentYearWhereC5ContainsName(
          spreadsheetId: '1vQiQQejzknabozeEeZRy0AsHEP3j_OYqfU8QfdnUmJA',
          name: servantName ?? "",
        );
    // TODO

    print("Hello world");
  }

  @override
  Widget build(BuildContext context) {
    return HomePage();
    // return Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    //     title: Text(widget.title),
    //   ),
    //   body: Center(
    //     child: Column(
    //       mainAxisAlignment: .center,
    //       children: [
    //         const Text('You have pushed the button this many times:'),
    //         Text(
    //           '$_counter',
    //           style: Theme.of(context).textTheme.headlineMedium,
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: saveData,
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ),
    // );
  }
}
