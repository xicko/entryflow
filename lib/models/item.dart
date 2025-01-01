class Item {
  final String id;
  final String title;
  final String image;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.title,
    required this.image,
    required this.createdAt,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
