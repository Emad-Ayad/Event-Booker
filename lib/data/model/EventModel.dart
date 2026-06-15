

class EventModel {
  final String id;
  final String name;
  final String imageUrl;
  final String? localDate;
  final String? localTime;
  final String? venueName;
  final String? cityName;
  final String? segmentName;
  final String? url;
  final String? info;
  final String? pleaseNote;

  EventModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.localDate,
    this.localTime,
    this.venueName,
    this.cityName,
    this.segmentName,
    this.url,
    this.info,
    this.pleaseNote,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as List?) ?? [];
    final embedded = json['_embedded'] as Map<String, dynamic>?;
    final venues = (embedded?['venues'] as List?) ?? [];
    final classifications = (json['classifications'] as List?) ?? [];

    final firstVenue =
    venues.isNotEmpty ? venues.first as Map<String, dynamic> : null;
    final firstClassification =
    classifications.isNotEmpty ? classifications.first as Map<String, dynamic> : null;

    final sortedImages = List<Map<String, dynamic>>.from(images)
      ..sort((a, b) =>
          ((b['width'] as int? ?? 0)).compareTo((a['width'] as int? ?? 0)));

    return EventModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: sortedImages.isNotEmpty ? (sortedImages.first['url'] ?? '') : '',
      localDate: json['dates']?['start']?['localDate'],
      localTime: json['dates']?['start']?['localTime'],
      venueName: firstVenue?['name'],
      cityName: firstVenue?['city']?['name'],
      segmentName: firstClassification?['segment']?['name'],
      url: json['url'],
      info: json['info'],
      pleaseNote: json['pleaseNote'],
    );
  }
}