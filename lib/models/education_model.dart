class EducationModel {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final String category;
  final String createdAt;

  EducationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'category': category,
      'created_at': createdAt,
    };
  }

  factory EducationModel.fromMap(Map<String, dynamic> map) {
    return EducationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      imageUrl: map['image_url'] ?? '',
      category: map['category'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }
}