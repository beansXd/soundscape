import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> GetDowloads_Folder() async {

  var deviceInfoPlugin = await DeviceInfoPlugin();
  final deviceInfo = await deviceInfoPlugin.deviceInfo;
  var data= deviceInfo.data;
  var androidVersion =  data["version" ]["release"];

     int number;
  try {
     number = int.parse(androidVersion);

     if(number <= 12){
       await Permission.storage.request().isGranted;
     }else{

       Map<Permission, PermissionStatus> Permissions = await [
         Permission.photos,
         Permission.videos,
         Permission.audio,
         Permission.manageExternalStorage
       ].request();

     }
    print(number);
  } catch (e) {
    print("Error: $e"); // Output: Error: FormatException: Invalid radix-10 number
  }


  try {
    var store = await Permission.storage.request();
    store.isDenied;
    if (kDebugMode) {
      print(store);
    }
  } catch (x) {}
}

Future<Directory?> getDownloadsDirectory() async {
  await GetDowloads_Folder();
  if (Platform.isAndroid) {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      String newPath = "";
      List<String> folders = directory.path.split("/");
      for (int i = 1; i < folders.length; i++) {
        String folder = folders[i];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/Download";
      return Directory(newPath);
    }
  } else if (Platform.isIOS) {
    // On iOS, handle as needed.
  }
  return null;
}

Future<Map<String, String>> listMp3FilesInDownloads() async {
  Directory? downloadsDirectory = await getDownloadsDirectory();
  if (downloadsDirectory != null) {
    List<FileSystemEntity> files = downloadsDirectory.listSync();

    // Filter for only .mp3 files
    List<FileSystemEntity> mp3Files = files.where((file) {
      return file is File && file.path.endsWith('.mp3');
    }).toList();



    Map<String, String> songMap = {};
    for (int i = 0; i < mp3Files.length;) {


      String songNames = mp3Files[i]
          .path
          .split('/')
          .last
          .substring(0, mp3Files[i].path.split('/').last.length - 4);
      songMap[songNames] = mp3Files[i].path;

      i++;
    }
    
    return songMap;
  } else {
    if (kDebugMode) {
      print("Downloads directory not found.");
    }
    return {};
  }
}
