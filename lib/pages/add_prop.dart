import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsonfile/services/file_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

//https://api.dart.dev/stable/3.2.1/dart-io/dart-io-library.html
//https://api.dart.dev/stable/3.2.1/dart-io/File-class.html

class AddProp extends StatefulWidget {
  const AddProp({super.key});

  @override
  State<AddProp> createState() => _AddPropState();
}

class _AddPropState extends State<AddProp> {
  FileHelper fileHelper = FileHelper();
  Map<String, dynamic> props = {};
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  Future<void> writeMapToJson(Map<String, dynamic> mapData) async {
    //add the new Map values to props
    Map<String, dynamic> _data = props;
    _data.addAll(mapData);
    // Convert Map to JSON string
    String jsonString = jsonEncode(_data);
    await fileHelper.writeData('data.json', jsonString);
    if (kDebugMode) {
      print('Map data written to file');
    }
    nameController.text = '';
    valueController.text = '';
    setState(() {
      props = _data;
    });
  }

  void getFileContents() async {
    FileHelper fileHelper = FileHelper();
    fileHelper.readContents('data.json').then((Map<String, dynamic> details) {
      setState(() {
        props = details['data'];
        // json = details['json'];
      });
    }).onError((error, stackTrace) {
      setState(() {
        props = {};
      });
    });
  }

  @override
  void initState() {
    getFileContents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Add a Property', style: Theme.of(context).textTheme.displayMedium),
            TextField(
              autofocus: true,
              controller: nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.abc),
                hintText: 'Property name',
                label: Text('Property name'),
              ),
            ),
            TextField(
              controller: valueController,
              decoration: InputDecoration(
                hintText: 'Property value',
                prefixIcon: Icon(Icons.settings),
                label: Text('Property value'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                //add to props and save in file
                Map<String, dynamic> data = {nameController.text: valueController.text};
                writeMapToJson(data);
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.save),
                  Text('Save'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Divider(),
            ),
            Text('Existing Props', style: Theme.of(context).textTheme.displayMedium),
            ...showExistingProps(),
          ],
        ),
      ),
    );
  }

  List<Widget> showExistingProps() {
    //read the props and create an array
    List<Widget> items = [];
    props.forEach((key, value) {
      items.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Text(key, style: Theme.of(context).textTheme.labelLarge),
          Text(" : "),
          Text(value.toString(), style: Theme.of(context).textTheme.labelLarge),
        ]),
      ));
    });
    return items;
  }
}
