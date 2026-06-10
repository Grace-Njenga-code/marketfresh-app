import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/category.dart';
import '../data/mock_data.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = MockData.products;
  List<Category> _categories = MockData.categories;
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  bool _isSearching = false;

  // ─── Getters ──────────────────────────────────────────────────
  List<Category> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;

  List<Product> get featuredProducts => MockData.getFeatured();

  List<Product> get filteredProducts {
    if (_searchQuery.isNotEmpty) {
      return MockData.search(_searchQuery);
    }
    return MockData.getByCategory(_selectedCategoryId);
  }

  // ─── Actions ──────────────────────────────────────────────────
  void selectCategory(String categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    _searchQuery = '';
    _isSearching = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _isSearching = query.isNotEmpty;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _isSearching = false;
    notifyListeners();
  }
}