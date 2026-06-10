import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/cart_item.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          cart.isEmpty
              ? AppStrings.myCart
              : '${AppStrings.myCart} (${cart.itemCount})',
        ),
        automaticallyImplyLeading: false,
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, cart),
              child: const Text(
                'Clear',
                style: TextStyle(color: AppColors.error),
              ),
            ),
        ],
      ),
      body: cart.isEmpty
          ? const _EmptyCart()
          : Column(
              children: [
                if (!cart.hasFreeDelivery)
                  _DeliveryProgress(
                    amount: cart.amountToFreeDelivery,
                    subtotal: cart.subtotal,
                  ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) =>
                        _CartItemTile(item: cart.items[i]),
                  ),
                ),
                _CartSummary(cart: cart),
              ],
            ),
    );
  }

  void _confirmClear(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear cart?'),
        content:
            const Text('This will remove all items from your cart.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cart Item Tile ───────────────────────────────────────────────

class _CartItemTile extends StatelessWidget {
  final CartItem item;

  const _CartItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final product = item.product;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md),
            child: Image.network(
              product.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: AppColors.primarySurface,
                child: const Icon(Icons.image_outlined,
                    color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppStrings.currency} ${product.price.toInt()} / ${product.unit}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _SmallQtyBtn(
                      icon: item.quantity == 1
                          ? Icons.delete_outline
                          : Icons.remove,
                      color: item.quantity == 1
                          ? AppColors.error
                          : AppColors.primary,
                      onTap: () => cart.removeItem(product),
                    ),
                    Container(
                      width: 36,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    _SmallQtyBtn(
                      icon: Icons.add,
                      color: AppColors.primary,
                      onTap: () => cart.addItem(product),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Total price
          Text(
            '${AppStrings.currency} ${item.totalPrice.toInt()}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallQtyBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _SmallQtyBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ── Delivery Progress ────────────────────────────────────────────

class _DeliveryProgress extends StatelessWidget {
  final double amount;
  final double subtotal;
  const _DeliveryProgress(
      {required this.amount, required this.subtotal});

  @override
  Widget build(BuildContext context) {
    final progress =
        (subtotal / AppConfig.freeDeliveryThreshold).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.accentSurface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: AppColors.accentLight.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🚚 ', style: TextStyle(fontSize: 16)),
              Expanded(
                child: Text(
                  'Add ${AppStrings.currency} ${amount.toInt()} more for free delivery',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.divider,
              color: AppColors.accent,
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cart Summary ─────────────────────────────────────────────────

class _CartSummary extends StatelessWidget {
  final CartProvider cart;
  const _CartSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(
            top: BorderSide(color: AppColors.divider)),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: AppStrings.subtotal,
            value: '${AppStrings.currency} ${cart.subtotal.toInt()}',
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: AppStrings.deliveryFee,
            value: cart.hasFreeDelivery
                ? 'FREE 🎉'
                : '${AppStrings.currency} ${cart.deliveryFee.toInt()}',
            valueColor: cart.hasFreeDelivery
                ? AppColors.success
                : AppColors.textPrimary,
          ),
          const Padding(
            padding:
                EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: AppStrings.cartTotal,
            value: '${AppStrings.currency} ${cart.total.toInt()}',
            isBold: true,
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CheckoutScreen()),
            ),
            child: const Text(AppStrings.proceedToCheckout),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 16 : 14,
            fontWeight:
                isBold ? FontWeight.w700 : FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            fontWeight:
                isBold ? FontWeight.w700 : FontWeight.w500,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ── Empty Cart ───────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.xxl),
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 52,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text(
            AppStrings.cartEmpty,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            AppStrings.cartEmptySubtitle,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}