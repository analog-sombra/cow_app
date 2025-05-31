import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';

String longText(String text, int length) {
  if (text.length <= length) {
    return text;
  } else {
    return "${text.substring(0, length)} ...";
  }
}

Future<XFile?> compressAndGetImageFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    minHeight: 500,
    minWidth: 500,
    quality: 88,
  );

  // print(file.lengthSync());
  // print(result.lengthSync());

  return result;
}
