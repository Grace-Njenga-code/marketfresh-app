import '../models/category.dart';
import '../models/product.dart';

class MockData {
  static const List<Category> categories = [
    Category(id: 'all', name: 'All', emoji: '🛒'),
    Category(id: 'vegetables', name: 'Vegetables', emoji: '🥦'),
    Category(id: 'fruits', name: 'Fruits', emoji: '🍎'),
    Category(id: 'leafy', name: 'Leafy Greens', emoji: '🥬'),
    Category(id: 'roots', name: 'Roots & Tubers', emoji: '🥕'),
    Category(id: 'herbs', name: 'Herbs & Spices', emoji: '🌿'),
  ];

  static const List<Product> products = [
    // ── Vegetables ───────────────────────────────────────────────
    Product(
      id: 'p001',
      name: 'Fresh Tomatoes',
      description:
          'Ripe, juicy tomatoes from Kirinyaga farms. Perfect for stews, salads and sauces.',
      price: 80,
      unit: 'kg',
      categoryId: 'vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1546094096-0df4bcabd337?w=400&q=80',
      isFeatured: true,
      originalPrice: 120,
      badge: 'Sale',
    ),
    Product(
      id: 'p002',
      name: 'White Onions',
      description:
          'Large firm white onions from Njoro. Essential for frying, grilling and soups.',
      price: 60,
      unit: 'kg',
      categoryId: 'vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=400&q=80',
      isFeatured: true,
    ),
    Product(
      id: 'p003',
      name: 'Green Capsicum',
      description:
          'Crisp green bell peppers locally grown. Great in stir-fries, salads and pizzas.',
      price: 120,
      unit: 'kg',
      categoryId: 'vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1526470498-9ae73c665de8?w=400&q=80',
    ),
    Product(
      id: 'p004',
      name: 'Broccoli',
      description:
          'Fresh broccoli heads packed with fibre and vitamins. Great steamed or stir-fried.',
      price: 150,
      unit: 'piece',
      categoryId: 'vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=400&q=80',
      isFeatured: true,
      badge: 'Fresh',
    ),
    Product(
      id: 'p005',
      name: 'Zucchini',
      description:
          'Tender green zucchini perfect for grilling or baking. Low in calories.',
      price: 100,
      unit: 'kg',
      categoryId: 'vegetables',
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80',
    ),

    // ── Fruits ───────────────────────────────────────────────────
    Product(
      id: 'p006',
      name: 'Bananas',
      description:
          'Sweet ripe bananas from Mt Kenya region. Great source of potassium.',
      price: 50,
      unit: 'bunch',
      categoryId: 'fruits',
      imageUrl: 'https://images.unsplash.com/photo-1528825871115-3581a5387919?w=400&q=80',
      isFeatured: true,
    ),
    Product(
      id: 'p007',
      name: 'Watermelon',
      description:
          'Large sweet watermelons from Makueni County. Refreshing and hydrating.',
      price: 200,
      unit: 'piece',
      categoryId: 'fruits',
      imageUrl: 'https://images.unsplash.com/photo-1563114773-84221bd62daa?w=400&q=80',
      originalPrice: 250,
      badge: 'Sale',
    ),
    Product(
      id: 'p008',
      name: 'Avocado',
      description:
          'Creamy Hass avocados from Murang\'a. Rich in healthy fats and vitamin E.',
      price: 30,
      unit: 'piece',
      categoryId: 'fruits',
      imageUrl: 'https://images.unsplash.com/photo-1632511882256-b6f32ef58a98?w=400&q=80',
      isFeatured: true,
      badge: 'Popular',
    ),
    Product(
      id: 'p009',
      name: 'Passion Fruit',
      description:
          'Tangy aromatic passion fruits from Central Kenya. Perfect for juices.',
      price: 80,
      unit: 'kg',
      categoryId: 'fruits',
      imageUrl: 'https://images.unsplash.com/photo-1604495772376-9657f0035efb?w=400&q=80',
    ),
    Product(
      id: 'p010',
      name: 'Mangoes',
      description:
          'Sweet juicy mangoes from Ukambani. Naturally ripened and full of flavour.',
      price: 120,
      unit: 'kg',
      categoryId: 'fruits',
      imageUrl: 'https://images.unsplash.com/photo-1601493700631-2b16ec4b4716?w=400&q=80',
      badge: 'Fresh',
    ),

    // ── Leafy Greens ─────────────────────────────────────────────
    Product(
      id: 'p011',
      name: 'Sukuma Wiki',
      description:
          'Fresh kale (sukuma wiki) — a Kenyan staple loaded with iron and vitamins.',
      price: 30,
      unit: 'bunch',
      categoryId: 'leafy',
      imageUrl: 'https://images.unsplash.com/photo-1524179091875-bf99a9a6af57?w=400&q=80',
      isFeatured: true,
      badge: 'Local',
    ),
    Product(
      id: 'p012',
      name: 'Spinach',
      description:
          'Tender baby spinach leaves washed and ready to use. Great in salads.',
      price: 40,
      unit: 'bunch',
      categoryId: 'leafy',
      imageUrl: 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=400&q=80',
    ),
    Product(
      id: 'p013',
      name: 'Cabbage',
      description:
          'Large firm green cabbages from Limuru highlands. Great for coleslaw and stews.',
      price: 70,
      unit: 'piece',
      categoryId: 'leafy',
      imageUrl: 'https://images.unsplash.com/photo-1594282486552-05b4d80fbb9f?w=400&q=80',
    ),
    Product(
      id: 'p014',
      name: 'Managu',
      description:
          'African nightshade — a traditional Kenyan vegetable rich in iron and minerals.',
      price: 25,
      unit: 'bunch',
      categoryId: 'leafy',
      imageUrl: 'https://images.unsplash.com/photo-1637944935011-c2b6b2e6fcf8?w=400&q=80',
      badge: 'Local',
    ),

    // ── Roots & Tubers ───────────────────────────────────────────
    Product(
      id: 'p015',
      name: 'Irish Potatoes',
      description:
          'Firm starchy potatoes from Nyandarua. Great boiled, fried or mashed.',
      price: 70,
      unit: 'kg',
      categoryId: 'roots',
      imageUrl: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&q=80',
      isFeatured: true,
    ),
    Product(
      id: 'p016',
      name: 'Carrots',
      description:
          'Sweet crunchy carrots from Kinangop. High in beta-carotene.',
      price: 60,
      unit: 'kg',
      categoryId: 'roots',
      imageUrl: 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400&q=80',
    ),
    Product(
      id: 'p017',
      name: 'Sweet Potatoes',
      description:
          'Orange-fleshed sweet potatoes. Naturally sweet and rich in vitamin A.',
      price: 80,
      unit: 'kg',
      categoryId: 'roots',
      imageUrl: 'https://images.unsplash.com/photo-1596097635121-14b63b7a0c19?w=400&q=80',
      badge: 'Organic',
    ),
    Product(
      id: 'p018',
      name: 'Arrow Roots (Nduma)',
      description:
          'Fresh arrow roots — a Kenyan favourite. Boil and enjoy as a snack.',
      price: 90,
      unit: 'kg',
      categoryId: 'roots',
      imageUrl: 'https://images.unsplash.com/photo-1567375698348-5d9d5ae99de0?w=400&q=80',
      badge: 'Local',
    ),

    // ── Herbs & Spices ───────────────────────────────────────────
    Product(
      id: 'p019',
      name: 'Fresh Coriander',
      description:
          'Fragrant fresh coriander (dhania) farm-fresh. Brightens curries and salads.',
      price: 20,
      unit: 'bunch',
      categoryId: 'herbs',
      imageUrl: 'https://images.unsplash.com/photo-1499789279471-0951f2cd5c39?w=400&q=80',
    ),
    Product(
      id: 'p020',
      name: 'Spring Onions',
      description:
          'Crisp spring onions with mild flavour. Great as garnish or in salads.',
      price: 25,
      unit: 'bunch',
      categoryId: 'herbs',
      imageUrl: 'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?w=400&q=80',
    ),
    Product(
      id: 'p021',
      name: 'Garlic',
      description:
          'Plump pungent garlic bulbs. Flavour base for virtually every cuisine.',
      price: 50,
      unit: 'piece',
      categoryId: 'herbs',
      imageUrl: 'https://images.unsplash.com/photo-1615477550927-6ec8445aa0f4?w=400&q=80',
      isFeatured: true,
    ),
    Product(
      id: 'p022',
      name: 'Fresh Ginger',
      description:
          'Knobby fresh ginger root. Adds warmth to teas, curries and stir-fries.',
      price: 40,
      unit: 'piece',
      categoryId: 'herbs',
      imageUrl: 'https://images.unsplash.com/photo-1615484477778-ca3b77940c25?w=400&q=80',
    ),
  ];

  static List<Product> getByCategory(String categoryId) {
    if (categoryId == 'all') return products;
    return products.where((p) => p.categoryId == categoryId).toList();
  }

  static List<Product> getFeatured() {
    return products.where((p) => p.isFeatured).toList();
  }

  static List<Product> search(String query) {
    final q = query.toLowerCase();
    return products.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q) ||
          p.categoryId.toLowerCase().contains(q);
    }).toList();
  }

  static Product? getById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}