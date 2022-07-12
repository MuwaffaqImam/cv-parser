import 'package:json_annotation/json_annotation.dart';

import '../cv_base.dart';
import 'cv_entries.dart';

part 'parsed_cv.g.dart';

/// Use this datatype to represent iExtract CV parse result
/// both with assigning it to the filename from where data was taken.

/// Note: no fromJson beacuse the operation is assymetric itself:
/// toJson should contain [filename]
/// but fromJson is constructed on [CVEntries] given from anywhere else,
/// not necessary for it to be constructed in a straightforward manner
/// (ya, it's actually constructed using handwritten json parsing,
/// for reasoning see [iExtract] service [parseCV] method docs)
/// + also the filename is even not in json itself

@JsonSerializable(createFactory: false)
class ParsedCV extends CVBase {
  final CVEntries data;

  ParsedCV({
    required filename,
    required this.data,
  }) : super(filename);

  Map<String, dynamic> toJson() => _$ParsedCVToJson(this);

  bool satisfies(RegExp query) {
    for (final entry in data.entries) {
      String label = entry.key;
      for (final cvmatch in entry.value) {
        String match = cvmatch.match;
        String sentence = cvmatch.sentence;

        String combine =
            """filename: $filename\nlabel: $label\nmatch: $match\nsentence: $sentence""";

        if (query.hasMatch(combine)) {
          return true;
        }
      }
    }
    return false;
  }
}
