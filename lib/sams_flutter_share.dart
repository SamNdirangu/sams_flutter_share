import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

  /// title: The title of the share pop up
  /// mimetype: What type of file are you sharing
  /// AppPackage: To which specific app to do you want to share with
  /// launches the app directly ie 'com.whatsapp'
class SamsFlutterShare {
  static const MethodChannel _channel =
      const MethodChannel('sams_flutter_share');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // Share a text.
  static void shareText(
      String text,  //The text to share
      String mimeType, // The type of text your sharing  ie text/txt
      {
        String shareTitle = 'Share with', // The title that appears in the share pop up
        String appToShare = '' //The app you want to use to share with, if blank will pop up the share choose ie 'com.whatsapp'
      }
      
  ) {
    Map argsMap = <String, String>{
      'shareTitle': '$shareTitle',
      'text': '$text',
      'mimeType': '$mimeType',
      'appToShare': '$appToShare'
    };
    _channel.invokeMethod('shareText', argsMap);
  }

  //Share a file.
  static Future<void> shareFile(
    List<int> fileByte, //The byte format of the file see example on how to obtain
    String fileName, //The file name.
    String mimeType, // The type of text your sharing  ie text/txt image/png etc
    {
      String shareTitle = 'Share with', // The title that appears in the share pop up
      String appToShare = '', //The app you want to use to share with, if blank will pop up the share choose ie 'com.whatsapp'
      String captionText = '' //Caption text to share with.
    }) async {
    Map argsMap = <String, String>{
      'shareTitle': '$shareTitle',
      'fileName': '$fileName',
      'mimeType': '$mimeType',
      'captionText': '$captionText',
      'appToShare': '$appToShare'
    };

    //Get the temp directory path and create a new file
    final tempDir = await getTemporaryDirectory();
    final file = await new File('${tempDir.path}/$fileName').create();
    await file.writeAsBytes(fileByte);

    _channel.invokeMethod('shareFile', argsMap);
  }

  //Sends multiple files to other apps.
  static Future<void> shareMultipleFiles(
    Map<String, List<int>> filesBytes, //A list of file  byte format of the file see example on how to obtain
    String mimeType, // The type of text your sharing  ie text/txt image/png etc
    {
      String shareTitle = 'Share with', // The title that appears in the share pop up
      String appToShare = '', //The app you want to use to share with, if blank will pop up the share choose ie 'com.whatsapp'
      String captionText = '' //Caption text to share with.
    }) async {
    Map argsMap = <String, dynamic>{
      'shareTitle': '$shareTitle',
      'filesBytes': filesBytes.entries.toList().map((x) => x.key).toList(),
      'mimeType': mimeType,
      'captionText': '$captionText',
      'appToShare': '$appToShare'
    };

    final tempDir = await getTemporaryDirectory();

    for (var entry in filesBytes.entries) {
      final file = await new File('${tempDir.path}/${entry.key}').create();
      await file.writeAsBytes(entry.value);
    }
    _channel.invokeMethod('shareMultipleFiles', argsMap);
  }
}
