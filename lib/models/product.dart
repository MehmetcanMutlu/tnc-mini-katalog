class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? json['title']?.toString() ?? 'Ürün',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      image: json['image']?.toString() ?? json['thumbnail']?.toString() ?? '',
      category: json['category']?.toString() ?? 'Genel',
      rating: double.tryParse(
            (json['rating'] is Map ? json['rating']['rate'] : json['rating'])?.toString() ?? '0',
          ) ??
          0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'rating': rating,
    };
  }
}
