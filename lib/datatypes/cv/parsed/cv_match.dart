import 'package:json_annotation/json_annotation.dart';

part 'cv_match.g.dart';

@JsonSerializable()
class CVMatch {
  final String match;
  final String sentence;
  @JsonKey(ignore: true)
  final bool reported;

  CVMatch({
    required this.match,
    required this.sentence,
    this.reported = false,
  });

  factory CVMatch.fromJson(Map<String, dynamic> json) =>
      _$CVMatchFromJson(json);

  Map<String, dynamic> toJson() => _$CVMatchToJson(this);
}
