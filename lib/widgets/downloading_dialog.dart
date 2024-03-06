import 'package:audio_player_app/download_audio.dart';
import 'package:flutter/material.dart';

class DownloadingDialog extends StatefulWidget {
  const DownloadingDialog({
    super.key,
  });

  @override
  State<DownloadingDialog> createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  double progress = 0.0;
  @override
  void initState() {
    startDownload();
    super.initState();
  }

  void startDownload(){
    FileDownload().startDownloading(context, (recivedBytes, totalBytes){
      setState(() {
        progress = recivedBytes/totalBytes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String downloadingProgress = (progress * 100).toInt().toString();
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              "Downloading",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey,
            color: Colors.green,
            minHeight: 10,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text("$downloadingProgress %"))
        ],
      ),
    );
  }
}
