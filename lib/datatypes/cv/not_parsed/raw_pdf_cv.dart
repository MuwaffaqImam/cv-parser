import 'package:cvparser_b21_01/datatypes/export.dart';
import 'package:cvparser_b21_01/services/i_extract.dart';
import 'package:cvparser_b21_01/services/pdf_to_text.dart';
import 'package:get/get.dart';

class RawPdfCV extends NotParsedCV {
  final textExtracter = Get.find<PdfToText>();
  final cvParser = Get.find<IExtract>();
  final Stream<List<int>> readStream;
  final int size;
  Future<ParsedCV>? future;
  ParsedCV? cached;
  bool failed = false;

  RawPdfCV({
    required filename,
    required this.readStream,
    required this.size,
  }) : super(filename);

  Future<ParsedCV> _parse() async {
    try {
      // extract text
      String text = await textExtracter.extractTextFromPdf(
        readStream, // will fail on the second call
        size,
      );

      // parse the text using iExtract API
      final res = ParsedCV(
        filename: filename,
        data: await cvParser.parseCV(text),
      );

      cached = res;
      return res;
    } catch (e) {
      failed = true;
      rethrow;
    }
  }

  @override
  bool isParseCached() {
    return future != null;
  }

  @override
  bool isParseCachedComplete() {
    return cached != null;
  }

  @override
  bool isParseCachedFailed() {
    return failed;
  }

  @override
  ParsedCV immediateParse() {
    return cached!;
  }

  @override
  Future<ParsedCV> parse() async {
    // check if it's already in process
    future ??= _parse();
    return await future!;
  }

  @override
  bool satisfies(RegExp query) {
    if (cached == null) return true;
    return cached!.satisfies(query);
  }
}
