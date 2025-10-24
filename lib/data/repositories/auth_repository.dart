
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/user_mode.dart';


class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  // دالة للحصول على حالة المصادقة الحالية
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // دالة لتسجيل الدخول
  Future<void> signInWithEmail({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('فشل تسجيل الدخول: ${e.toString()}');
    }
  }

  // دالة لإنشاء حساب جديد
  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // 1. إنشاء الحساب في Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. إنشاء مودل المستخدم
      UserModel newUser = UserModel(
        id: userCredential.user!.uid,
        name: name,
        email: email,
        role: 'customer', // الدور الافتراضي
      );

      // 3. حفظ بيانات المستخدم الإضافية في Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set(newUser.toMap());

      return userCredential;
    } catch (e) {
      throw Exception('فشل إنشاء الحساب: ${e.toString()}');
    }
  }

  // دالة لتسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // دالة لجلب بيانات المستخدم من Firestore
  Future<UserModel?> getUserDetails(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }
}
