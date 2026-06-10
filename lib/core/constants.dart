class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String productDetail = '/product-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
}

class AppStrings {
  static const String appName = 'MarketFresh';
  static const String tagline = 'Fresh groceries, delivered fast';

  static const String navHome = 'Home';
  static const String navCart = 'Cart';
  static const String navOrders = 'Orders';
  static const String navProfile = 'Profile';

  static const String goodMorning = 'Good morning 👋';
  static const String whatDoYouNeed = 'What do you need today?';
  static const String searchHint = 'Search vegetables, fruits…';
  static const String categories = 'Categories';
  static const String featuredProducts = 'Featured';
  static const String allProducts = 'All Products';
  static const String seeAll = 'See all';

  static const String addToCart = 'Add to cart';
  static const String outOfStock = 'Out of stock';
  static const String inStock = 'In stock';
  static const String perKg = '/ kg';
  static const String perPiece = '/ piece';
  static const String perBunch = '/ bunch';

  static const String myCart = 'My Cart';
  static const String cartEmpty = 'Your cart is empty';
  static const String cartEmptySubtitle = 'Add some fresh items to get started';
  static const String cartTotal = 'Total';
  static const String deliveryFee = 'Delivery fee';
  static const String subtotal = 'Subtotal';
  static const String proceedToCheckout = 'Proceed to checkout';

  static const String checkout = 'Checkout';
  static const String deliveryDetails = 'Delivery details';
  static const String paymentMethod = 'Payment method';
  static const String orderSummary = 'Order summary';
  static const String placeOrder = 'Place order';
  static const String mpesa = 'M-Pesa';
  static const String cash = 'Cash on delivery';

  static const String myOrders = 'My Orders';
  static const String ordersEmpty = 'No orders yet';
  static const String ordersEmptySubtitle =
      'Your order history will appear here';
  static const String orderPending = 'Pending';
  static const String orderConfirmed = 'Confirmed';
  static const String orderDelivered = 'Delivered';
  static const String orderCancelled = 'Cancelled';

  static const String currency = 'KES';
}

class AppAssets {
  static const String _imgBase = 'assets/images/';
  static const String placeholder = '${_imgBase}placeholder.png';
  static const String logo = '${_imgBase}logo.png';
}

class AppConfig {
  static const int splashDuration = 2500;
  static const double deliveryFee = 150.0;
  static const double freeDeliveryThreshold = 2000.0;
  static const int maxCartQuantity = 20;
  static const String phoneNumber = '+254 700 000 000';
  static const String supportEmail = 'support@marketfresh.co.ke';
}