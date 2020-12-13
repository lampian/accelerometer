import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  var rsaPrivateFilePathandName = path + '/rsa_private.pem';
  return File(rsaPrivateFilePathandName);
}

Future<String> writePrivateKey(String aKey) async {
  final file = await _localFile;
  return file.path.toString();
}

Future<String> getRsaFilePath(String aKey) async {
  return await writePrivateKey(aKey);
}
