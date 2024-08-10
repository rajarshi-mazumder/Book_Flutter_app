import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<void> downloadFile(String url, {String fileName = 'testObj.png'}) async {
  try {
    String? preSignedUrl = await getPreSignedUrl(fileName: fileName);
    if (preSignedUrl == null) {
      return;
    }

    final directory = await getApplicationDocumentsDirectory();

    // Create a full path to save the file.
    final filePath = '${directory.path}/$fileName';

    // Create an instance of Dio.
    final dio = Dio();

    // Start the download.
    final response = await dio.download(preSignedUrl, filePath,
        onReceiveProgress: (received, total) {
      if (total != -1) {
        print('${(received / total * 100).toStringAsFixed(0)}%');
      }
    });

    // Check if the download was successful.
    if (response.statusCode == 200) {
      print('File downloaded successfully to $filePath');
    } else {
      print('Failed to download file');
    }
  } catch (e) {
    print('Error downloading file: $e');
  }
}

Future<String?> getPreSignedUrl({required String fileName}) async {
  const baseurl = "http://10.0.2.2:5000";

  final url = Uri.parse("$baseurl/get_presigned_url/$fileName");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("RESPONSE ${response.body}");

    return data["signed_url"];
    // return {"preSignedUrl": data};
  }
  return null;
}
