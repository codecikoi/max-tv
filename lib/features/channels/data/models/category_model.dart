import 'channel_model.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? imageUrl;
  final int count;
  final List<ChannelModel>? channels;

  const CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.count = 0,
    this.channels,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      count: json['count'] as int? ?? 0,
      channels: json['channels'] != null
          ? (json['channels'] as List)
              .map((e) => ChannelModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
