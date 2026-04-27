class ImageItem {
  final int? id;
  final String path;
  final String? name;
  final DateTime createdAt;

  ImageItem({
    this.id,
    required this.path,
    this.name,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'path': path,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ImageItem.fromMap(Map<String, dynamic> map) {
    return ImageItem(
      id: map['id'] as int?,
      path: map['path'] as String,
      name: map['name'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  ImageItem copyWith({int? id, String? path, String? name, DateTime? createdAt}) {
    return ImageItem(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
