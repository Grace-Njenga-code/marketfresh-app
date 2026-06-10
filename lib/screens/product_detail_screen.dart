import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../core/theme.dart';
import '../core/constants.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final qty = cart.quantityOf(product.id);
    final inCart = qty > 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero image app bar ────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  boxShadow: AppShadows.small,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      color: AppColors.primarySurface,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.primarySurface,
                      child: const Icon(
                        Icons.image_outlined,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.background.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Badge
                  if (product.badge != null)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          product.badge!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Product info ──────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
              ),
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + availability
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: product.isAvailable
                              ? AppColors.primarySurface
                              : AppColors.surfaceVariant,
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          product.isAvailable
                              ? AppStrings.inStock
                              : AppStrings.outOfStock,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: product.isAvailable
                                ? AppColors.primary
                                : AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Price row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${AppStrings.currency} ${product.price.toInt()}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '/ ${product.unit}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                      if (product.isOnSale) ...[
                        const SizedBox(width: AppSpacing.md),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${AppStrings.currency} ${product.originalPrice!.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textHint,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius:
                                BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Text(
                            '-${product.discountPercent.toInt()}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Divider
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.lg),

                  // Description
                  const Text(
                    'About this product',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Info chips
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      _InfoChip(
                          icon: Icons.scale_outlined,
                          label: 'Per ${product.unit}'),
                      _InfoChip(
                          icon: Icons.local_shipping_outlined,
                          label: 'Fast delivery'),
                      _InfoChip(
                          icon: Icons.verified_outlined,
                          label: 'Quality assured'),
                      if (product.isFeatured)
                        _InfoChip(
                            icon: Icons.star_outline_rounded,
                            label: 'Featured'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom action bar ───────────────────────────────────
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.md +
              MediaQuery.of(context).padding.bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
              top: BorderSide(color: AppColors.divider, width: 1)),
          boxShadow: AppShadows.medium,
        ),
        child: product.isAvailable
            ? inCart
                ? _QuantityBar(product: product, qty: qty)
                : _AddToCartBar(product: product)
            : _UnavailableBar(),
      ),
    );
  }
}

// ── Bottom bar widgets ──────────────────────────────────────────

class _AddToCartBar extends StatelessWidget {
  final Product product;
  const _AddToCartBar({required this.product});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        context.read<CartProvider>().addItem(product);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} added to cart'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'View Cart',
              textColor: AppColors.primaryLight,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 20),
          const SizedBox(width: AppSpacing.sm),
          const Text(AppStrings.addToCart),
        ],
      ),
    );
  }
}

class _QuantityBar extends StatelessWidget {
  final Product product;
  final int qty;
  const _QuantityBar({required this.product, required this.qty});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return Row(
      children: [
        // Remove
        _CircleBtn(
          icon: qty == 1 ? Icons.delete_outline : Icons.remove,
          color: qty == 1 ? AppColors.error : AppColors.primary,
          bgColor: qty == 1
              ? AppColors.error.withOpacity(0.1)
              : AppColors.primarySurface,
          onTap: () => cart.removeItem(product),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$qty',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'in cart · ${AppStrings.currency} ${(product.price * qty).toInt()}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Add
        _CircleBtn(
          icon: Icons.add,
          color: AppColors.primary,
          bgColor: AppColors.primarySurface,
          onTap: () => cart.addItem(product),
        ),
      ],
    );
  }
}

class _UnavailableBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: null,
      child: const Text(AppStrings.outOfStock),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  const _CircleBtn(
      {required this.icon,
      required this.color,
      required this.bgColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}