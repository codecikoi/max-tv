import 'category_model.dart';

class CurrentProgram {
  final int? id;
  final String? title;
  final String? startTime;
  final String? endTime;

  const CurrentProgram({this.id, this.title, this.startTime, this.endTime});

  factory CurrentProgram.fromJson(Map<String, dynamic> json) {
    return CurrentProgram(
      id: json['id'] as int?,
      title: json['title'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
    );
  }

  String? get formattedStartTime => _extractTime(startTime);
  String? get formattedEndTime => _extractTime(endTime);

  String? _extractTime(String? dateTime) {
    if (dateTime == null) return null;
    final parts = dateTime.split(' ');
    if (parts.length < 2) return dateTime;
    final timeParts = parts[1].split(':');
    if (timeParts.length < 2) return parts[1];
    return '${timeParts[0]}:${timeParts[1]}';
  }
}

class ChannelModel {
  final int id;
  final String name;
  final int? num;
  final String? logoUrl;
  final String? description;
  final String? streamUrl;
  final CurrentProgram? currentProgram;
  final bool isFavourite;
  final List<CategoryModel>? categories;

  const ChannelModel({
    required this.id,
    required this.name,
    this.num,
    this.logoUrl,
    this.description,
    this.streamUrl,
    this.currentProgram,
    this.isFavourite = false,
    this.categories,
  });

  static String? _validImageUrl(String? url) {
    if (url == null || url.contains('placeholder.com')) return null;
    return url;
  }

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] as int? ?? 0,
      name: json['title'] as String? ?? '',
      num: json['num'] as int?,
      logoUrl: _validImageUrl(json['image_url'] as String?),
      description: json['description'] as String?,
      streamUrl: json['stream_url'] as String?,
      currentProgram: json['current_program'] != null
          ? CurrentProgram.fromJson(
              json['current_program'] as Map<String, dynamic>)
          : null,
      isFavourite: json['is_favourite'] as bool? ?? false,
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
