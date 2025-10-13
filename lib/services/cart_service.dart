// lib/services/cart_service.dart
class CartService {
  static final List<Map<String, dynamic>> _cartItems = [];

  static List<Map<String, dynamic>> get cartItems => _cartItems;

  static void addToCart(Map<String, dynamic> product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item['name'] == product['name'],
    );

    if (existingIndex == -1) {
      _cartItems.add({...product, 'quantity': 1});
    } else {
      _cartItems[existingIndex]['quantity'] += 1;
    }
  }

  static void removeFromCart(Map<String, dynamic> product) {
    final existingIndex = _cartItems.indexWhere(
      (item) => item['name'] == product['name'],
    );

    if (existingIndex != -1) {
      if (_cartItems[existingIndex]['quantity'] > 1) {
        _cartItems[existingIndex]['quantity'] -= 1;
      } else {
        _cartItems.removeAt(existingIndex);
      }
    }
  }

  static void clearCart() => _cartItems.clear();

  static double getTotalPrice() {
    return _cartItems.fold(0.0, (total, item) {
      return total + (99 * (item['quantity'] as int));
    });
  }

  static int getTotalItems() {
    return _cartItems.fold(0, (total, item) {
      return total + (item['quantity'] as int);
    });
  }
}