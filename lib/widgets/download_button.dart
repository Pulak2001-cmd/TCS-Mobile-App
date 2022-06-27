/////////////////////////////////////
// WIDGET TO BUILD DOWNLOAD BUTTON //
/////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Widget buildDownloadButton(){
  return ElevatedButton(
    onPressed: () async{
      final pdf = pw.Document();
      final List headers = ['SNo.','Time (days)',' Reducing Sugar'];
      final data = [
        [1, 0, 0.001],
        [2, 10, 0.002],
        [3, 20, 0.0024],
      ];

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Table.fromTextArray(
                headers: headers,
                data: data); // Center
          }));
      final file = File("/storage/emulated/0/Download/results.pdf");
      await file.writeAsBytes(await pdf.save());

    },
    child: Row(
        mainAxisSize: MainAxisSize.min,
        children:[
          Icon(Icons.download),
          Text('Download results'),
        ]
    ),
  );
}