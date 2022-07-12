import '../cv_base.dart';
import '../parsed/parsed_cv.dart';

class NotParsedCV extends CVBase {
  NotParsedCV(filename) : super(filename);

  bool isParseCached() {
    throw UnimplementedError();
  }

  bool isParseCachedComplete() {
    throw UnimplementedError();
  }

  bool isParseCachedFailed() {
    throw UnimplementedError();
  }

  /// retrive from cache (works only if [isParseCachedComplete] returns true)
  ParsedCV immediateParse() {
    throw UnimplementedError();
  }

  Future<ParsedCV> parse() async {
    throw UnimplementedError();
  }

  bool satisfies(RegExp query) {
    throw UnimplementedError();
  }
}
