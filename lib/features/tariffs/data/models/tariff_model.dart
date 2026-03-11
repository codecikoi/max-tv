class TariffModel {
  final int id;
  final int price;
  final String title;
  final String description;
  final String slug;
  final bool archive;
  final bool videoLibrary;
  final int channelsCount;

  const TariffModel({
    required this.id,
    required this.price,
    required this.title,
    required this.description,
    required this.slug,
    required this.archive,
    required this.videoLibrary,
    required this.channelsCount,
  });

  factory TariffModel.fromJson(Map<String, dynamic> json) {
    return TariffModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      price: json['price'] is int ? json['price'] as int : int.parse(json['price'].toString()),
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      slug: json['slug'] as String,
      archive: json['archive'] as bool? ?? false,
      videoLibrary: json['video_library'] as bool? ?? false,
      channelsCount: json['channels_count'] is int
          ? json['channels_count'] as int
          : int.tryParse(json['channels_count'].toString()) ?? 0,
    );
  }
}
