import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final qty = cart.quantityOf(product.id);
    final inCart = qty > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.divider, width: 1),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.surfaceVariant,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.primarySurface,
                        child: const Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Badge
                  if (product.badge != null)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: _Badge(label: product.badge!),
                    ),
                  // Discount %
                  if (product.isOnSale)
                    Positioned(
                      top: AppSpacing.sm,
                      right: AppSpacing.sm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius:
                              BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          '-${product.discountPercent.toInt()}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ── Details ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${AppStrings.currency} ${product.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '/ ${product.unit}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textHint,
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: 6),
                        Text(
                          '${product.originalPrice!.toInt()}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // ── Add / Quantity control ──────────────────
                  if (!product.isAvailable)
                    _OutOfStockButton()
                  else if (inCart)
                    _QuantityControl(product: product, qty: qty)
                  else
                    _AddButton(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  Color get _color {
    switch (label.toLowerCase()) {
      case 'sale':
        return AppColors.accent;
      case 'fresh':
        return AppColors.primary;
      case 'popular':
        return AppColors.info;
      case 'organic':
        return AppColors.success;
      case 'local':
        return AppColors.primaryDark;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textOnPrimary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Product product;
  const _AddButton({required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 36,
      child: ElevatedButton(
        onPressed: () =>
            context.read<CartProvider>().addItem(product),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16),
            SizedBox(width: 4),
            Text('Add', style: TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final Product product;
  final int qty;
  const _QuantityControl({required this.product, required this.qty});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: Row(
        children: [
          _QtyBtn(
            icon: qty == 1 ? Icons.delete_outline : Icons.remove,
            color: qty == 1 ? AppColors.error : AppColors.primary,
            onTap: () => cart.removeItem(product),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$qty',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          _QtyBtn(
            icon: Icons.add,
            color: AppColors.primary,
            onTap: () => cart.addItem(product),
          ),
        ],
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _QtyBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md - 2),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

class _OutOfStockButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: const Center(
        child: Text(
          AppStrings.outOfStock,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }
}