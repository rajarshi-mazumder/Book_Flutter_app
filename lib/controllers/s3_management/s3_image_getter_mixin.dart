import 'package:book_frontend/controllers/s3_management/s3_management.dart';
import 'package:flutter/material.dart';

mixin S3ImageGetterMixin {
  Future<String?> fetchS3Object({
    required String imgPath,
    String? preSignedUrlStr,
    required String savePath,
  }) async {
    bool needNewPreSignedUrl = true;

    if (preSignedUrlStr != null) {
      Uri preSignedUrl = Uri.parse(preSignedUrlStr);
      String? expiresStr = preSignedUrl.queryParameters['Expires'];
      if (expiresStr != null) {
        int expiresTimestamp = int.parse(expiresStr!);
        DateTime expirationTime = DateTime.fromMillisecondsSinceEpoch(
            expiresTimestamp * 1000,
            isUtc: true);

        // Get the current time in UTC
        DateTime currentTime = DateTime.now().toUtc();

        // Check if the current time is before the expiration time
        if (currentTime.isBefore(expirationTime)) {
          needNewPreSignedUrl = false;
        }
      }
    }
    if (needNewPreSignedUrl == true) {
      preSignedUrlStr = await getPreSignedUrl(fileName: imgPath);
    }
    if (preSignedUrlStr != null) {
      String? downloadedPath = await downloadFile(
          localFilePath: savePath, preSignedUrl: preSignedUrlStr);
      return downloadedPath;
    } else {
      print("Error downloading image- PResigned URL is $preSignedUrlStr");
      return null;
    }
  }
}
