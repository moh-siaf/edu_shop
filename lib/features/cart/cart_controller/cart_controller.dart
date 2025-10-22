import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../model/product_model.dart';
import '../model/cart_item_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> _cartItems = <CartItemModel>[].obs;
  final _box = GetStorage();

  List<CartItemModel> get cartItems => _cartItems.toList();
  double get totalPrice => _cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  int get totalUniqueItems => _cartItems.length;

  @override
  void onInit() {
    super.onInit();
    // 1. اقرأ السلة المحفوظة عند بدء التشغيل
    List<dynamic>? savedData = _box.read<List<dynamic>>('cart');
    if (savedData != null) {
      _cartItems.value = savedData.map((item) => CartItemModel.fromMap(item)).toList();
    }
  }

  // 2. دالة خاصة لحفظ السلة في الذاكرة
  void _saveCart() {
    _box.write('cart', _cartItems.map((item) => item.toMap()).toList());
  }

  void addToCart(ProductModel product, {int quantity = 1}) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItemModel(product: product, quantity: quantity));
    }
    _saveCart(); // 3. احفظ بعد كل تعديل
    _cartItems.refresh();
    Get.snackbar('تمت الإضافة', 'تمت إضافة المنتج للسلة');
  }

  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    _saveCart(); // 3. احفظ بعد كل تعديل
  }

  void updateQuantity(String productId, int newQuantity) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (newQuantity > 0) {
        _cartItems[index].quantity = newQuantity;
      } else {
        _cartItems.removeAt(index); // استخدم removeAt لضمان التحديث
      }
      _saveCart(); // 3. احفظ بعد كل تعديل
      _cartItems.refresh();
    }
  }

  void incrementQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _cartItems[index].quantity++;
      _saveCart(); // 3. احفظ بعد كل تعديل
      _cartItems.refresh();
    }
  }

  void decrementQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        _cartItems.removeAt(index); // استخدم removeAt لضمان التحديث
      }
      _saveCart(); // 3. احفظ بعد كل تعديل
      _cartItems.refresh();
    }
  }
}
