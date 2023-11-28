import 'package:flutter/material.dart';
import 'package:jsonfile/pages/home_body.dart';
import 'package:jsonfile/pages/add_prop.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
      )),
      home: Scaffold(
        appBar: AppBar(
          title: Text('JSON Files'),
        ),
        body: buildPage(),
        bottomNavigationBar: NavigationBar(
          destinations: [
            NavigationDestination(icon: Icon(Icons.short_text), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.settings), label: 'Add Prop'),
          ],
          selectedIndex: currentPage,
          onDestinationSelected: (int page) {
            setState(() {
              currentPage = page;
            });
          },
        ),
      ),
    );
  }

  Widget buildPage() {
    switch (currentPage) {
      case 0:
        return HomeBody(); //display contents of json file
      case 1:
        return AddProp(); //add a property to the json file
      default:
        throw Exception('invalid page');
    }
  }
}
