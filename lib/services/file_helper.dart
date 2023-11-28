import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

class FileHelper {
  Future<Map<String, dynamic>> readContents(String filename) async {
    Directory dataDir = await getApplicationDocumentsDirectory();
    //find the app Documents directory
    //open the file filename inside Documents/data
    String path = '${dataDir.path}/data/${filename}';

    File file = File(path);
    bool doesExist = await file.exists();
    if (doesExist) {
      return file.readAsString().then((String contents) {
        Map<String, dynamic> data = jsonDecode(contents);
        //now the json and data props have values
        if (kDebugMode) {
          print(contents);
          print('file existed and read');
        }
        return {'json': contents, 'data': data};
      }).catchError((err) {
        if (kDebugMode) {
          print('failed to read file ${err}');
        }
        return {'json': '', 'data': {}};
        // throw Exception('Unable to read file.');
      });
    } else {
      file.create(recursive: true);
      print('created file');
      return {'json': '', 'data': {}};
    }
  }

  Future<void> writeData(String filename, String jsonString) async {
    Directory dataDir = await getApplicationDocumentsDirectory();
    final file = File('${dataDir.path}/data/${filename}');
    return file.exists().then((bool exists) async {
      if (exists) {
        try {
          // Write JSON string to the local file
          await file.writeAsString(jsonString);
          if (kDebugMode) {
            print('Map data written to file: ${file.path}');
          }
        } catch (err) {
          if (kDebugMode) {
            print('Error writing to file: $err');
          }
        }
      } else {
        //no file
        if (kDebugMode) {
          print('No such file: ${file.path}');
        }
      }
    });
  }
}
