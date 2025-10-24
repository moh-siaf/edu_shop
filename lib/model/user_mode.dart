
class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' or 'customer'

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role = 'customer', // القيمة الافتراضية هي عميل
  });

  // دالة لتحويل الكائن إلى Map للحفظ في Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  // دالة لإنشاء كائن من Map (قادم من Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'customer',
    );
  }
}
