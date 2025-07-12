import 'dart:convert';

import 'package:flutter_persistent_login/core/data/datasource/local/storage_adapter.dart';
import 'package:flutter_persistent_login/core/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';

abstract class UserLocalDatasource {
  Future<UserEntity?> getUser();
  Future<void> saveUser(UserEntity user);
  Future<void> deletUser();
}

@Singleton(as: UserLocalDatasource)
class UserLocalDataSourceImpl implements UserLocalDatasource {
  final LocalStorage localStorage;

  UserLocalDataSourceImpl(this.localStorage);

  @override
  Future<UserEntity?> getUser() async {
    final json = await localStorage.get<String>('user');
    if (json == null) {
      return null;
    }
    final userMap = jsonDecode(json);
    return UserEntity.fromJson(userMap);
  }

  @override
  Future<void> saveUser(UserEntity user) async {
    final json = jsonEncode(user);
    await localStorage.set('user', json);
  }

  @override
  Future<void> deletUser() async {
    await localStorage.remove('user');
  }
}
