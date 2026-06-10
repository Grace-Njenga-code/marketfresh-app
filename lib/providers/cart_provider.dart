import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/order.dart';
import '../core/constants.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final List<Order> _orders = [];

  // ─── Getters ──────────────────────────────────────────────────
  List<CartItem> get items => _items.values.toList();

  List<Order> get orders => List.unmodifiable(_orders.reversed.toList());

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => _items.isEmpty;

  double get subtotal =>
      _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee {
    if (isEmpty) return 0;
    return subtotal >= AppConfig.freeDeliveryThreshold
        ? 0
        : AppConfig.deliveryFee;
  }

  bool get hasFreeDelivery => subtotal >= AppConfig.freeDeliveryThreshold;

  double get total => subtotal + deliveryFee;

  double get amountToFreeDelivery =>
      (AppConfig.freeDeliveryThreshold - subtotal).clamp(0, double.infinity);

  // ─── Cart Actions ─────────────────────────────────────────────
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      final current = _items[product.id]!.quantity;
      if (current >= AppConfig.maxCartQuantity) return;
      _items[product.id] = _items[product.id]!.copyWith(quantity: current + 1);
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    if (!_items.containsKey(product.id)) return;
    final current = _items[product.id]!.quantity;
    if (current <= 1) {
      _items.remove(product.id);
    } else {
      _items[product.id] = _items[product.id]!.copyWith(quantity: current - 1);
    }
    notifyListeners();
  }

  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int quantityOf(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  bool contains(String productId) => _items.containsKey(productId);

  // ─── Order Actions ────────────────────────────────────────────
  Order placeOrder({
    required String deliveryAddress,
    required String paymentMethod,
  }) {
    final order = Order(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      items: List.from(items),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.confirmed,
      createdAt: DateTime.now(),
    );
    _orders.add(order);
    clearCart();
    return order;
  }
}