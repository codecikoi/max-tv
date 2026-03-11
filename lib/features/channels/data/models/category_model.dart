import 'channel_model.dart';

class CategoryModel {
  final int id;
  final String name;
  final List<ChannelModel>? channels;

  const CategoryModel({
    required this.id,
    required this.name,
    this.channels,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String,
      channels: json['channels'] != null
          ? (json['channels'] as List)
              .map((e) => ChannelModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }
}
