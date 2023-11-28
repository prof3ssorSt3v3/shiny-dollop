import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jsonfile/services/file_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  Map<String, dynamic> data = {};
  String json = '';

  void getFileContents() async {
    FileHelper fileHelper = FileHelper();
    fileHelper.readContents('data.json').then((Map<String, dynamic> details) {
      setState(() {
        data = details['data'];
        json = details['json'];
      });
    }).onError((error, stackTrace) {
      setState(() {
        data = {};
        json = 'No file contents.';
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
    return Center(
      child: Column(
        children: [
          Text('File Contents', style: Theme.of(context).textTheme.displayMedium),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(json, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
