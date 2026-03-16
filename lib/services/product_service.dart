import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String _baseUrl = 'https://wantapi.com/products.php';
  static const String _fallbackUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    try {
      return await _fetchFrom(_baseUrl, seconds: 8);
    } catch (_) {
      return await _fetchFallback();
    }
  }

  Future<List<Product>> _fetchFallback() async {
    return _fetchFrom(_fallbackUrl, seconds: 10);
  }

  Future<List<Product>> _fetchFrom(
    String url, {
    required int seconds,
  }) async {
    final response =
        await http.get(Uri.parse(url)).timeout(Duration(seconds: seconds));

    if (response.statusCode != 200) {
      throw Exception('Sunucudan ürün verisi alınamadı (${response.statusCode})');
    }

    final dynamic decoded = json.decode(response.body);
    final List<dynamic> data = _extractData(decoded);

    if (data.isEmpty) {
      throw Exception('Ürün listesi boş döndü');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList(growable: false);
  }

  List<dynamic> _extractData(dynamic decoded) {
    if (decoded is List) return decoded;

    if (decoded is Map) {
      if (decoded['products'] is List) {
        return decoded['products'] as List<dynamic>;
      }
      if (decoded['data'] is List) {
        return decoded['data'] as List<dynamic>;
      }
    }

    throw Exception('Beklenmeyen API cevap formatı');
  }
}
