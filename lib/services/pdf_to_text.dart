import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PdfToText extends GetxService {
  final _serviceUrl =
      Uri.parse("https://mock-cv-parser-3.herokuapp.com/api/extract_pdf/");

  Future<String> extractTextFromPdf(
    Stream<List<int>> bytesStream,
    int size,
  ) async {
    final request = http.MultipartRequest('POST', _serviceUrl);
    request.files.add(
      http.MultipartFile(
        'pdf_file',
        bytesStream,
        size,
        filename: 'file.pdf',
      ),
    );
    final response = await request.send();

    if (response.statusCode != 200) {
      throw response;
    }

    return jsonDecode(await response.stream.bytesToString())["body"];
  }
}
