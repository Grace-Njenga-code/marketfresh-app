class Category {
  final String id;
  final String name;
  final String emoji;
  final String? imageAsset;

  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    this.imageAsset,
  });
}