import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_persistent_login/core/data/datasource/local/user_local_datasource.dart';
import 'package:flutter_persistent_login/core/data/datasource/remote/user_remote_datasource.dart';
import 'package:flutter_persistent_login/core/domain/entity/user_entity.dart';
import 'package:injectable/injectable.dart';

AuthErrorCode mapAuthenticationErrorCode(String code) {
  return switch (code) {
    'invalid-email' => AuthErrorCode.invalidEmail,
    'user-disabled' => AuthErrorCode.userDisabled,
    'user-not-found' => AuthErrorCode.userNotFound,
    'wrong-password' => AuthErrorCode.wrongPassword,
    'too-many-requests' => AuthErrorCode.tooManyRequests,
    'user-token-expired' => AuthErrorCode.userTokenExpired,
    'network-request-failed' => AuthErrorCode.networkRequestFailed,
    'invalid-credential' => AuthErrorCode.invalidCredential,
    'operation-not-allowed' => AuthErrorCode.operationNotAllowed,
    'email-already-in-use' => AuthErrorCode.emailAlreadyInUse,
    'weak-password' => AuthErrorCode.weakPassowrd,
    _ => AuthErrorCode.unknown,
  };
}

enum AuthErrorCode {
  invalidEmail,
  userDisabled,
  userNotFound,
  wrongPassword,
  tooManyRequests,
  userTokenExpired,
  networkRequestFailed,
  invalidCredential,
  operationNotAllowed,
  emailAlreadyInUse,
  weakPassowrd,
  unknown,
}

class AuthenticationException implements Exception {
  final AuthErrorCode code;

  AuthenticationException({required this.code});
}

abstract class AuthRepository {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signUp(String email, String password, String name);
  Future<void> logout();
}

@Injectable(as: AuthRepository)
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final UserRemoteDatasource _userRemoteDatasource;
  final UserLocalDatasource _userLocalDataSource;

  FirebaseAuthRepository(this._firebaseAuth, this._userRemoteDatasource, this._userLocalDataSource);

  @override
  Future<UserEntity> signIn(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Usuário não encontrado');
      }
      final user = await _userRemoteDatasource.getById(uid);

      if (user == null) {
        throw Exception('Usuário não encontrado');
      }
      await _userLocalDataSource.saveUser(user);

      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        code: mapAuthenticationErrorCode(e.code),
      );
    }
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw Exception('Erro ao criar usuário');
      }
      final user = UserEntity(id: uid, email: email, name: name);
      await _userRemoteDatasource.save(user);
      await _userLocalDataSource.saveUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        code: mapAuthenticationErrorCode(e.code),
      );
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _userLocalDataSource.deletUser();
  }
}
