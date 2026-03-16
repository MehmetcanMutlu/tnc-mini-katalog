import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';

void main() {
  group('Product.fromJson', () {
    test('maps fakestore style payload', () {
      final product = Product.fromJson(<String, dynamic>{
        'id': 1,
        'title': 'T-Shirt',
        'description': 'Basic cotton t-shirt',
        'price': 19.99,
        'image': 'https://example.com/image.png',
        'category': 'clothing',
        'rating': <String, dynamic>{'rate': 4.3},
      });

      expect(product.id, 1);
      expect(product.name, 'T-Shirt');
      expect(product.price, 19.99);
      expect(product.category, 'clothing');
      expect(product.rating, 4.3);
    });

    test('handles missing keys safely', () {
      final product = Product.fromJson(<String, dynamic>{});

      expect(product.id, 0);
      expect(product.name, 'Ürün');
      expect(product.price, 0.0);
      expect(product.category, 'Genel');
      expect(product.rating, 0.0);
    });
  });
}
