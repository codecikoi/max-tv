class PostModel {
  final int id;
  final String title;
  final String? content;
  final String? imageUrl;
  final String createdAt;

  const PostModel({
    required this.id,
    required this.title,
    this.content,
    this.imageUrl,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String?,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] as String,
    );
  }
}
