// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      json['label'] as String,
      json['match'] as String,
      json['sentence'] as String,
      json['reason'] as String,
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'label': instance.label,
      'match': instance.match,
      'sentence': instance.sentence,
      'reason': instance.reason,
    };
