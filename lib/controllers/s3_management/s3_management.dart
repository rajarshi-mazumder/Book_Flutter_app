import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String?> downloadFile(
    {required String localFilePath, required String preSignedUrl}) async {
  try {
    // Create an instance of Dio.
    final dio = Dio();

    // Start the download.
    final response = await dio.download(preSignedUrl, localFilePath,
        onReceiveProgress: (received, total) {
      if (total != -1) {
        print('${(received / total * 100).toStringAsFixed(0)}%');
      }
    });

    // Check if the download was successful.
    if (response.statusCode == 200) {
      print('File downloaded successfully to $localFilePath');
      return localFilePath;
    } else {
      print('Failed to download file');
    }
  } catch (e) {
    print('Error downloading file: $e');
  }
  return null;
}

Future<String?> getPreSignedUrl({required String fileName}) async {
  const baseurl = "http://43.206.213.88:5000";
  Map<String, dynamic> params = {"object_name": fileName};

  final url = Uri.parse(baseurl)
      .replace(path: '/get_pre_signed_url', queryParameters: params);

  try {
    final response = await http
        .get(url)
        .timeout(const Duration(seconds: 10)); // Set a timeout

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["signed_url"];
    } else {
      print("Failed to get pre-signed URL: ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error occurred while fetching pre-signed URL: $e");
    return null;
  }
}
