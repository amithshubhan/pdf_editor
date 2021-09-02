import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_viewer/pdf_editor.dart';
import './constants.dart';
import './modifier_page.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sy;
import 'package:file_picker/file_picker.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final picker = ImagePicker();
  final pdf = pw.Document();
  List<File> _image = [];
  int insertionPage = -1;
  int maininsertion = 0;
  var new_pdf = new sy.PdfDocument();
  var path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("image to pdf"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_album),
              onPressed: () {
                getimagefromgalary(maininsertion);
              }),
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                createPDF();
                savePDF();
              }),
          PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map(
                (String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                },
              ).toList();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: getImageFromCamera,
      ),
      body: _image != null
          ? ListView.builder(
              itemCount: _image.length,
              itemBuilder: (context, index) => Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    padding: EdgeInsets.all(5),
                    height: 600,
                    width: double.infinity,
                    margin: EdgeInsets.all(4),
                    child: Image.file(
                      _image[index],
                      fit: BoxFit.cover,
                    )),
              ),
            )
          : Container(),
    );
  }

// ListView.builder(
//               itemCount: _image.length,
//               itemBuilder: (context, index) => Card(
//                 elevation: 10,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(20))),
//                     padding: EdgeInsets.all(5),
//                     height: 600,
//                     width: double.infinity,
//                     margin: EdgeInsets.all(4),
//                     child: Image.file(
//                       _image[index],
//                       fit: BoxFit.cover,
//                     )),
//               ),
//             )

  Future<void> getDocument() async {
    try {
      final file = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: false);
      if (file != null) {
        final f = File(file.files.first.path);
        path = file.files.first.path;
        print(path);
        // OpenFile.open('$path');
        new_pdf = sy.PdfDocument(inputBytes: f.readAsBytesSync());
        int pageCount = new_pdf.pages.count;
        // for (int i = 0; i < pageCount; i++) {
        //   sy.PdfPage pp = new_pdf.pages[i];

        // }
        // setState(() {
        //   _image.length = pageCount;
        // });
        // print(_image.length);
        // _image.pageSettings.setMargins(0);
      }
    } catch (e) {}
  }

  showTheImages() {
    setState(() {
      ListView.builder(
        itemCount: _image.length,
        itemBuilder: (context, index) => Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.all(5),
              height: 600,
              width: double.infinity,
              margin: EdgeInsets.all(4),
              child: Image.file(
                _image[index],
                fit: BoxFit.cover,
              )),
        ),
      );
    });
  }

  Future<String> createAlertDialog(BuildContext context) {
    TextEditingController myController = new TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Page after which insert"),
              content: TextField(
                controller: myController,
              ),
              actions: <Widget>[
                MaterialButton(
                    elevation: 5.0,
                    child: Text('Submit'),
                    onPressed: () {
                      Navigator.of(context).pop(myController.text.toString());
                      // return myController;
                    })
              ]);
        });
  }

  void choiceAction(String choice) async {
    if (choice == Constants.add) {
      createAlertDialog(context).then((onValue) {
        insertionPage = int.parse(onValue);
        print(insertionPage);
        getimagefromgalary(insertionPage);
        insertionPage = -1;
      });
    } else if (choice == Constants.modify) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => modifierpage(_image)));
      // modifierpage(_image);
    } else if (choice == Constants.open) {
      await getDocument();
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => pdf_editor(path)));
    }
  }

  getimagefromgalary(int insertion) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image.insert(insertion, File(pickedFile.path));
        maininsertion++;
        print('${maininsertion} and ${insertionPage} ');
      } else {
        print('No image selected');
      }
    });
  }

  getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image.add(File(pickedFile.path));
      } else {
        print('No image selected');
      }
    });
  }
  //  Future getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.camera);

  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  createPDF() async {
    for (var img in _image) {
      final image = pw.MemoryImage(img.readAsBytesSync());

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context contex) {
            return pw.Center(
                child: pw.Image(image,
                    width: PdfPageFormat.a4.width,
                    height: PdfPageFormat.a4.height));
          }));
    }
  }

  savePDF() async {
    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir.path}/filename.pdf');
      await file.writeAsBytes(await pdf.save());
      showPrintedMessage('success', 'saved to documents');
    } catch (e) {
      showPrintedMessage('error', e.toString());
    }
  }

  showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: Duration(seconds: 3),
      icon: Icon(
        Icons.info,
        color: Colors.blue,
      ),
    )..show(context);
  }
}
