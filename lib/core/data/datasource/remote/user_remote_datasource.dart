import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_persistent_login/core/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';

abstract class UserRemoteDatasource {
  Future<UserEntity?> getById(String id);
  Future<void> save(UserEntity user);
}

@Singleton(as: UserRemoteDatasource)
class UserRemoteDataSourceImpl implements UserRemoteDatasource {
  final firebaseFirestore = FirebaseFirestore.instance;
  late final userCollection = firebaseFirestore.collection('users');

  @override
  Future<UserEntity?> getById(String id) async {
    final doc = await userCollection.doc(id).get();
    final data = doc.data();
    if (data == null) {
      return null;
    }
    return UserEntity(
      id: id,
      email: data['email'],
      name: data['name'],
    );
  }

  @override
  Future<void> save(UserEntity user) async {
    await userCollection.doc(user.id).set({
      'name': user.name,
      'email': user.email,
    });
  }
}
