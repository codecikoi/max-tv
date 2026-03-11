class ProgramModel {
  final int? id;
  final String title;
  final String? description;
  final String? startTime;
  final String? endTime;
  final bool current;
  final bool isArchive;
  final String? streamUrl;

  const ProgramModel({
    this.id,
    required this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.current = false,
    this.isArchive = false,
    this.streamUrl,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      current: json['current'] as bool? ?? false,
      isArchive: json['is_archive'] as bool? ?? false,
      streamUrl: json['stream_url'] as String?,
    );
  }

  String? get formattedStartTime => _extractTime(startTime);
  String? get formattedEndTime => _extractTime(endTime);

  /// Extract date part "DD-MM-YYYY" from startTime
  String? get startDate {
    if (startTime == null) return null;
    final parts = startTime!.split(' ');
    return parts.isNotEmpty ? parts[0] : null;
  }

  String? _extractTime(String? dateTime) {
    if (dateTime == null) return null;
    final parts = dateTime.split(' ');
    if (parts.length < 2) return dateTime;
    final timeParts = parts[1].split(':');
    if (timeParts.length < 2) return parts[1];
    return '${timeParts[0]}:${timeParts[1]}';
  }
}
