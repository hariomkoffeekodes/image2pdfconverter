import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/foundation.dart';
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
    setState(() {
      downloading == false;
    });
    try {
      var dir = await getApplicationDocumentsDirectory();


      await dio.download(imgUrl, "${dir.path}/myimage.mp4",
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total");
            setState(() {
              downloading = true;
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });

      downloaddata = "${dir.path}/myimage.mp4";

      print(downloaddata.toString());



    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = true;
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

      body: downloading == false ?
      CircularProgressIndicator()
      :
      Column(
        children: [
          Center(
            child: Container(
              height: 100.0,
              width: 300.0,
              child: Card(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

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
          ),
          MaterialButton(
            child: Text("play video",),
              color: Colors.blue,
              onPressed: (){

              }
          ),
          // BetterPlayer.file(downloaddata),

          /*Image.file(File('${downloaddata}/myimage.jpg'),
            width: 500,
            height: 500,),*/


          Text('BOthi'),

        ],
      ),
    );
  }

}