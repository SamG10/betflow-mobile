import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  bool containsItem(Map<String, dynamic> item) {
    return _items.any((existingItem) => existingItem['id'] == item['id']);
  }

  void addItem(Map<String, dynamic> item) {
    if (!containsItem(item)) {
      _items.add(item);
      notifyListeners();
    }
  }

  void removeItem(Map<String, dynamic> item) {
    _items.removeWhere((existingItem) => existingItem['id'] == item['id']);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int get itemCount {
    return _items.length;
  }
}
