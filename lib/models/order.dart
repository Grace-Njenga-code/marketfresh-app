import 'cart_item.dart';

enum OrderStatus { pending, confirmed, outForDelivery, delivered, cancelled }

extension OrderStatusLabel on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.outForDelivery:
        return 'Out for delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get emoji {
    switch (this) {
      case OrderStatus.pending:
        return '🕐';
      case OrderStatus.confirmed:
        return '✅';
      case OrderStatus.outForDelivery:
        return '🛵';
      case OrderStatus.delivered:
        return '📦';
      case OrderStatus.cancelled:
        return '❌';
    }
  }
}

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final String deliveryAddress;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  double get total => subtotal + deliveryFee;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}