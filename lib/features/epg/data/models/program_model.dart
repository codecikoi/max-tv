class ProgramModel {
  final int? id;
  final String title;
  final String? description;
  final String? startTime;
  final String? endTime;

  const ProgramModel({
    this.id,
    required this.title,
    this.description,
    this.startTime,
    this.endTime,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
    );
  }
}
