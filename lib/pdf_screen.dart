import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';


class PdfScreen extends StatefulWidget {
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  String pdfFile = '';
  var pdf = pw.Document();

  List<Uint8List> imagesUint8list = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("hhhh"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    _pickFiles();
                  },
                  child: Text('select images')
              ),
            ],
          ),
        ),
      ),
    );
  }

  getImageBytes(var assetImage) async {
    //final ByteData bytes = await rootBundle.load(memory);
    print(""+assetImage);
    File imgfile = File(assetImage);
    final Uint8List img_byte = await imgfile.readAsBytes();
    imagesUint8list.add(img_byte);
    print(imagesUint8list.length);
  }

  createPdfFile(List assetImage) async {
    //convert each image to Uint8List
    print("as");
    for (var image in assetImage) {
      await getImageBytes(image);
    }
    //create a list of images
    final List<pw.Widget> pdfImages = imagesUint8list.map((image) {
      return pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: pw.Container(
            alignment: pw.Alignment.center,
            child: pw.Image(
                pw.MemoryImage(
                  image,
                ),
                height: 600,
                fit: pw.BoxFit.fill)
          )
      );
    }).toList();

    //create PDF
    pdf.addPage(pw.MultiPage(
        margin: pw.EdgeInsets.all(10),
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        pageFormat: PdfPageFormat.a4,
        maxPages: 20,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.max,
                children: pdfImages
            ),
          ];
        }));

   await savePdfFile();
  }


  savePdfFile() async {

    Directory documentDirectory = await getTemporaryDirectory();
    String documentPath = documentDirectory.path;
    String id = DateTime.now().toString();


    File file = await File("$documentPath/$id.pdf");
    // print(file.toString());
    file.writeAsBytesSync(await pdf.save());


    setState(() {
      pdfFile = file.path;
      pdf = pw.Document();
      print("hariom");
      print(file.path.toString());
      OpenFilex.open(file.path.toString());
    });

  }

  bool getCamera = false;
  bool getGallery = false;
  bool _multiPick = true;
  bool _isLoading = true;
  final FileType _pickingType = FileType.image;
  List<PlatformFile>? _paths = [];
  List<PlatformFile>? tempList = [];
  String? _directoryPath;
  String? _extension;


  List listOfImagePath = [];

  void _pickFiles() async {
    setState(() {
      getGallery = true;
      getCamera = false;
      listOfImagePath.clear();
      _paths = [];
    });
    try {
      _directoryPath = null;
      tempList = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: _multiPick,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;

    _isLoading = false;

    _paths!.addAll(tempList!);
    print(_paths![0].path.toString());
    for(int i=0;i<_paths!.length;i++){
      listOfImagePath.add(_paths![i].path.toString());
    }

   print("base list ${listOfImagePath}");

    await createPdfFile(listOfImagePath);


  }

  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }


}
