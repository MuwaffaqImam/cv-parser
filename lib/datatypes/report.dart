import 'package:cvparser_b21_01/datatypes/cv/parsed/cv_match.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  final String label;
  final String match;
  final String sentence;
  final String reason;

  Report(
    this.label,
    this.match,
    this.sentence,
    this.reason,
  );

  factory Report.fromCVMatch({
    required String label,
    required String reason,
    required CVMatch cvmatch,
  }) =>
      Report(label, cvmatch.match, cvmatch.sentence, reason);

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
