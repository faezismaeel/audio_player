import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileDownload{
  Dio dio = Dio();
  bool isSuccess = false;

  void startDownloading(BuildContext context,final Function okCallBack) async {
    String fileName = 'better-day-186374.mp3';
    String url = "https://cdn.pixabay.com/download/audio/2024/01/16/audio_e2b992254f.mp3?filename=better-day-186374.mp3";
    String path = await _getFilePath(fileName);

  try{
    await dio.download(
      url,
      path,
      onReceiveProgress: (recivedBytes, totalBytes){
        okCallBack(recivedBytes, totalBytes);
      },
      deleteOnError: true,
    ).then((value){
      isSuccess = true;
    });
  } catch (e) {
      print("Exception$e");
    }
  }
  
 Future<String> _getFilePath(String fileName) async {
  Directory? dir ;
  try{
    dir = Directory("/storage/emulated/0/Download/");
    if(!await dir.exists()) dir = (await getExternalStorageDirectory())! ;
  }
  catch(error){
    print('Cannot get download folder path $error');
  }
  return "${dir?.path}$fileName";
 }
 

}