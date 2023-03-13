import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewer extends StatefulWidget {
  const PDFViewer({super.key, required this.fileUrl});
  final String fileUrl;
  static const String routePath = '/pdfViewer';

  @override
  State<PDFViewer> createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  Uint8List? _documentBytes;

  @override
  void initState() {
    // TODO: implement initState
    getPdfBytes();

    super.initState();
  }

  getPdfBytes() async {
    HttpClient client = HttpClient();
    final Uri url = Uri.base.resolve(widget.fileUrl);
    final HttpClientRequest request = await client.getUrl(url);
    final HttpClientResponse response = await request.close();
    _documentBytes = await consolidateHttpClientResponseBytes(response);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: _documentBytes == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SfPdfViewer.memory(_documentBytes!),
      ),
    );
  }
}
