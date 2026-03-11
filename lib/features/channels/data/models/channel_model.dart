import 'category_model.dart';

class CurrentProgram {
  final String? title;
  final String? startTime;
  final String? endTime;

  const CurrentProgram({this.title, this.startTime, this.endTime});

  factory CurrentProgram.fromJson(Map<String, dynamic> json) {
    return CurrentProgram(
      title: json['title'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
    );
  }
}

class ChannelModel {
  final int id;
  final String name;
  final String? logoUrl;
  final String? description;
  final CurrentProgram? currentProgram;
  final List<CategoryModel>? categories;

  const ChannelModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.description,
    this.currentProgram,
    this.categories,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] as int,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      description: json['description'] as String?,
      currentProgram: json['current'] != null
          ? CurrentProgram.fromJson(json['current'] as Map<String, dynamic>)
          : null,
      categories: json['categories'] != null
          ? (json['categories'] as List)
              .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
