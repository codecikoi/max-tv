class ChannelModel {
  final String id;
  final String name;
  final String logoUrl;
  final int number;
  final String? currentProgram;
  final String? currentProgramTime;
  final String? category;
  final bool isFavorite;

  const ChannelModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.number,
    this.currentProgram,
    this.currentProgramTime,
    this.category,
    this.isFavorite = false,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String,
      number: json['number'] as int,
      currentProgram: json['current_program'] as String?,
      currentProgramTime: json['current_program_time'] as String?,
      category: json['category'] as String?,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }
}
