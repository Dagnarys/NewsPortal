import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String role;
  final String? imageUrl;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.role,
    this.imageUrl,
  });

  factory User.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    print(data);
    return User(
      id: snapshot.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      role: data['role'] ?? 'user',
      imageUrl: data['imageUrl'],
    );
  }
}