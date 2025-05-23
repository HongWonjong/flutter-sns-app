import 'package:flutter_sns_app/domain/entities/post_settings.dart';

class PostSettingsDto {
  final String filterName;

  const PostSettingsDto({this.filterName = 'default'});

  PostSettingsDto copyWith({String? filterName}) {
    return PostSettingsDto(filterName: filterName ?? this.filterName);
  }

  Map<String, dynamic> toJson() {
    return {'filterName': filterName};
  }

  factory PostSettingsDto.fromJson(Map<String, dynamic> json) {
    return PostSettingsDto(filterName: json['filterName'] ?? 'default');
  }

  factory PostSettingsDto.fromEntity(PostSettings entity) {
    return PostSettingsDto(filterName: entity.filterName);
  }

  PostSettings toEntity() {
    return PostSettings(filterName: filterName);
  }
}
