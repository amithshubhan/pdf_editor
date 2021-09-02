import 'package:flutter/material.dart';
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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class pdf_editor extends StatefulWidget {
  String path;
  pdf_editor(String path) {
    this.path = path;
  }
  @override
  _pdf_editorState createState() => _pdf_editorState();
}

class _pdf_editorState extends State<pdf_editor> {
  var new_pdf = new sy.PdfDocument();
  List<File> _image;
  // String path = widget.path;

  _pdf_editorState() {
    // getDocument();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pdf_editor"),
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: () {}),
            IconButton(icon: Icon(Icons.delete), onPressed: () {}),
          ],
        ),
        body: widget.path != null
            ? Container(child: SfPdfViewer.file(File(widget.path)))
            : Container());
  }
}
