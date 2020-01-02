import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sams_flutter_share/sams_flutter_share.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  //Launch share pop up and choose an app to share
  shareText() => SamsFlutterShare.shareText(
      'I am a Text, Share Me', //Text to share
      'text/*', //Mime type or type of data to share
      shareTitle: 'Share with' //Title of the share pop up modal
      );

  //Directly share to Whatsapp
  shareTextToWhatsapp() => SamsFlutterShare.shareText(
        'I am a Text, Share Me', 'text/*',
        appToShare:
            'com.whatsapp', //replace with  the package name of your desired app
      );

  shareImage() async {
    final ByteData fileBytes = await rootBundle.load('images/bat1.jpg');
    await SamsFlutterShare.shareFile(
        fileBytes.buffer
            .asUint8List(), //Reads file as byte list rootbundle returns bytedata
        'bat1.jpg', //File name
        'image/jpg', //Meme type
        captionText: 'Cool Share');

    //Share a file within the directory.
    //
    // final fileBytes = File(filePath).readAsBytesSync();
    // await SamsFlutterShare.shareFile(fileBytes, basename(filePath), memeType,
    //   shareTitle: 'Share with',
    //  );
    //
  }

  shareMultipleImages() async {
    final file1 =
        (await rootBundle.load('images/bat1.jpg')).buffer.asUint8List();
    final file2 =
        (await rootBundle.load('images/bat2.jpg')).buffer.asUint8List();
    final file3 =
        (await rootBundle.load('images/bat3.jpg')).buffer.asUint8List();

    await SamsFlutterShare.shareMultipleFiles(
      {
        'bat1.jpg': file1,
        'bat2.jpg': file2,
        'bat3.jpg': file3,
      },
      'image/jpg', //if file are of different types replace with */*
      captionText: 'Multiple images',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("Sam's Flutter Share Example"),
      ),
      body: Center(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            SizedBox(height: 50),
            Center(child: Text('I am a Text, Share Me')),
            Center(
              child: RaisedButton.icon(
                icon: Icon(Icons.share),
                label: Text('Share the text Above'),
                onPressed: () => shareText(),
              ),
            ),
            Divider(),
            Center(child: Text('I am a Text, Share Me to Whatsapp')),
            Center(
              child: RaisedButton.icon(
                icon: Icon(Icons.share),
                label: Text('Share the text Above to Whatsapp'),
                onPressed: () => shareTextToWhatsapp(),
              ),
            ),
            Divider(),
            Center(
                child: Image.asset(
              'images/bat1.jpg',
              height: 150,
            )),
            Center(
              child: RaisedButton.icon(
                icon: Icon(Icons.share),
                label: Text('Share the image above'),
                onPressed: () => shareImage(),
              ),
            ),
            Divider(),
            Container(
              width: 200,
              child: Row(
                children: <Widget>[
                  Image.asset('images/bat1.jpg',height: 80),
                  Image.asset('images/bat2.jpg',height: 80),
                  Image.asset('images/bat3.jpg',height: 80)
                ],
              ),
            ),
            Center(
              child: RaisedButton.icon(
                icon: Icon(Icons.share),
                label: Text('Share the images above'),
                onPressed: () => shareMultipleImages(),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
