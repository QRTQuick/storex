class Shop {
  final String id;
  final String ownerId;
  final String name;
  final String description;
  final String? websiteUrl;
  final bool isOnline;
  final DateTime createdAt;

  Shop({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.description,
    this.websiteUrl,
    required this.isOnline,
    required this.createdAt,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] ?? '',
      ownerId: json['owner_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      websiteUrl: json['website_url'],
      isOnline: json['is_online'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_id': ownerId,
      'name': name,
      'description': description,
      'website_url': websiteUrl,
      'is_online': isOnline,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
