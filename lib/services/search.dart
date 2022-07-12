import 'package:cvparser_b21_01/datatypes/export.dart';

class CVsFilter {
  static final RegExp fnPattern =
      RegExp(r"(?<=filename:)(.*?)(?=label:|match:|sentence:|$)");
  static final RegExp lblPattern =
      RegExp(r"(?<=label:)(.*?)(?=filename:|match:|sentence:|$)");
  static final RegExp matchPattern =
      RegExp(r"(?<=match:)(.*?)(?=filename:|label:|sentence:|$)");
  static final RegExp sentencePattern =
      RegExp(r"(?<=sentence:)(.*?)(?=filename:|label:|match:|$)");
  static const List<String> bannedSymbols = [r"\", r"+", r"*.", "[", "]"];

  List<NotParsedCV> allCVs;
  String query;
  var allParsedCVs = <ParsedCV>[];
  var allNotParsedCVs = <NotParsedCV>[];

  CVsFilter(this.allCVs, this.query) {
    for (var i = 0; i < allCVs.length; i++) {
      if (allCVs[i].isParseCachedComplete() &&
          (allCVs[i] as RawPdfCV).cached != null) {
        allParsedCVs.add((allCVs[i] as RawPdfCV).cached!);
      } else {
        allNotParsedCVs.add(allCVs[i]);
      }
    }
  }

  RegExp generateRegExp(String querry) {
    var strTmp = "";
    if (!(RegExp("filename:|label:|match:|sentence:")).hasMatch(querry)) {
      strTmp = querry.trim();
    } else {
      if (fnPattern.hasMatch(querry)) {
        strTmp += "filename:.*${fnPattern.stringMatch(querry)!.trim()}.*\n";
      }
      if (lblPattern.hasMatch(querry)) {
        strTmp += "label:.*${lblPattern.stringMatch(querry)!.trim()}.*\n";
      }
      if (matchPattern.hasMatch(querry)) {
        strTmp += "match:.*${matchPattern.stringMatch(querry)!.trim()}.*\n";
      }
      if (sentencePattern.hasMatch(querry)) {
        strTmp +=
            "sentence:.*${sentencePattern.stringMatch(querry)!.trim()}.*\n";
      }
    }
    for (var elem in bannedSymbols) {
      if (strTmp.contains(elem)) {
        strTmp = strTmp.replaceAll(elem, r"\" + elem);
      }
    }
    RegExp regEx;
    try {
      regEx = RegExp(strTmp, unicode: true, caseSensitive: false);
    } on Exception {
      regEx = RegExp("");
    }
    return regEx;
  }

  List<ParsedCV> _filterCVs(List<ParsedCV> data, String query) {
    var orQuery = query.split("|");
    var binOutput = <bool>[];
    for (int i = 0; i < orQuery.length; i++) {
      var andQuery = orQuery[i].split("&");
      var curAndBin = findCVs(data, generateRegExp(andQuery[0]));

      for (int j = 1; j < andQuery.length; j++) {
        curAndBin =
            andList(curAndBin, findCVs(data, generateRegExp(andQuery[j])));
      }
      if (binOutput.isEmpty) {
        binOutput = curAndBin;
      } else {
        binOutput = orList(binOutput, curAndBin);
      }
    }

    var filtered = <ParsedCV>[];
    for (int i = 0; i < binOutput.length; i++) {
      if (binOutput[i]) filtered.add(data[i]);
    }
    return filtered;
  }

  List<bool> andList(List<bool> a, List<bool> b) {
    var output = List.generate(a.length, (index) => false);
    for (var i = 0; i < a.length; i++) {
      if (a[i] && b[i]) {
        output[i] = true;
      }
    }
    return output;
  }

  List<bool> orList(List<bool> a, List<bool> b) {
    var output = List.generate(a.length, (index) => false);
    for (var i = 0; i < a.length; i++) {
      if (a[i] || b[i]) {
        output[i] = true;
      }
    }
    return output;
  }

  List<bool> findCVs(List<ParsedCV> data, RegExp querry) {
    var output = List.generate(data.length, (index) => false);
    for (var i = 0; i < data.length; i++) {
      if (data[i].satisfies(querry)) {
        output[i] = true;
      }
    }
    return output;
  }

  List<NotParsedCV> getFiltered() {
    if (query.isEmpty) {
      return allCVs;
    }
    var parsedFiltered = _filterCVs(allParsedCVs, query);

    var output = <NotParsedCV>[];
    for (var i = 0; i < allCVs.length; i++) {
      if (allCVs[i].isParseCachedComplete() &&
          parsedFiltered.contains(allCVs[i].immediateParse())) {
        output.add(allCVs[i]);
      } else if (!allCVs[i].isParseCachedComplete()) {
        output.add(allCVs[i]);
      }
    }
    for (var i = 0; i < allNotParsedCVs.length; i++) {
      output.add(allNotParsedCVs[i]);
    }
    return output;
  }
}
