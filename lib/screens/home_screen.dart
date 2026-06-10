import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/bottom_nav_bar.dart';
import '../core/theme.dart';
import '../core/constants.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    setState(() => _currentNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _currentNavIndex,
        children: [
          _HomeTab(
            searchController: _searchController,
            scrollController: _scrollController,
            onCartTap: () => setState(() => _currentNavIndex = 1),
          ),
          const CartScreen(),
          const OrdersScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ── Inline Cart Badge ────────────────────────────────────────────

class _AppBarCartBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _AppBarCartBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: AppSpacing.md),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
            if (count > 0)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 18, minHeight: 18),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    border:
                        Border.all(color: AppColors.surface, width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Home Tab ─────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final TextEditingController searchController;
  final ScrollController scrollController;
  final VoidCallback onCartTap;

  const _HomeTab({
    required this.searchController,
    required this.scrollController,
    required this.onCartTap,
  });

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartCount = context.watch<CartProvider>().itemCount;

    return SafeArea(
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: AppSpacing.md,
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.goodMorning,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            actions: [
              _AppBarCartBadge(count: cartCount, onTap: onCartTap),
            ],
          ),
        ],
        body: CustomScrollView(
          slivers: [
            // ── Search bar ──────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: _SearchBar(controller: searchController),
              ),
            ),

            // ── Category chips ──────────────────────────────
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  itemCount: productProvider.categories.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, i) {
                    final cat = productProvider.categories[i];
                    return CategoryChip(
                      label: cat.name,
                      emoji: cat.emoji,
                      isSelected:
                          productProvider.selectedCategoryId == cat.id,
                      onTap: () =>
                          productProvider.selectCategory(cat.id),
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.md)),

            // ── Featured row ────────────────────────────────
            if (!productProvider.isSearching) ...[
              _SectionHeader(
                title: AppStrings.featuredProducts,
                onSeeAll: () => productProvider.selectCategory('all'),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                    itemCount: productProvider.featuredProducts.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.md),
                    itemBuilder: (context, i) {
                      final product =
                          productProvider.featuredProducts[i];
                      return SizedBox(
                        width: 160,
                        child: ProductCard(
                          product: product,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.lg)),
            ],

            // ── All products grid ────────────────────────────
            _SectionHeader(
              title: productProvider.isSearching
                  ? 'Results for "${productProvider.searchQuery}"'
                  : AppStrings.allProducts,
            ),

            if (productProvider.filteredProducts.isEmpty)
              const SliverFillRemaining(child: _EmptyState())
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final product =
                          productProvider.filteredProducts[i];
                      return ProductCard(
                        product: product,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(product: product),
                          ),
                        ),
                      );
                    },
                    childCount: productProvider.filteredProducts.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.72,
                  ),
                ),
              ),

            const SliverToBoxAdapter(
                child: SizedBox(height: AppSpacing.xxl)),
          ],
        ),
      ),
    );
  }
}

// ── Search Bar ───────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProductProvider>();
    return TextField(
      controller: controller,
      onChanged: provider.setSearchQuery,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: AppStrings.searchHint,
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: context.watch<ProductProvider>().isSearching
            ? GestureDetector(
                onTap: () {
                  controller.clear();
                  provider.clearSearch();
                },
                child: const Icon(Icons.close_rounded, size: 20),
              )
            : null,
      ),
    );
  }
}

// ── Section Header ───────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onSeeAll != null)
              TextButton(
                onPressed: onSeeAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  AppStrings.seeAll,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ──────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.xxl),
            ),
            child: const Icon(Icons.search_off_rounded,
                size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'No products found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Try a different search or category',
            style:
                TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}