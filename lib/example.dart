import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';


class Example extends StatefulWidget {
  @override
  ExampleState createState() {
    return new ExampleState();
  }
}

class ExampleState extends State<Example> {

  final imgUrl = "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
  bool downloading = false;
  var progressString = "";

  var downloaddata = "";

  @override
  void initState() {
    super.initState();

    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();

    try {
      var dir = await getApplicationDocumentsDirectory();

      print("Hariom)");
      downloaddata = dir.path;
      print(downloaddata.toString());

      await dio.download(imgUrl, "${dir.path}/myimage.mp4",
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total");
            setState(() {
              downloading = true;
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });


    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar"),
      ),
      body: Column(
        children: [
          Center(
            child: downloading
                ? Container(
              height: 420.0,
              width: 300.0,
              child: Card(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),

                    /*Image.file(File('/data/user/0/com.koffeekodes.image2pdfconverter/cache/file_picker/PXL_20230315_191356483.jpg'),
                    width: 50,
                    height: 50,),*/

                    SizedBox(
                      height: 20.0,
                    ),

                    Text(
                      "Downloading File: $progressString",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
                : Text("No Data"),
          ),
          /*Image.file(File('${downloaddata}/myimage.mp4'),
            width: 500,
            height: 500,),*/
          Text("${downloaddata}/myimage.mp4"),
        ],
      ),
    );
  }
}