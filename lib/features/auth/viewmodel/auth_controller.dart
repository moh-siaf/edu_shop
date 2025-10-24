// --- في ملف: lib/features/auth/viewmodel/auth_controller.dart ---

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

import '../../../model/user_mode.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  // --- الحالة (State) ---
  final Rx<User?> _firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> _firestoreUser = Rx<UserModel?>(null);

  // --- Getters للوصول السهل من الواجهة ---
  User? get user => _firebaseUser.value;
  UserModel? get firestoreUser => _firestoreUser.value;

  // --- دورة حياة الكنترولر ---
  @override
  void onReady() {
    super.onReady();
    // ربط حالة المستخدم من Firebase بحالة الكنترولر
    _firebaseUser.bindStream(_authRepository.authStateChanges);
    // الاستماع لأي تغيير في حالة المصادقة
    ever(_firebaseUser, _setInitialScreen);
  }

  // --- دالة لتحديد الشاشة الابتدائية ---
  _setInitialScreen(User? user) async {
    if (user == null) {
      // إذا لم يكن هناك مستخدم، اذهب لصفحة تسجيل الدخول
      Get.offAllNamed(Routes.login);
    } else {
      // إذا كان هناك مستخدم، جلب بياناته من Firestore
      _firestoreUser.value = await _authRepository.getUserDetails(user.uid);
      // ثم اذهب للصفحة الرئيسية
      Get.offAllNamed(Routes.home); // أو Routes.productList
    }
  }

  // --- دوال الواجهة (UI Functions) ---

  // دالة لإنشاء حساب
  Future<void> register({required String name, required String email, required String password}) async {
    try {
      await _authRepository.signUpWithEmail(name: name, email: email, password: password);
      // _setInitialScreen سيقوم بالباقي تلقائيًا
    } catch (e) {
      Get.snackbar('خطأ في إنشاء الحساب', e.toString());
    }
  }

  // دالة لتسجيل الدخول
  Future<void> login({required String email, required String password}) async {
    try {
      await _authRepository.signInWithEmail(email: email, password: password);
      // _setInitialScreen سيقوم بالباقي تلقائيًا
    } catch (e) {
      Get.snackbar('خطأ في تسجيل الدخول', e.toString());
    }
  }

  // دالة لتسجيل الخروج
  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
