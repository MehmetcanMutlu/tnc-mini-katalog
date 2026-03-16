import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

enum LoadingState { idle, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _products = [];
  List<Product> _filtered = [];
  LoadingState _state = LoadingState.idle;
  String _error = '';
  String _searchQuery = '';
  String _selectedCategory = 'Tümü';

  List<Product> get products => _filtered;
  LoadingState get state => _state;
  String get error => _error;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<String> get categories {
    final cats = _products.map((p) => p.category).toSet().toList();
    cats.sort();
    return ['Tümü', ...cats];
  }

  Future<void> loadProducts() async {
    _state = LoadingState.loading;
    _error = '';
    notifyListeners();

    try {
      _products = await _service.fetchProducts();
      _validateSelectedCategory();
      _applyFilters();
      _state = LoadingState.loaded;
    } catch (e) {
      _error = e.toString();
      _state = LoadingState.error;
    }
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void filterByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void _validateSelectedCategory() {
    if (_selectedCategory == 'Tümü') return;
    final hasCategory = _products.any((p) => p.category == _selectedCategory);
    if (!hasCategory) _selectedCategory = 'Tümü';
  }

  void _applyFilters() {
    final search = _searchQuery.trim().toLowerCase();
    _filtered = _products.where((p) {
      final matchesSearch = search.isEmpty ||
          p.name.toLowerCase().contains(search) ||
          p.category.toLowerCase().contains(search);
      final matchesCategory =
          _selectedCategory == 'Tümü' || p.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList(growable: false);
  }
}
