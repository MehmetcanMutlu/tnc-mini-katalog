import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/models/product.dart';
import 'package:mini_katalog/providers/cart_provider.dart';

void main() {
  Product buildProduct({int id = 1, double price = 10}) {
    return Product(
      id: id,
      name: 'Ürün $id',
      description: 'Açıklama',
      price: price,
      image: '',
      category: 'Genel',
      rating: 0,
    );
  }

  group('CartProvider', () {
    test('adds same product by increasing quantity', () {
      final cart = CartProvider();
      final product = buildProduct();

      cart.addItem(product);
      cart.addItem(product);

      expect(cart.itemCount, 2);
      expect(cart.getQuantity(product.id), 2);
      expect(cart.totalAmount, 20);
    });

    test('decreaseQuantity removes item at 1', () {
      final cart = CartProvider();
      final product = buildProduct(id: 5, price: 15);

      cart.addItem(product);
      cart.decreaseQuantity(product.id);

      expect(cart.itemCount, 0);
      expect(cart.items.containsKey(product.id), false);
      expect(cart.totalAmount, 0);
    });
  });
}
