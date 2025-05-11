// upload_progress_dialog.dart

import 'package:flutter/material.dart';

class UploadProgressDialog extends StatefulWidget {
  final int totalImages;

  const UploadProgressDialog({Key? key, required this.totalImages}) : super(key: key);

  @override
  UploadProgressDialogState createState() => UploadProgressDialogState();
}

class UploadProgressDialogState extends State<UploadProgressDialog> {
  int uploadedImages = 0;
  String status = "Подготовка...";

  void incrementProgress(String message) {
    setState(() {
      uploadedImages += 1;
      status = message;
    });
  }

  double get progress => widget.totalImages == 0 ? 0 : uploadedImages / widget.totalImages;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Загрузка новости"),
      content: SizedBox(
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(status),
            SizedBox(height: 16),
            LinearProgressIndicator(value: progress),
            SizedBox(height: 8),
            Text("${uploadedImages}/${widget.totalImages} файлов загружено"),
          ],
        ),
      ),
    );
  }
}