import 'package:flutter/material.dart';
import 'package:image2pdfconverter/offline_downloader_files.dart';
import 'package:image2pdfconverter/pdf_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PdfScreen(),
      // home:  Example(),
    );
  }
}

